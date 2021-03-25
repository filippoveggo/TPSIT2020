import 'package:app_memo/data/repository/memos_repository.dart';
import 'package:app_memo/domain/memo_domain_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../di.dart';

class ShareMemo extends StatefulWidget {
  final MemoDomainModel memo;
  ShareMemo({
    Key key,
    @required this.memo,
  }) : super(key: key);

  @override
  _ShareMemoState createState() => _ShareMemoState();
}

class _ShareMemoState extends State<ShareMemo> {
  TextEditingController _emailEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final MemosRepository memosRepository = sl();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Condividi memo',
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              memosRepository.shareMemo(widget.memo.id, _emailEditingController.text, widget.memo);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _emailEditingController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(),
            ),
            labelText: 'Email',
            counter: SizedBox(),
            prefixIcon: const Icon(
              Icons.email,
            ),
          ),
          maxLines: null,
          maxLength: 1024,
          textCapitalization: TextCapitalization.sentences,
        ),
      ),
    );
  }
}
