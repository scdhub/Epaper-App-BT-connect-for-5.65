import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

// import 'e_paper_send_picture_page.dart';
import '../theme.dart';
import 'sever_data_bind.dart';

class ServerImageDelCheckPopup extends StatefulWidget {
  final List<ImageItem> selectDelImage;
  final Future<void> Function(int) fetchData;

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

  //デザインはtheme.dartで統一
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      backgroundColor: Colors.white,
      title:
          // Text('スマホから画像を\nインポート方法選択',
          const Text('注意',
            style: AppTheme.warningDialogTitleStyle,
            textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('選択した画像は\n完全に削除されます。\n 復元はできません。\n削除しますか？',
            style: AppTheme.warningDialogContentStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                style: AppTheme.dialogYesButtonStyle, // OKボタンのスタイル適用
                onPressed: () async {
                  List<String> delId = [];
                  for (var item in widget.selectDelImage) {
                    delId.add(item.id);
                  }
                  showLoadingModal(context);
                  final status = await postData(delId);
                  Navigator.of(context).pop();
                  //削除成功と失敗の分岐
                  if (status == 200) {
                    showSuccessModal(context);
                  } else {
                    showFailedModal(context);
                  }
                  await widget.fetchData(status);
                },

                child: const Text(
                  'はい',//OK
                ),
              ),

              const SizedBox(width: 10,),


              ElevatedButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                style: AppTheme.dialogNoButtonStyle,
                child: const Text(
                  'いいえ',//キャンセル
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
        title: Text(
          '削除が成功しました!',
          style: AppTheme.dialogContentStyle,
          textAlign: TextAlign.center,
        ),

        actions: <Widget>[
          TextButton(
            style: AppTheme.dialogYesButtonStyle,
            child: const Text(
              'OK',
              style: TextStyle(fontSize: 16, color: Colors.white),
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
        title: Text(
          '削除が失敗しました!',
          style: AppTheme.dialogContentStyle,
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          TextButton(
            style: AppTheme.dialogYesButtonStyle,
            child: const Text(
              'OK',
              style: TextStyle(fontSize: 20, color: Colors.white),
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
        child: AlertDialog(
          backgroundColor: Colors.white, // 背景を白
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.black),  backgroundColor: Colors.white70,),
              const SizedBox(width: 30),
              Text('Loading...',
                style: AppTheme.dialogContentStyle,
              ),
            ],
          ),
        ),
      );
    },
  );
}
