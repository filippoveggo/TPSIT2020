import 'package:app_memo/data/database/dao/memo_dao.dart';
import 'package:app_memo/data/model/memo_local_model.dart';
import 'package:app_memo/domain/memo_domain_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class MemosRepository {
  final MemosDao memosDao;

  MemosRepository({
    @required this.memosDao,
  });

  Stream<MemosPageData> watchAllMemos() async* {
    yield* Rx.combineLatest3(
      memosDao.watchAllMemos(),
      memosDao.watchAllTags(),
      memosDao.watchAllMemosTags(),
      (
        List<MemoLocalModel> memos,
        List<TagLocalModel> tags,
        List<MemosTags> memosTags,
      ) {
        List<MemoDomainModel> domainMemos = [];

        final domainTags = tags
            .map(
              (e) => e.toDomainModel(),
            )
            .toList();

        final Map<String, TagDomainModel> tagsMap = Map.fromIterable(
          domainTags,
          key: (e) => e.id,
          value: (e) => e,
        );

        for (final memo in memos) {
          final tagsIds = memosTags.where((m) => m.memoId == memo.id);

          List<TagDomainModel> tags = [];

          for (final result in tagsIds) {
            tags.add(tagsMap[result.tagId]);
          }

          domainMemos.add(memo.toDomainModel(tags: tags));
        }

        return MemosPageData(
          memos: domainMemos,
          tags: domainTags,
        );
      },
    ).onErrorReturnWith((e) {
      print(e);
      return e;
    });
  }

  Future<void> insertMemo(MemoDomainModel memo) async {
    try {
      final tags = memo.tags;

      final localModel = memo.toLocalModel();

      List<TagLocalModel> localTags = [];
      List<TagLocalModel> localTagsToAdd = [];

      for (final tag in tags) {
        if (tag.id.isEmpty) {
          // è necessario aggiungerli al db
          final newTag = TagLocalModel(
            id: Uuid().v4(),
            title: tag.title,
          );

          localTagsToAdd.add(newTag);
          localTags.add(newTag);
        } else {
          localTags.add(tag.toLocalModel());
        }
      }

      await memosDao.insertTags(localTagsToAdd);

      List<MemosTags> memosTags = [];

      for (final localTag in localTags) {
        memosTags.add(
          MemosTags(
            id: null,
            memoId: memo.id,
            tagId: localTag.id,
          ),
        );
      }

      await memosDao.insertMemo(localModel);

      await memosDao.insertMemoTags(memosTags);

      // [memos] -> memo

      await FirebaseFirestore.instance
          .collection('memos')
          .doc(memo.id)
          .set(memo.toMap());

      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .update(
        {
          'memos': FieldValue.arrayUnion(
            [
              memo.id,
            ],
          ),
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteMemo(MemoDomainModel memo) async {
    try {
      await memosDao.deleteTagsForMemo(memo.id);
      await memosDao.deleteMemo(memo.toLocalModel());

      await FirebaseFirestore.instance
          .collection('memos')
          .doc(memo.id)
          .delete();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .update(
        {
          'memos': FieldValue.arrayRemove(
            [memo.id],
          ),
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> shareMemo(
    String id,
    String email,
    MemoDomainModel memo,
  ) async {
    try {
      final userIdToShare = (await FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: email)
              .get())
          .docs;

      if (userIdToShare.length == 1) {
        final userMemos = userIdToShare.first.data()['memos'] as List<dynamic>;
        if (userMemos.contains(id)) {
          return print('User already shared');
        }
        // allora abbiamo un utente
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userIdToShare.first.id)
            .update({
          'memos': FieldValue.arrayUnion([
            id,
          ])
        });
      } else {
        return print('Email not correct');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> syncWithRemote() async {
    try {
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .get();

      // tutti gli id delle memo dell'utente
      final List memoIds = userSnapshot.data()['memos'];

      final memosSnapshot =
          await FirebaseFirestore.instance.collection('memos').get();

      List<MemoDomainModel> domainMemos = [];

      for (final memoDocument in memosSnapshot.docs) {
        if (memoIds.contains(memoDocument.id)) {
          domainMemos.add(MemoDomainModel.fromMap(memoDocument.data()));
        }
      }

      List<TagLocalModel> tagsToAdd = [];
      List<MemoLocalModel> memosToAdd = [];
      List<MemosTags> memosTagsToAdd = [];

      await memosDao.deleteAllMemosTags();
      await memosDao.deleteAllMemos();
      await memosDao.deleteAllTags();
      // await memosLocalDatasource.deleteAllMemosTags();

      for (final memo in domainMemos) {
        final tags = memo.tags;
        print(tags);

        final localModel = memo.toLocalModel();

        List<TagLocalModel> localTags = [];
        List<TagLocalModel> localTagsToAdd = [];

        for (final tag in tags) {
          if (tag.id.isEmpty) {
            // è necessario aggiungerli al db
            final newTag = TagLocalModel(
              id: Uuid().v4(),
              title: tag.title,
            );

            localTagsToAdd.add(newTag);
            localTags.add(newTag);
          } else {
            localTags.add(tag.toLocalModel());
            localTagsToAdd.add(tag.toLocalModel());
          }
        }

        tagsToAdd.addAll(localTagsToAdd);

        List<MemosTags> memosTags = [];

        for (final localTag in localTags) {
          memosTags.add(
            MemosTags(
              id: null,
              memoId: memo.id,
              tagId: localTag.id,
            ),
          );
        }

        memosToAdd.add(localModel);
        memosTagsToAdd.addAll(memosTags);
      }

      print('set up, need to insert');

      // ora che abbiamo le memo dobbiamo aggiungerle al db corrente
      await memosDao.insertTags(tagsToAdd);

      await memosDao.insertMemos(memosToAdd);

      await memosDao.insertMemoTags(memosTagsToAdd);
    } catch (e) {
      print('Errore nel sync');
      print(e);
    }
  }

  Future<List<TagDomainModel>> getTags() async {
    try {
      final tags = await memosDao.getTags();
      return tags.map((e) => e.toDomainModel()).toList();
    } catch (e) {
      return e;
    }
  }

  Future updateMemo(MemoDomainModel memo) async {
    try {
      await FirebaseFirestore.instance
          .collection('memos')
          .doc(memo.id)
          .update(memo.toMap());

      await memosDao.updateMemo(memo.toLocalModel());
    } catch (e) {
      print(e);
    }
  }
}
