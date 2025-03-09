import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:iphone_bt_epaper/top_page/top_text-to-page.dart';
// import '../app_body_color.dart';
import 'top_bt-connect-to-page.dart';
import 'top_drawing-to-page.dart';
// import 'top_import-type-select-to-popup.dart';
import 'top_take-a-picture-page.dart';  // カメラボタン追加
import 'top_select-picture-page.dart'; // アルバムボタン追加

//最初に出てくる画面

class TopPage extends StatefulWidget {
  final String title;
  const TopPage({super.key, required this.title});

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: Text(
      //     // 'E ink E-paper',
      //     widget.title,
      //   ),
      // ),
      body: SafeArea(
        // painter: HexagonPainter(),
        // painter: BackgroundPainter(),
        // child: Padding(
        // child: Container(
        // padding: EdgeInsets.only(top: AppBar().preferredSize.height),
        // 画面の高さに合わせる
        child: Column(children: [
          Expanded(child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center, // 横中央に配置
            children: [
              const SizedBox(height: 35), // ここでタイトルを少し上に移動
              // SizedBox(
              //   // height: MediaQuery.of(context).size.height / 5,
              // ),
              // const SizedBox(height: 20), //barとタイトルの間の空白
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 45),//タイトルとボタンの余白

              // const Text('下記から画像をアップロードしてください。',
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //     fontWeight: FontWeight.bold,
              //     fontSize: 15,
              //     // fontSize: 20,
              //   ),
              // ),
              // const Text('(Ver.20231201.001)',
              //     style: TextStyle(
              //       fontSize: 8
              //       // fontSize: 15,
              //     )),
              //ボタン縦並び　ここをmargin
            const Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(child: BlueToothConnectToPage()), //BTボタン
              SizedBox(height: 10),

              Center(child: TopSelectPicturePage()), // アルバムボタン
              SizedBox(height: 10),

              Center(child: TopTakeAPicturePage()), // カメラボタン
              SizedBox(height: 10),

              Center(child: TextToPage()), //文字入力ボタン
              SizedBox(height: 10),

              Center(child: DrawingToPage()), //絵を描くボタン
            ],
          ),
          ),

          // const SizedBox(height: 10),
          // //中央にボタンを配置
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     //bt接続画面に遷移するボタン
          //     BlueToothConnectToPage(),
          //     SizedBox(width: 10,),
          //     //スマホ画像種類選択画面に遷移するボタン
          //     // ImportTypeSelectToPopup(),
          //     //
          //   ],
          // ),
          // const SizedBox(height: 10,),
          //
          //
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     //ドローイング画面に遷移するボタン
          //     DrawingToPage(),
          //     SizedBox(width: 10,),
          //     //テキスト入力画面に遷移するボタン
          //     TextToPage(),
          //   ],
          // ),


          //下部にスぺース
          // const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 20), // 下に余白をつける
            child: Column(
              children: const[
                Text('最新インストールツール',
                  style: TextStyle(
                    fontSize: 14,),
                ),
                Text('(Ver.20231201.001)',
                  style: TextStyle(
                    fontSize: 12,),
                ),
                    ]
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
// fontSize: 20,)),
//                 SizedBox(
//                 ),
//                 const Text('最新インストールツール',
//                     style: TextStyle(
//                       fontSize: 10
//                       // fontSize: 20,
//                     )),
//                 const Text('(Ver.20231201.001)',
//                     style: TextStyle(
//                       fontSize: 8
//                       // fontSize: 15,
//                     )),
//               ]),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
