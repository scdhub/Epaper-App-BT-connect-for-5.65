import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../app_body_color.dart';
import '../bt_connect_page/connect_bt_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class SelectCheck extends StatefulWidget {
  final List<Uint8List?> imageData;

  const SelectCheck({Key? key, required this.imageData});

  @override
  State<SelectCheck> createState() => _SelectCheckState();
}

class _SelectCheckState extends State<SelectCheck> {
  Uint8List? path; //　選択中の画像を表示する
  bool _isWriting = false; //　書き込み中確認用
  final ScrollController _scrollController = ScrollController();

  //　png形式に変換する為にファイルとして、画像を保存する必要がある
  final List<File> files = [];

  @override
  void initState() {
    super.initState();
    path = widget.imageData[0]; //前画面から渡された画像の最初の写真をよみとる
    //渡されたデータを.pngファイル形式にする
    saveImages();
  }

  //選択した画像に変更する
  void changeImage(Uint8List pathN) {
    setState(() {
      path = pathN;
    });
  }

  //サーバーに画像をアップロード中の表示と登録完了後のメッセージ表示
  void uploadMessage() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            title: Text(
              _isWriting ? '画像登録中...' : '登録完了',
              textAlign: TextAlign.center,
            ),
            content: Text(
              _isWriting ? '' : 'E-paper配信関連に移りますか？',
              style: const TextStyle(fontSize: 20, color: Colors.black),
            ),
            actions: <Widget>[
              _isWriting
                  ? const CircularProgressIndicator()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const ConnectBTPage()));
                            },
                            child: const Text('OK'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.pop(context);
                            },
                            child: const Text('キャンセル'),
                          ),
                        ])
            ],
          );
        });
  }

  //サーバーとの接続確認後、登録失敗した時のメッセージを表示
  void missUploadMessage() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('登録エラー'),
            content: const Text('登録中に一時的な問題が発生しました。\nしばらくしてから再度お試しください。'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        });
  }

  //渡された画像を.png形式にする
  Future<void> saveImages() async {
    final directory = await getApplicationDocumentsDirectory();

    for (int i = 0; i < widget.imageData.length; i++) {
      final Uint8List? data = widget.imageData[i];
      if (data != null) {
        final String fileName = 'image_$i.png'; // ファイル名を生成
        final path = '${directory.path}/$fileName';
        final file = File(path);
        await file.writeAsBytes(data);
        files.add(file); // 保存したファイルをリストに追加
        if (kDebugMode) {
          print(files);
        }
      }
    }
  }

  //ファイルアップロード
  Future<void> postData(List<String?> uploadImages) async {
    //保存先URL
    Uri uri = Uri.parse(
        "https://3lewes86g0.execute-api.ap-northeast-1.amazonaws.com/dev/signed_url");
    //保存に必要な情報を定義
    final headers = {
      'Content-Type': 'application/json',
      'x-api-key': dotenv.get('API_KEY')
    };
    final body = {'images': uploadImages};
    // サーバーにpostする
    try {
      final response =
          await http.post(uri, headers: headers, body: jsonEncode(body));
      // 接続成功
      if (response.statusCode == 200) {
        // responseデータからデータを抜き取る
        final body = jsonDecode(response.body);
        final signedUrls = body['signed_urls'];
        for (var map in signedUrls) {
          for (var entry in map.entries) {
            if (kDebugMode) {
              print(entry);
            }
            // 画像パス
            final String imagePath = entry.key;
            // サーバーへのURL
            final String signedUrl = entry.value;
            final String filename = imagePath.split('/').last;
            putImageImpl(
                imagePath: imagePath, signedUrl: signedUrl, filename: filename);
          }
        }
        if (kDebugMode) {
          print('ファイルアップロード成功1！');
        }
      } else {
        if (kDebugMode) {
          print('ファイルアップロード失敗2: ${response.statusCode}');
        }
        setState(() {
          _isWriting = false;
          Navigator.of(context).pop();
          missAppSeverMessage(context);
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      setState(() {
        _isWriting = false;
        Navigator.of(context).pop();
        missAppSeverMessage(context);
      });
    }
  }

  // 画像を保存する
  Future<void> putImageImpl(
      {required String imagePath,
      required String signedUrl,
      required String filename}) async {
    final file = File(imagePath); // Fileオブジェクトを作成
    final byteData = await file.readAsBytes(); // Fileオブジェクトからバイトデータを読み込む
    final List<int> bytes = byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
    try {
      final response = await http.put(
        Uri.parse(signedUrl),
        headers: {
          'Content-Type': 'binary/octet-stream',
        },
        body: bytes,
      );
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('ファイルアップロード成功2！');
        }
        setState(() {
          _isWriting = false;
          Navigator.of(context).pop();
          uploadMessage();
        });
      } else {
        if (kDebugMode) {
          print('ファイルアップロード失敗3: ${response.statusCode}');
        }
        setState(() {
          _isWriting = false;
          Navigator.of(context).pop();
          missUploadMessage();
        });
      }
    } catch (e) {
      setState(() {
        _isWriting = false;
        Navigator.of(context).pop();
        missUploadMessage();
      });
    }
  }

  //書き込みダイアログを表示するための非同期
  Future<void> _showWriteDialog() async {
    setState(() {
      _isWriting = true;
      uploadMessage();
    });
    // サーバーに画像データを送る
    List<String> filePaths = files.map((file) => file.path).toList();
    await postData(filePaths);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            '画像登録確認',
            // style: TextStyle(fontSize: 20),
          ),
        ),
        body: CustomPaint(
            painter: HexagonPainter(),
            child: SizedBox(
                width: MediaQuery.of(context).size.width, // 画面の幅に合わせる
                height:
                    MediaQuery.of(context).size.height, // 画面の高さに合わせるContainer(

                child: Column(children: [
                  //   選択中の画像を表示
                  SizedBox(
                    // color:Colors.greenAccent,
                    width: 300,
                    height: 300,
                    child: Image.memory(
                      path!,
                    ),
                  ),
                  const Divider(),
                  Row(children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30), // ここで角の丸みを指定
                        color: Colors.grey, // 背景色
                      ),
                      child: IconButton(
                        // 押したら画像リストの最初の画像のある部分まで移動する
                        onPressed: () {
                          _scrollController.animateTo(
                            _scrollController.position.minScrollExtent,
                            duration: const Duration(seconds: 2),
                            curve: Curves.fastOutSlowIn,
                          );
                        },
                        icon: const Icon(
                          Icons.chevron_left,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      color: Colors.white38,

                      // color: Colors.white,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        //横にスクロールできるようにする
                        itemCount: widget.imageData.length,
                        physics: const BouncingScrollPhysics(),
                        controller: _scrollController,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0,
                            ),
                            child: scrollImage(widget.imageData[index]!),
                          );
                        },
                      ),
                    )),
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30), // ここで角の丸みを指定
                        color: Colors.grey, // 背景色
                      ),
                      child: IconButton(
                        // 押したら最後の画像がある部分まで移動する
                        onPressed: () {
                          _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: const Duration(seconds: 2),
                            curve: Curves.fastOutSlowIn,
                          );
                        },
                        icon: const Icon(Icons.chevron_right,
                            color: Colors.black),
                      ),
                    ),
                  ]),
                  const Divider(),

                  Container(
                      width: double.infinity,
                      height: 300,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(221, 57, 57, 57),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                          bottomLeft: Radius.circular(30.0),
                          bottomRight: Radius.circular(30.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('アプリに登録する',
                                  style: TextStyle(
                                      fontSize: 44,
                                      color: Colors.yellow[100],
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                width: double.infinity, //横幅
                                height: 60, //高さ
                                child: ElevatedButton(
                                  onPressed:
                                      _isWriting ? null : _showWriteDialog,
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.grey[300],
                                    onPrimary: Colors.purple,
                                    elevation: 10,
                                    shape: const StadiumBorder(),
                                  ),
                                  child: const Text('OK',
                                      style: TextStyle(
                                        fontSize: 40,
                                      )),
                                ),
                              ),
                              SizedBox(
                                width: double.infinity, //横幅
                                height: 60, //高さ
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.grey[300],
                                    onPrimary: Colors.purple,
                                    elevation: 10,
                                    shape: const StadiumBorder(),
                                  ),
                                  child: const Text('キャンセル',
                                      style: TextStyle(
                                        fontSize: 40,
                                      )),
                                ),
                              ),
                            ]),
                      )),
                ]))));
  }

  // 画面上部表示中の画像のListView内での表示
  Widget scrollImage(Uint8List pathN) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
        // 選択している画像は周りを赤くする
        color: path == pathN ? Colors.redAccent : Colors.white,
      )),
      child: GestureDetector(
        child: Image.memory(
          pathN,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
        // タップした画像に切り替える
        onTap: () {
          if (path != pathN) changeImage(pathN);
        },
      ),
    );
  }
}

//サーバーとの接続ができなかった時のエラーメッセージ表示
void missAppSeverMessage(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('登録エラー'),
          content: const Text('サービスが一時的に利用できません。\nしばらくしてから再度お試しください。'),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[Text('OK')],
                )),
          ],
        );
      });
}
