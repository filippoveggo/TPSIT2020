import 'package:app_memo/data/repository/memos_repository.dart';
import 'package:app_memo/domain/memo_domain_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../di.dart';

class AddMemo extends StatefulWidget {
  AddMemo({Key key}) : super(key: key);

  @override
  _AddMemoState createState() => _AddMemoState();
}

class _AddMemoState extends State<AddMemo> {
  TextEditingController _titleEditingController = TextEditingController();
  TextEditingController _descriptionEditingController = TextEditingController();
  TextEditingController _tagsEditingController = TextEditingController();
  List<TagDomainModel> _items = [];

  @override
  Widget build(BuildContext context) {
    final MemosRepository memosRepository = sl();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Aggiungi memo',
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              List<String> tags = _tagsEditingController.text.split(' ');
              for (var tag in tags) {
                TagDomainModel model = TagDomainModel(id: '', title: tag);
                _items.add(model);
              }
              print(_items.toString());
              memosRepository.insertMemo(
                MemoDomainModel(
                  id: Uuid().v4(),
                  creator: FirebaseAuth.instance.currentUser.email,
                  title: _titleEditingController.text,
                  tags: _items,
                  description: _descriptionEditingController.text,
                ),
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleEditingController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
                labelText: 'Titolo',
                counter: SizedBox(),
                prefixIcon: const Icon(
                  Icons.title,
                ),
              ),
              maxLines: null,
              maxLength: 1024,
              textCapitalization: TextCapitalization.sentences,
            ),
            TextField(
              controller: _descriptionEditingController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
                labelText: 'Contenuto',
                alignLabelWithHint: true,
                counter: SizedBox(),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(bottom: 172),
                  child: const Icon(
                    Icons.subject,
                  ),
                ),
              ),
              maxLines: 10,
              maxLength: 2048,
              textCapitalization: TextCapitalization.sentences,
            ),
            TextField(
              controller: _tagsEditingController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
                labelText: 'Tag',
                counter: SizedBox(),
                prefixIcon: const Icon(
                  Icons.tag,
                ),
              ),
              maxLines: null,
              maxLength: 1024,
              textCapitalization: TextCapitalization.sentences,
            ),
          ],
        ),
      ),
    );
  }
}
