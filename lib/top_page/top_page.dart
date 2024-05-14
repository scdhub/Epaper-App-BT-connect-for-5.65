import 'package:flutter/material.dart';
import 'connect_bt_page.dart';
import 'import_page.dart';
import 'photo-select_page.dart';
import 'import-type-select_popup.dart';
import 'top_bt-connect-to-page.dart';
import 'top_drawing-to-page.dart';
import 'top_import-type-select-to-popup.dart';
import 'top_text-to-page.dart';


class TopPage extends StatefulWidget {
  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF87ff99),
          centerTitle: true,
          title: Text('E Ink 電子ペーパー'),
        ),
        body: Container(
            // color:Colors.greenAccent,
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE1E9FF), Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 100),
                Text('E ink 電子ペーパー',
                    style: TextStyle(
                      fontSize: 40,
                    )),
                SizedBox(height: 100),
                Text('最新インストールツール',
                    style: TextStyle(
                      fontSize: 20,
                    )),
                Text('(Ver.20231201.001)',
                    style: TextStyle(
                      fontSize: 20,
                    )),
                SizedBox(height: 100),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BlueToothConnectToPage(),
                      SizedBox(width: 5,),
                      ImportTypeSelectToPopup(),

                    ]),
                SizedBox(height: 5,),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DrawingToPage(),
                      SizedBox(width: 5,),
                      TextToPage(),

                    ]),
                // DrawingToPage(),
              ],
            )));
  }
}



