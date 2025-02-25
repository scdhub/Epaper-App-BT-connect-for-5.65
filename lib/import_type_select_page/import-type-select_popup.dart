import 'package:flutter/material.dart';
import 'package:iphone_bt_epaper/text_input_page/text_fonts_size.dart';
import '../crop_page/crop_photo-select.dart';
import '../server_upload/photo-select_page.dart';
import 'take-photo_page.dart';

//top_pageから遷移
class ImageTypeSelection_popup extends StatefulWidget {
  const ImageTypeSelection_popup({super.key});

  @override
  State<ImageTypeSelection_popup> createState() =>
      _ImageTypeSelection_popupState();
}

class _ImageTypeSelection_popupState extends State<ImageTypeSelection_popup> {
  @override
  //方法選択のウェジェット
  Widget build(BuildContext context) {
    return Dialog(
      // child: AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 10,
      backgroundColor: Colors.white,
      // 背景
        child: ConstrainedBox( // 高さを制御する
          constraints: BoxConstraints(
            maxHeight: MediaQuery
                .of(context)
                .size
                .height * 0.4, // 画面の40%まで
          ),
          child: Container(
            width: MediaQuery
                .of(context)
                .size
                .width * 0.6, // 画面サイズの60%をとる
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min, // 高さを必要分だけとる
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                const Text(
                  '画像の取得方法',
                  //’方法選択’,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18,color: Color(0xFF29B6F6)), //pinkに変更
                ),
                const SizedBox(height: 15),//ボタンとテキストの位置
                // actions: <Widget>[
                //   Align(alignment: Alignment.center,
                //     child: Column(
                //       mainAxisSize: MainAxisSize.min, //余分なスペースを埋める
                //       mainAxisAlignment: MainAxisAlignment.center, //中心
                //       children: [
                // Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [

                //均等配置　横並び
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  // width: 140,
                  // height: 100,
                  child: ElevatedButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xFF29B6F6),
                      foregroundColor: Colors.white,
                      // elevation: 5,
                      //撮影ボタンの背景色を削除！
                      // backgroundColor: Colors.greenAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      side: BorderSide(color: Color(0xFF29B6F6), width: 2),
                    ),
                    onPressed: () {
                      // スマホのカメラ機能を使って、写真を撮る→ずっと出ているがnavigate.pop使うと挙動がおかしくなる
                      getImageFromCamera(context);
                    },


                    //写真撮影からの登録ボタンのデザイン
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          //カメラマークのアイコン調整はここから
                          Icons.camera_alt_outlined,
                          size: 24.0,
                          // color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Text(
                            '写真を撮る',
                          // ' 撮影して\n写真を登録',
                          style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  // width: 120,
                  // width: 140,
                  child: ElevatedButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xFF29B6F6),
                      foregroundColor: Colors.white,
                      //アルバム画像選択のボタン色を削除
                      // backgroundColor: Colors.cyan,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      side: BorderSide(color: Colors.white, width: 2),
                    ),
                    onPressed: () {
                      // アルバムの画像を選択する画面に遷移
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ImageSelect_Album()),
                      );
                    },

                    //アルバムから選択ボタン
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          //アルバムマークのアイコンの調整はここ
                          Icons.photo_library_outlined,
                          size: 24.0,
                          // color: Colors.white,
                          // size: 40.0,
                        ),
                        SizedBox(width: 8),
                        Text(
                            '写真を選択',
                            style: TextStyle(fontSize: 16)
                          // 'アルバムから\n　画像選択',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // SizedBox(
                // width: MediaQuery
                //       .of(context)
                //       .size
                //       .width * 0.5,
                // height: MediaQuery
                //       .of(context)
                //       .size
                //       .width * 0.3,
                // width: 120,
                // height: 100,
                //       child: ElevatedButton(
                //         style: TextButton.styleFrom(
                //           foregroundColor: Colors.black,
                //     //トリミングボタンの色削除！
                //     // backgroundColor: Color.fromARGB(255, 137, 150, 250),
                //           shape: RoundedRectangleBorder(
                //              borderRadius: BorderRadius.circular(10.0)),
                //         ),
                //         onPressed: () {
                //         //　画像選択して、トリミング画面に遷移する
                //           Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) => const CropImageSelect_Album()),
                //           );
                //         },
                //     //アルバムからトリミング
                //     child: const Column(
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Icon(
                //           //ハサミマークのアイコンの調整はここ
                //           Icons.cut_outlined,
                //           size: 32.0,
                //         ),
                //         Text('トリミング'),
                //       // 'アルバムから\nトリミング',
                //       ],
                //     ),
                //   ),
                // ),
                //キャンセルボタン
               Flexible(
                child: SizedBox(
                  width: double.infinity,
                  height: 50,  // 他のボタンと揃える
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Color(0xFF29B6F6),
                      side: BorderSide(color: Color(0xFF29B6F6), width: 2), // 枠線
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const FittedBox( // 文字サイズを自動調整
                    fit: BoxFit.scaleDown,
                    child:  Text(
                      "ホームに戻る",
                      style: TextStyle(fontSize: 16,color: Color(0xFF29B6F6)),
                      softWrap: true,
                    ),
                  ),
                ),
                ),
               ),
              ],
            ),
          ),
        ),
    );
  }
}
//                 Container(
//                   alignment: Alignment.center,
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 10, vertical: 5),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.white, width: 2), // 枠線
//                     borderRadius: BorderRadius.circular(12),
//                     // 角を丸くする
//                   ),
//
//                   child: MaterialButton(
//                     minWidth: 100,
//                     onPressed: () => Navigator.pop(context, 'Cancel'),
//                     child: const SizedBox(
//                       child: Center(
//                         child: Text("ホームに戻る",
//                           style: TextStyle(fontSize: 16, color: Colors.white),),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



    //   width: 300,
    //   alignment: Alignment.center,
    //   child: TextButton(
    //     onPressed: () => Navigator.pop(context, 'Cancel'),
    //     child: const Text(
    //       'ホームへ戻る',
    //       // 'キャンセル',
    //       style: TextStyle(fontSize: 20, color: Colors.black),
    //     ),
    //   ),
    // ),
//       ]
//     );
//   }
// }
