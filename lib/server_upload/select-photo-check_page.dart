import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iphone_bt_epaper/theme.dart';
// import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../bt_connect_page/connect_bt_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;



class SelectCheck extends StatefulWidget {
  final List<Uint8List?> imageData;

const SelectCheck({Key? key, required this.imageData}) : super(key: key);

// class SelectCheck extends StatefulWidget {
//   final List<Uint8List?> imageData;
//   const SelectCheck({Key? key, required this.imageData});

  @override
  State<SelectCheck> createState() => _SelectCheckState();
}

class _SelectCheckState extends State<SelectCheck> {
  Uint8List? path; //　選択中の画像を表示する
  bool _isWriting = false; //　書き込み中確認用
  final List<File> files = [];
  final ScrollController _scrollController = ScrollController(); // 横スクロール用コントローラー
  List<Uint8List?> selectedImages = []; // 複数選択を管理するリスト


  //png形式に変換する為にファイルとして、画像を保存する必要がある
  // final List<File> files = [];

  @override
  void initState() {
    super.initState();
    if (widget.imageData.isNotEmpty && widget.imageData[0] != null) {
      path = cropImage(widget.imageData[0]!);
    }
    // path = widget.imageData[0]; //前画面から渡された画像の最初の写真をよみとる
    //渡されたデータを.pngファイル形式にする
    saveImages();
  }

  //画像のトリミング処理を行う
  Uint8List cropImage(Uint8List originalImage) {
    img.Image? image = img.decodeImage(originalImage);
    if (image == null) return originalImage;

    int targetWidth = 600;
    int targetHeight = 448;

    if (image.width > targetWidth || image.height > targetHeight) {
      image = img.copyResize(image, width: targetWidth, height: targetHeight);
    }
    return Uint8List.fromList(img.encodePng(image));
  }


  //選択した画像に変更する
  //**選択画像の変更（トリミング付き）**
  void changeImage(Uint8List pathN) {
    setState(() {
      path = cropImage(pathN);
    });
  }

  // void changeIawait 遷移mage(Uint8List pathN) {
  //   setState(() {
  //     path = pathN;
  //   });
  // }

  // **画像を `.png` にして保存**
  Future<void> saveImages() async {
    final directory = await getApplicationDocumentsDirectory();
    for (int i = 0; i < widget.imageData.length; i++) {
      final Uint8List? data = widget.imageData[i];
      if (data != null) {
        Uint8List processedData = cropImage(data);
        final String fileName = 'image_$i.png';
        final path = '${directory.path}/$fileName';
        final file = File(path);
        await file.writeAsBytes(processedData);
        files.add(file);
      }
    }
  }

  // **画像アップロード処理**
  Future<void> new_postData(List<String?> uploadImages) async {
    // AWSアップロードの処理（省略）
  }


  // // ダイアログを表示　
  void uploadMessage() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            //  `setState` をグローバル変数に保存
            updateDialogState = setState;

            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // 角の丸み調整
              ),
              title: Center(
                child: _isWriting
                    ? const SizedBox() // 画像登録中はタイトルを表示しない
                    : Text(
                  '登録完了',
                  style: AppTheme.dialogTitleStyle, // タイトルのスタイル
                ),
              ),
              content: Padding( // 余白の調整
                padding: const EdgeInsets.all(16.0), // ダイアログ内の余白
                child: SizedBox(
                  width: 250, // 幅を調整
                  height: 150, // 高さを調整
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //動作
                      if (_isWriting)
                        const CircularProgressIndicator(), // 画像登録中にインジケーター表示

                      if (!_isWriting)
                        Text(
                          'BTスキャン＆E-paper配信関連に移りますか？',
                          style: AppTheme.dialogContentStyle, // 本文のスタイル
                        ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 「はい」ボタン
                          Expanded(
                            child: SizedBox(
                              width: 100, // ボタンの横幅を統一
                              child: ElevatedButton(
                                style: AppTheme.dialogYesButtonStyle, // ボタンのスタイル
                                onPressed: _isWriting
                                    ? null // 画像登録中は無効
                                    : () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const ConnectBTPage(),
                                    ),
                                  );
                                },
                                child: const Text('はい',
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10), // ボタン間に隙間を空ける
                          // 「いいえ」ボタン
                          Expanded(
                            child: SizedBox(
                              width: 100,
                              child: ElevatedButton(
                                style: AppTheme.dialogNoButtonStyle, // ボタンのスタイル
                                onPressed: _isWriting
                                    ? null // 画像登録中は無効
                                    : () {
                                  Navigator.of(context).pop(); // ダイアログを閉じる
                                },
                                child: const Text('いいえ',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

// `StatefulBuilder` の `setState` を保存するためのグローバル変数
  late StateSetter updateDialogState;

  // void uploadMessage() {
  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Center(
  //         child: StatefulBuilder(
  //           builder: (BuildContext context, StateSetter setState) {
  //             return AlertDialog(
  //               backgroundColor: Colors.white,
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(20),
  //               ),
  //             title: Center(
  //               child : _isWriting
  //                   ? const Text('画像登録中...', // 登録中
  //                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
  //                   : const Text('登録完了', // 完了後
  //                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
  //             ),
  //               content: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   if (_isWriting) const CircularProgressIndicator(), // 進行中はインジケーター表示
  //                   if (!_isWriting) const Text('BTスキャン＆E-paper配信関連に移りますか？'),
  //                   const SizedBox(height: 15),
  //                   Wrap(
  //                     spacing: 10, // ボタン間の間隔
  //                     runSpacing: 10, // 折り返した際の間隔
  //                     alignment: WrapAlignment.center,
  //                     children: [
  //                       SizedBox(
  //                         width: 100, // ボタンの横幅を統一
  //                         child: ElevatedButton(
  //                           style: AppTheme.dialogYesButtonStyle,
  //                           onPressed: _isWriting
  //                               ? null // 画像登録中は無効
  //                               : () {
  //                             Navigator.of(context).push(
  //                               MaterialPageRoute(
  //                                 builder: (context) => const ConnectBTPage(),
  //                               ),
  //                             );
  //                           },
  //                           child: const Text('はい',
  //                               style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
  //                         ),
  //                       ),
  //                       SizedBox(
  //                         width: 100,
  //                         child: ElevatedButton(
  //                           style: AppTheme.dialogNoButtonStyle,
  //                           onPressed: _isWriting
  //                               ? null // 画像登録中は無効
  //                               : () {
  //                             Navigator.of(context).pop(); // ダイアログを閉じる
  //                           },
  //                           child: const Text('いいえ',
  //                               style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             );
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

// 画像アップロード処理を非同期で行う
  Future<void> _showWriteDialog() async {
    setState(() {
      _isWriting = true; // アップロード開始
    });
    uploadMessage(); // 進行中ダイアログを表示

    // サーバーに画像データを送る処理
    List<String> filePaths = files.map((file) => file.path).toList();

    try {
      await postData(filePaths);

      // アップロード完了後に状態を更新してダイアログの内容を切り替える
      setState(() {
        _isWriting = false; // アップロード完了
      });

      // // ダイアログの状態が切り替わるように更新
      // Navigator.of(context).pop(); // ダイアログを閉じる
      // uploadMessage(); // 完了ダイアログを表示（ダイアログは1回のみ）

    } catch (e) {
      setState(() {
        _isWriting = false; // アップロード失敗
      });
      Navigator.of(context).pop(); // ダイアログを閉じる
      missUploadMessage(); // アップロード失敗メッセージを表示
    }
  }


//
//
//
//   //サーバーに画像をアップロード中の表示と登録完了後のメッセージ表示
//   void uploadMessage() {
//     showDialog(
//         barrierDismissible: false,
//         context: context,
//         builder: (BuildContext context) {
//           return Center(
//             child: AlertDialog(
//               backgroundColor: Colors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//
//               title:_isWriting //登録中はnull,なので登録中は登録完了テキストは表示されない
//               ?null
//               :const Text('登録完了',
//                 style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//             ),
//                 textAlign: TextAlign.center,
//           ),
//                 // _isWriting ? '画像登録中...' : '登録完了',
//                 //書き込み中の状況に応じて動作が変更
//               //     TextStyle(
//               //     fontSize: 25,
//               //     color: Colors.black,),
//               //   textAlign: TextAlign.center,
//               // ),
//
//               // content: _isWriting//登録中はタイトルが消える。
//               //     ? const Padding(
//               //   padding: EdgeInsets.symmetric(vertical: 20),
//               //   child: Center(child: CircularProgressIndicator()),
//               // )
//
//                  content : Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   if (_isWriting)
//                     const CircularProgressIndicator(), // 画像登録中なので〇のぐるぐるが表示されている
//                   Text('BTスキャン＆E-paper配信関連に移りますか？',
//                     style: AppTheme.dialogContentStyle,//theme.dartのスタイルを使用
//                     textAlign: TextAlign.center,
//                     //   const TextStyle(
//                     //     fontSize: 18,
//                     //     color: Colors.black),
//
//                   ),
//                   const SizedBox(height: 15),
//
//                   Wrap(
//                       spacing: 10, // ボタン間の間隔
//                       runSpacing: 10, // 折り返した際の間隔
//                       alignment: WrapAlignment.center,
//                       children: [
//                         SizedBox(
//                           width: 100, // ボタンの横幅を統一
//                           child: ElevatedButton(
//                             style:AppTheme.dialogYesButtonStyle,
//                               // ElevatedButton.styleFrom(
//                               // backgroundColor: const Color(0xFFFFA7A7),
//                               // shape: RoundedRectangleBorder(
//                               //   borderRadius: BorderRadius.circular(10),
//                               // ),
//                             // ),
//                             onPressed: _isWriting
//                                 ? null // 画像登録中は無効
//                                 : () {
//                               Navigator.of(context).push(
//                                 MaterialPageRoute(
//                                   builder: (context) => const ConnectBTPage(),
//                                 ),
//                               );
//                             },
//
//                             child: const Text('はい',
//                               style: TextStyle(
//                                   fontWeight:
//                                   FontWeight.bold,
//                                   color: Colors.white),
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           width: 100,
//                           child: ElevatedButton(
//                             style:AppTheme.dialogNoButtonStyle,//theme.dartのスタイルを使用
//
//                             // TextButton.styleFrom(
//                               // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                               // backgroundColor: const Color(0xFFB0C4DE),
//                               // shape: RoundedRectangleBorder(
//                               //   borderRadius: BorderRadius.circular(
//                               //       10), // 丸いボタン
//                               // ),
//                             // ),
//                             onPressed: _isWriting
//                             ? null // 画像登録中は無効
//                              : () {
//                               Navigator.of(context).pop();
//                               Navigator.pop(context);
//                             },
//                             child: const Text(
//                               "いいえ",
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold),
//                               // TextButton(
//                               //   onPressed: () {
//                               //     Navigator.of(context).pop();
//                               //     Navigator.pop(context);
//                               //   },
//                               //   child: const Text('いいえ',
//                               //     style: TextStyle(fontWeight: FontWeight.bold,
//                               //         color: Colors.white),),
//                               //   style: TextButton.styleFrom(
//                               //     padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                               //     backgroundColor: const Color(0xFFB0C4DE),
//                               //     shape: RoundedRectangleBorder(
//                               //     borderRadius: BorderRadius.circular(10), // 丸いボタン
//                             ),
//                           ),
//                         ),
//                       ]
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//   }
//
//
// // 画像アップロード処理を非同期で行う
//   //ここで二つ出てしまっている・・・
//   Future<void> _showWriteDialog() async {
//     setState(() {
//       _isWriting = true; // アップロード開始
//     });
//     uploadMessage(); // 1つめのダイアログを表示
//
//     // サーバーに画像データを送る処理
//     List<String> filePaths = files.map((file) => file.path).toList();
//
//     try {
//       await postData(filePaths);
//
//       // アップロード完了後に状態を更新してダイアログを閉じる
//       setState(() {
//         _isWriting = false; // アップロード完了
//       });
//
//       Navigator.of(context).pop(); // 1つめのダイアログを閉じる
//       // uploadMessage(); // ★　再度、完了ダイアログを表示
//
//     } catch (e) {
//       setState(() {
//         _isWriting = false; // アップロード失敗
//       });
//       Navigator.of(context).pop(); // ダイアログを閉じる
//       missUploadMessage(); // アップロード失敗メッセージを表示
//     }
//   }

  //サーバーとの接続確認後、登録失敗した時のメッセージを表示
  void missUploadMessage() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              titleTextStyle: TextStyle(
                fontSize: 20,
                color: Colors.red,
              ),
              contentTextStyle: TextStyle(
                fontSize: 15,
                color: Colors.black, // メッセージの文字色
              ),
              actionsAlignment: MainAxisAlignment.center,
              title: const Text('登録エラー',
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              content: const Text(
                '登録中に一時的な問題が発生しました。\nしばらくしてから再度お試しください。',
                style: TextStyle(
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
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
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ]
          );
        });
  }

  //渡された画像を.png形式にする
  Future<void> savePrpcessedImages() async {
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
            final String filename = imagePath
                .split('/')
                .last;
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
  Future<void> putImageImpl({
    required String imagePath,
    required String signedUrl,
    required String filename
  }) async {
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

        // // ここで `uploadMessage();` を呼ばず、ダイアログは開いたまま更新する
        //       setState(() {
        //         _isWriting = false;
        //         Navigator.of(context).pop();
        //         UploadMessage();
        updateDialogState(() {
          _isWriting = false; // UIを更新（登録完了）
        });

        //[missUploadMessage]
        //エラーが発生した際にエラーメッセージを表示する関数であり、その目的が明確に伝わる名前にすることを意図
      } else {
        if (kDebugMode) {
          print('ファイルアップロード失敗3: ${response.statusCode}');
        }
        updateDialogState(() {
          _isWriting = false;
        });
        missUploadMessage();
      }
      //エラーメッセージ
    } catch (e) {
      updateDialogState(() {
        _isWriting = false;
      });
      missUploadMessage();
    }
  }


        // setState(() {
        //   _isWriting = false;
        //   Navigator.of(context).pop();
        //   uploadMessage();
        // });
        //
  //
  //     } else {
  //       if (kDebugMode) {
  //         print('ファイルアップロード失敗3: ${response.statusCode}');
  //       }
  //       setState(() {
  //         _isWriting = false;
  //         Navigator.of(context).pop();
  //         UploadMessage();
  //       });
  //     }
  //   } catch (e) {
  //     setState(() {
  //       _isWriting = false;
  //       Navigator.of(context).pop();
  //       UploadMessage();
  //     });
  //   }
  // }

  // //書き込みダイアログを表示するための非同期
  // Future<void> _showWriteDialog() async {
  //   setState(() {
  //     _isWriting = true;
  //     uploadMessage();
  //   });
  //   // サーバーに画像データを送る
  //   List<String> filePaths = files.map((file) => file.path).toList();
  //   await postData(filePaths);
  // }

  // scrollImageメソッド
  Widget scrollImage(Uint8List pathN) {
    bool isSelected = selectedImages.contains(pathN); // 画像が選択されているかチェック

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? Colors.redAccent : Colors.white, // 選択された画像には赤い枠
        ),
      ),
      child: GestureDetector(
        child: Image.memory(
          pathN,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
        onTap: () {
          setState(() {
            if (isSelected) {
              selectedImages.remove(pathN); // 既に選択されていたらリストから削除
            } else {
              selectedImages.add(pathN); // 新たに選択
            }
          });
        },
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '画像登録確認',
          // style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
          // style: TextStyle(fontSize: 20),
        ),
      ),
      body: Container( //CustomPaint(
        width: double.infinity,
        padding: EdgeInsets.all(16.0),
        // painter: HexagonPainter(),
        child: Column(
          //SizedBox(
          mainAxisAlignment: MainAxisAlignment.center, // 画面の幅に合わせる
          // 画面の高さに合わせるContainer(
          children: [
            //   選択中の画像を表示.撮影時の写真を表示
            SizedBox(
              // color:Colors.greenAccent,
              width: 300, //300
              height: 400, //300
              child: Image.memory(
                path!, fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20,),


            // const Divider(),
            Row(children: [
              Container(  // ここを Container に変更,直接高さと横が記載されていた
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
              )],
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
            ),
            ),

            // 登録選択のデザイン
            Container(
              height: 35,
              width: 35,
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
                // ),
              ),
            ),
            const Divider(),

            //登録選択
            Container(
              width: double.infinity, //自動
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              // decoration: const BoxDecoration(
              //   color: Color.fromARGB(221, 57, 57, 57),
              //   borderRadius: BorderRadius.only(
              //     topLeft: Radius.circular(30.0),
              //     topRight: Radius.circular(30.0),
              //     bottomLeft: Radius.circular(30.0),
              //     bottomRight: Radius.circular(30.0),
              //   ),
              // ),
              child: Column( //Padding(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('アプリに登録しますか？', style:
                  TextStyle(
                      fontSize: 24, //30
                      color: Color(0xFF29B6F6),
                      fontWeight: FontWeight.bold)
                  ),
                  SizedBox(height: 25),


                  //padding: const EdgeInsets.all(20.0),
                  // child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: [
                  //       Text('アプリに登録する',
                  //           style: TextStyle(
                  //               fontSize: 24,//30
                  //               color: Colors.white,
                  //               fontWeight: FontWeight.bold)),


                  //はい
                  SizedBox(
                    width: double.infinity, //横幅
                    height: 50, //高さ
                    child: ElevatedButton(
                      onPressed: () {
                        _showWriteDialog(); // 画像アップロード処理を開始
                      },
                      // _isWriting ? null : _showWriteDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  Color(0xFFF06292),
                        side: BorderSide(color: Color(0xFFD81B60), width: 3),
                        foregroundColor: Colors.white, //「登録する」の色
                        // elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text('登録する', //Ok
                          style: TextStyle(
                            fontSize: 16,),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8,),

                  //いいえボタン
                  SizedBox(
                    width: double.infinity, //横幅
                    height: 50, //50 高さ
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1E88E5),
                        side: BorderSide(color: Color(0xFF3D5AFE), width: 3),
                        foregroundColor: Colors.white, //「登録しない」の色
                        // elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15), //20
                        ),
                      ),
                      child: const Text('登録しない', //キャンセル
                        style: TextStyle(
                            fontSize: 16), //28
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


  //                                     )),
  //                               ),
  //                             ),
  //                           ]),
  //                     )),
  //               ]))));
  // }
  //
  // //画面上部表示中の画像のListView内での表示
  // Widget scrollImage(Uint8List pathN) {
  //   return Container(
  //     decoration: BoxDecoration(
  //         border: Border.all(
  //       // 選択している画像は周りを赤くする
  //       color: path == pathN ? Colors.redAccent : Colors.white,
  //     )),
  //     child: GestureDetector(
  //       child: Image.memory(
  //         pathN,
  //         width: 100,
  //         height: 100,
  //         fit: BoxFit.cover,
  //       ),
  //       // タップした画像に切り替える
  //       onTap: () {
  //         if (path != pathN) changeImage(pathN);
  //       },
  //     ),
  //   );
  // }

//サーバーとの接続ができなかった時のエラーメッセージ表示
void missAppSeverMessage(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text('登録エラー',
              style: TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20
              ),
            ),
          ),

          //エラーメッセージ
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text
              ('サービスが一時的に利用できません。\nしばらくしてから再度お試しください。',
              style: TextStyle(
          color: Colors.black,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),

              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(onPressed: () {
                  Navigator.of(context).pop();
                },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // エラー感を出す赤いボタン
                  ),

                  child: const Text('OK', style: TextStyle(
                      color: Colors.white
                  ),
                  ),
                ),
              ),
            ],
          ),
        );
      });
}