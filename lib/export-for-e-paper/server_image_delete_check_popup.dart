import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

// import 'e_paper_send_picture_page.dart';
import 'sever_data_bind.dart';

class ServerImageDelCheckPopup extends StatefulWidget {
  final List<DelData> selectDelImage;

  const ServerImageDelCheckPopup({super.key, required this.selectDelImage});

  @override
  State<ServerImageDelCheckPopup> createState() =>
      _ServerImageDelCheckPopupState();
}

class _ServerImageDelCheckPopupState extends State<ServerImageDelCheckPopup> {
  // Future<void> postData(List<DelData> delId) async {
  Future<void> postData(List<String> delId) async {
    //idのみ渡す場合。
    //awsS3
    Uri uri = Uri.parse(
        "https://gqj75id27l.execute-api.ap-northeast-1.amazonaws.com/dev/deletes");
    final headers = {
      'Content-Type': 'application/json',
      'x-api-key': dotenv.get('API_KEY')
    };
    final body = {'ids': delId};
    try {
      final response =
          await http.post(uri, headers: headers, body: jsonEncode(body));
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('削除成功！');
        }
        Navigator.pop(context);
      } else {
        if (kDebugMode) {
          print('削除失敗2: ${response.statusCode}');
        }
        Navigator.pop(context);
      }
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      backgroundColor: Colors.yellow,
      title:
          // Text('スマホから画像を\nインポート方法選択',
          const Text(
        '!　注意　！',
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        const Column(children: [
          Text('選択した画像は、完全に削除されます。\n 復元はできません。\n本当に削除してもよろしいですか？'),
        ]),
        const Divider(),
        Container(
          width: 300,
          alignment: Alignment.center,
          child: Row(children: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text(
                'キャンセル',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
            TextButton(
              // onPressed: () => Navigator.pop(context, 'OK'),
              onPressed: () {
                // List<DelData> delId = [];
                List<String> delId = [];
                for (var item in widget.selectDelImage) {
                  delId.add(item.idDel);
                }
                postData(delId);
                Navigator.pop(context, 'OK');
              },
              child: const Text(
                'OK',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
          ]),
        ),
      ],
    );
  }
}
