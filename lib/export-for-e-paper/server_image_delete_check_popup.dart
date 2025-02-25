import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

// import 'e_paper_send_picture_page.dart';
import 'sever_data_bind.dart';

class ServerImageDelCheckPopup extends StatefulWidget {
  final List<DelData> selectDelImage;
  final Future<void> Function() fetchData;

  const ServerImageDelCheckPopup(
      {super.key, required this.selectDelImage, required this.fetchData});

  @override
  State<ServerImageDelCheckPopup> createState() =>
      _ServerImageDelCheckPopupState();
}

class _ServerImageDelCheckPopupState extends State<ServerImageDelCheckPopup> {
  Future<int> postData(List<String> delId) async {
    //idのみ渡す場合。
    //awsS3
    Uri uri = Uri.parse(
        "https://3lewes86g0.execute-api.ap-northeast-1.amazonaws.com/dev/deletes");
    final headers = {
      'Content-Type': 'application/json',
      'x-api-key': dotenv.get('API_KEY')
    };
    final body = {'ids': delId};
    try {
      final response =
          await http.delete(uri, headers: headers, body: jsonEncode(body));
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('削除成功！');
        }
        Navigator.pop(context);
      } else {
        if (kDebugMode) {
          print('削除失敗2: ${response.statusCode}');
          print('headers: ${response.headers}');
          print('body: ${response.body}');
        }
        Navigator.pop(context);
      }
      return response.statusCode;
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
      return 500; //例外で500エラーを返す
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      backgroundColor: const Color(0xffF6B17A),
      title:
          // Text('スマホから画像を\nインポート方法選択',
          const Text(
        '!　注意　！',
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('選択した画像は、完全に削除されます。\n 復元はできません。\n本当に削除してもよろしいですか？'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () async {
                  List<String> delId = [];
                  for (var item in widget.selectDelImage) {
                    delId.add(item.idDel);
                  }
                  showLoadingModal(context);
                  final status = await postData(delId); //☆同期的な実行？☆
                  Navigator.of(context).pop();
                  //削除成功と失敗の分岐
                  if (status == 200) {
                    showSuccessModal(context);
                  } else {
                    showFailedModal(context);
                  }
                  await widget.fetchData();
                },
                child: const Text(
                  'OK',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text(
                  'キャンセル',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

void showSuccessModal(BuildContext context) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        title: const Text(
          '削除が成功しました!',
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'OK',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void showFailedModal(BuildContext context) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        title: const Text(
          '削除が失敗しました!',
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'OK',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void showLoadingModal(BuildContext context) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      // ignore: deprecated_member_use
      return WillPopScope(
        onWillPop: () async => false,
        child: const AlertDialog(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 30),
              Text('Loading'),
            ],
          ),
        ),
      );
    },
  );
}
