import 'package:flutter/material.dart';
import 'package:iphone_bt_epaper/top_page/top_text-to-page.dart';
import '../bt_connect_page/connect_bt_page.dart';
import '../export-for-e-paper/export_page.dart';
import '../server_upload/photo-select_page.dart';
import '../import_type_select_page/import-type-select_popup.dart';
import 'top_bt-connect-to-page.dart';
import 'top_drawing-to-page.dart';
import 'top_import-type-select-to-popup.dart';



class TopPage extends StatefulWidget {
final String title;
TopPage({required this.title});

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
          title:
          Text(
            // 'E ink E-paper',
            widget.title,
              style: TextStyle(
                // fontWeight: FontWeight.w900,//Black
                fontSize: 25,
                // fontWeight: FontWeight.w900,
              ),
          ),
        ),
        body: Container(
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
                Text(widget.title,
                    style: TextStyle(
                      // fontWeight: FontWeight.w800,//ExtraBold

                      fontSize: 40,
                    )),
                SizedBox(height: 100),

                Text('最新インストールツール',
                    style: TextStyle(
                      // fontWeight: FontWeight.w400,//Light
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
              ],
            )));
  }
}



