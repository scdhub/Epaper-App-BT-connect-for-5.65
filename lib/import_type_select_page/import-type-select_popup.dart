import 'package:flutter/material.dart';
import '../crop_page/crop_photo-select.dart';
import '../server_upload/photo-select_page.dart';
import '../take-photo_page.dart';

//top_pageから遷移
class ImageTypeSelection_popup extends StatefulWidget {
  const ImageTypeSelection_popup({super.key});

  @override
  _ImageTypeSelection_popupState createState() =>
      _ImageTypeSelection_popupState();
}

class _ImageTypeSelection_popupState extends State<ImageTypeSelection_popup> {
  // var _selectedIndex = 1; // ラジオボタンの選択値を親ウィジェットで管理する

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      backgroundColor:Colors.white,
      title: Text('方法選択',
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        Column(
    children: [
Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children:[

      Container(
        width: 140,
        height: 100,
        child:

        ElevatedButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.greenAccent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          ),
          onPressed: () {
            // スマホのカメラ機能を使って、写真を撮る
            getImageFromCamera(context);
          },
          child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.camera_alt_outlined,
            size: 40.0,),
          Text(
            ' 撮影して\n写真を登録',
          ),
    ]),
      ),
      ),

      Container(
        width: 140,
        height: 100,
        child:
        ElevatedButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.cyan,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          ),
          onPressed: () {
            // アルバムの画像を選択する画面に遷移
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ImageSelect_Album()),
            );
          },
          child:
          Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
        Icon(
              Icons.photo_library_outlined,
            size: 40.0,
          ),
            Text(
              'アルバムから\n　画像選択',
            ),
          ]),
      ),
      ),
    ]),
      Container(
        width: 145,
        height: 100,
          child:
          ElevatedButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.pinkAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
            ),
            onPressed: () {
              //　画像選択して、トリミング画面に遷移する
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CropImageSelect_Album()),
                    );
            },
            child:
          Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
      Icon(
          Icons.cut_outlined,
          size: 40.0,
        ),
      Text(
        'アルバムから\n1枚トリミング',
      ),
    ]),
      ),
      ),
        ]),
        Divider(),
        Container(
          width: 300,
          alignment:Alignment.center,
        child:
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('キャンセル',
            style: TextStyle(
                fontSize:20,
                color:Colors.black
            ),
          ),
        ),
        ),
      ],
    );
  }
}

