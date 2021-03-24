import 'package:app_memo/data/repository/memos_repository.dart';
import 'package:app_memo/di.dart';
import 'package:app_memo/domain/current_user.dart';
import 'package:app_memo/domain/memo_domain_model.dart';
import 'package:app_memo/pages/login/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../domain/memo_domain_model.dart';
import '../../domain/memo_domain_model.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MemosRepository memosRepository = sl();

  @override
  Widget build(BuildContext context) {
    final url = Provider.of<CurrentUser>(context)?.data?.photoURL;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'App Memo',
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.sync),
            onPressed: () async {
              final MemosRepository memosRepository = sl();

              try {
                memosRepository.syncWithRemote();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Errore aggiornamento')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Aggiornato con successo')),
                );
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();

              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: url != null ? NetworkImage(url) : null,
              child: url == null ? const Icon(Icons.face) : null,
              radius: 19,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          memosRepository.insertMemo(
            MemoDomainModel(
              id: Uuid().v4(),
              creator: 'filippoveggo@gmail.com',
              title: 'titolo2',
              tags: [
                TagDomainModel(
                  id: '',
                  title: 'dfs',
                )
              ],
              description: 'descrizione',
            ),
          );
        },
      ),
      body: StreamBuilder(
        stream: memosRepository.watchAllMemos(),
        initialData: null,
        builder: (BuildContext context, AsyncSnapshot<MemosPageData> snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final memos = snapshot.data.memos;
          final tags = snapshot.data.tags;

          return Text(tags.toString());
        },
      ),
    );
  }
}
