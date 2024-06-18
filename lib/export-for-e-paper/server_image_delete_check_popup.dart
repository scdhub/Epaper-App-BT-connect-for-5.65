import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'e_paper_send_picture_page.dart';

class ServerImageDelCheckPopup extends StatefulWidget {
  //top_pageから遷移
  // const ImageTypeSelection_popup({super.key});
  final List<DelData> selectDelImage;

  ServerImageDelCheckPopup({required this.selectDelImage});

  @override
  _ServerImageDelCheckPopupState createState() =>
      _ServerImageDelCheckPopupState();
}

class _ServerImageDelCheckPopupState extends State<ServerImageDelCheckPopup> {


  Future<void> postData(List<DelData> delId) async {
    //awsS3
    Uri uri =  Uri.parse(
        "https://gqj75id27l.execute-api.ap-northeast-1.amazonaws.com/dev/deletes"
    );
    final headers =  {'Content-Type': 'application/json','x-api-key':dotenv.get('API_KEY')};
    final body ={'ids': delId};

    final response = await http.post(uri, headers: headers, body: jsonEncode(body));
    if (response.statusCode == 200) {

      print('削除成功！');
    } else {
      print('削除失敗2: ${response.statusCode}');
    }
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      backgroundColor: Colors.yellow,
      title:
          // Text('スマホから画像を\nインポート方法選択',
          Text(
        '!　注意　！',
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        Column(
            children: [
              Text('選択した画像は、完全に削除されます。\n 復元はできません。\n本当に削除してもよろしいですか？'),

        ]),

        Divider(),
        Container(
          width: 300,
          alignment: Alignment.center,
          child: Row(
              children:[

                TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child:
              const Text(
              'キャンセル',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),

          ),
                TextButton(
                  // onPressed: () => Navigator.pop(context, 'OK'),
                  onPressed: (){
                    List<DelData> delId = [];
                    for (var item in widget.selectDelImage) {
                    delId.add(item);
    }

                    postData(delId);
                  },
                  child:
                  const Text(
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
