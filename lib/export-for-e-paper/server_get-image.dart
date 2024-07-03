//サーバーからデータを読み取る
import 'dart:convert';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:iphone_bt_epaper/server_upload/select-photo-check_page.dart';
import 'sever_data_bind.dart';

Future<void> getImage({
  required BuildContext context,
  required List<ImageItem> imageItems,
  required List<ReversedData> reverseData,
  required List<DateSort> dateSort,
}) async {
  //awsサーバーからデータを読み取る
  Uri uri = Uri.parse(
      // "https://uvky3v6bmi.execute-api.ap-northeast-1.amazonaws.com/dev/images");
      "https://gqj75id27l.execute-api.ap-northeast-1.amazonaws.com/dev/images");
  final headers = {'x-api-key': dotenv.get('API_KEY')};
  try {
    // //サーバーからデータを読み取る
    final response = await http.get(uri, headers: headers).timeout(
          const Duration(seconds: 60),
        );
    if (response.statusCode == 200) {
      // httpレスポンスをJSON変換
      final body = jsonDecode(response.body);
      // レスポンスデータ中の'data'部(画像IDと画像URLのリスト)を取得
      final data = body['data'];
      imageItems.clear(); //リストをクリア
      reverseData.clear(); //リストをクリア
      dateSort.clear(); //リストをクリア
      // 日付順で並べる処理を入れる

      data.forEach((item) {
        dateSort.add(DateSort(
            idD: item['id'],
            url: item['url'],
            lastModifiedD: item['last_modified']));
      });
      // 古い順に並び変える
      dateSort.sort((a, b) {
        return a.lastModifiedD
            .compareTo(b.lastModifiedD); // nullでないことが確認されたので、安全にcompareToを呼び出す
      });
      //古い順を挿入
      for (var item in dateSort) {
        imageItems.add(ImageItem(
            id: item.idD, url: item.url, lastModified: item.lastModifiedD));
      }
      // 新しい順として挿入
      for (var item in imageItems.reversed) {
        reverseData.add(ReversedData(
            idR: item.id, url: item.url, lastModifiedR: item.lastModified));
      }
    }
  } catch (e) {
    missAppSeverMessage(context);
  }
}
