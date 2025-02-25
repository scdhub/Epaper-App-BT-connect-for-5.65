import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:iphone_bt_epaper/top_page/top_text-to-page.dart';
import '../app_body_color.dart';
import 'top_bt-connect-to-page.dart';
import 'top_drawing-to-page.dart';
import 'top_import-type-select-to-popup.dart';



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
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          // 'E ink E-paper',
          widget.title,
        ),
      ),
      body: CustomPaint(
        painter: HexagonPainter(),
        child: Padding(
          // child: Container(
          padding: EdgeInsets.only(top: AppBar().preferredSize.height),
          // 画面の高さに合わせる
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // コンテンツを画面中央に配置
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // SizedBox(
              //   // height: MediaQuery.of(context).size.height / 5,
              // ),
              SizedBox(height: 15), //barとタイトルの間の空白

              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 10),
              const Text('下記から画像をアップロードしてください。',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  // fontSize: 20,
                ),
              ),
              // const Text('(Ver.20231201.001)',
              //     style: TextStyle(
              //       fontSize: 8
              //       // fontSize: 15,
              //     )),
              const SizedBox(height: 10),

              //中央にボタンを配置
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //bt接続画面に遷移するボタン
                  BlueToothConnectToPage(),
                  SizedBox(width: 10,),
                  //スマホ画像種類選択画面に遷移するボタン
                  ImportTypeSelectToPopup(),
                ],
              ),
              const SizedBox(height: 10,),


              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //ドローイング画面に遷移するボタン
                  DrawingToPage(),
                  SizedBox(width: 10,),
                  //テキスト入力画面に遷移するボタン
                  TextToPage(),
                ],
              ),

              const SizedBox(height: 20),

              //下部にスぺース
              Spacer(),
              Column(
                // mainAxisAlignment: MainAxisAlignment.end, // 画面下部に配置
                children: const [
                  Text('最新インストールツール',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  Text('(Ver.20231201.001)',
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
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
