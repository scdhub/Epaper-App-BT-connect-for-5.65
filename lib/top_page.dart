import 'package:flutter/material.dart';
import 'connect_bt_page.dart';
import 'import_page.dart';

class TopPage extends StatefulWidget {
  const TopPage({super.key, required this.title});
  final String title;

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.blue,
        title: Text(widget.title),
      ),
      body:Column(
        mainAxisSize: MainAxisSize.min,

        children: <Widget>[
          ElevatedButton(
            style:TextButton.styleFrom(foregroundColor: Colors.black,backgroundColor: Colors.blue),
            onPressed:(){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ConnectBTPage()),//BT接続画面に遷移
              );
            },
            child:Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children:[
                  Text('BT接続',),
              Icon(Icons.bluetooth),
                ]
            )
          ),
          SizedBox(),
          ElevatedButton(
              style:TextButton.styleFrom(foregroundColor: Colors.black,backgroundColor: Colors.blue),
              onPressed:(){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ImportPage()),
                );
              },
              child:Row(
                  children:[
                    Text('画像選択'),
                    Icon(Icons.photo_library),
                  ]
              )
          ),
        ],
      )
    );
  }
}
