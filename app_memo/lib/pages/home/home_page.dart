import 'package:app_memo/data/repository/memos_repository.dart';
import 'package:app_memo/di.dart';
import 'package:app_memo/domain/current_user.dart';
import 'package:app_memo/domain/memo_domain_model.dart';
import 'package:app_memo/pages/home/add_memo.dart';
import 'package:app_memo/pages/home/memo_page.dart';
import 'package:app_memo/pages/login/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
                  SnackBar(content: Text('Aggiornato con successo')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Errore nell'aggiornamento")),
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
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddMemo(),
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
          } else if (snapshot.data.memos.isEmpty) {
            return Center(
              child: SvgPicture.asset('./assets/illustrations/404.svg'),
            );
          }
          final memos = snapshot.data.memos;
          final tags = snapshot.data.tags;

          return ListView.builder(
            itemCount: memos.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(12.0),
                    color: Color.fromRGBO(188, 189, 192, 0.6),
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MemoPage(
                            memo: memos[index],
                          ),
                        ),
                      );
                    },
                    title: Text(
                      memos[index].title,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        Text(
                          'Tags: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          memos[index]
                              .tags
                              .map((e) => e != null ? e.title : '')
                              .join(', '),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
