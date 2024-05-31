import 'package:flutter/material.dart';
import '../crop_page/crop_photo-select.dart';
import 'import-type-select_radiobutton.dart';
import '../server_upload/photo-select_page.dart';
import '../take-photo_page.dart';
import '../server_upload/select-photo-check_page.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class ImageTypeSelection_popup extends StatefulWidget {//top_pageから遷移
  const ImageTypeSelection_popup({super.key});

  @override
  _ImageTypeSelection_popupState createState() =>
      _ImageTypeSelection_popupState();
}

class _ImageTypeSelection_popupState extends State<ImageTypeSelection_popup> {
  var _selectedIndex = 1; // ラジオボタンの選択値を親ウィジェットで管理する

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      backgroundColor:Colors.white,
      title:
      // Text('スマホから画像を\nインポート方法選択',
      Text('方法選択',
        textAlign: TextAlign.center,
      ),
      // content: TypeSelectedRadio(
      //   // コールバック関数を渡す
      //   onSelected: (value) {
      //     setState(() {
      //       _selectedIndex = value;
      //     });
      //   },
      // ),
      actions: <Widget>[
    //     content: Container(
    //     width: MediaQuery.of(context).size.width, // 画面幅の90%に設定
    // child: Column(
    // children: [
    //   Text('スマホから画像を\nインポート方法選択',
    //     textAlign: TextAlign.center,
    //   ),
        Column(
    children: [
Row(

    // mainAxisAlignment: MainAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children:[

      Container(
        // color: Colors.greenAccent,
        width: 140,
        height: 100,
        // padding: ,
        child:

        ElevatedButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.greenAccent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          ),
          onPressed: () {
            getImageFromCamera(context);
          },
          child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        // IconButton(
        //   icon:
          Icon(
            Icons.camera_alt_outlined,
            size: 40.0,),
        //   onPressed:(){
        //     getImageFromCamera(context);
        // },
        // ),
          Text(
            ' 撮影して\n写真を登録',
          ),
    ]),
      ),
      ),

      Container(
        // color: Colors.cyan,
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
        // IconButton(
        //   icon:
        Icon(
              Icons.photo_library_outlined,
            size: 40.0,
          ),
          // onPressed:(){
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (context) => ImageSelect_Album()),
          //   );
          // },),
            Text(
              'アルバムから\n　画像選択',
            ),
          ]),
      ),
      ),
      // VerticalDivider(/*区切り線の設定*/),
    ]),
      Container(
        // color: Colors.pinkAccent,
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
      // IconButton(
      //   icon:
      Icon(
          Icons.cut_outlined,
          size: 40.0,
        ),
    //     onPressed:(){
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(builder: (context) => CropImageSelect_Album()),
    //       );
    //     },
    // ),
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
          child: const Text('キャンセル',style: TextStyle(fontSize:20,color:Colors.black),),
        ),
        ),
        // TextButton(
        //   onPressed: () {
        //     if (_selectedIndex == 1) {
        //       // getImageCamera();
        //       getImageFromCamera(context);
        //       // navigateToSelectCheck(context);
        //       // Navigator.push(
        //       //   context,
        //       //   MaterialPageRoute(builder: (context) =>
        //       //       AlbumImport()),
        //       // );
        //     } else {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(builder: (context) => imageSelect_Album()),
        //       );
        //     }
        //   },
        //   child: const Text('OK'),
        // ),
      ],
    // ),
    // ),
    );
  }
}

// class getImage {
//   File? image; // 画像を保存する変数
//
//   final picker = ImagePicker(); // ImagePickerのインスタンス
//   Uint8List? byteImage;
//
// // カメラから画像を取得するメソッド
//   Future getImageFromCamera(BuildContext context) async {
//     final pickedFile = await picker.pickImage(source: ImageSource.camera);
//     if (pickedFile != null) {
//       image = File(pickedFile.path);
//       //トリミング画面にバイトデータとして送る為に変換
//       byteImage = await image!.readAsBytes();
//     } else {
//       print('No image selected.');
//       return;
//     }
//     // プログレスインジケータを表示するダイアログを表示
//     showDialog(
//       context: context,
//       useRootNavigator: false,
//       builder: (context) {
//         return Container(
//             alignment: Alignment.center,
//             child: SizedBox(
//                 width: 50,
//                 height: 50,
//                 child: ColoredBox(
//                     color: Colors.white54,
//                     child: Padding(
//                         padding: EdgeInsets.all(10.0),
//                         child: CircularProgressIndicator(
//                           color: Colors.green,
//                         )))));
//       },
//     );
//     // 撮影した写真をトリミング画面渡して遷移する
//     // await
//     // Navigator.push(
//     //   context,
//     //   MaterialPageRoute(
//     //     builder: (context) => trimming_page(imageData: byteImage!),
//     //   ),
//     // );
//     // Navigator.of(context).pop();
//   }
// }

// void getImageCamera(BuildContext context) {
//   File? image; // 画像を保存する変数
//   final picker = ImagePicker(); // ImagePickerのインスタンス
//   Uint8List? byteImage;
//
// // カメラから画像を取得するメソッド
//   Future getImageFromCamera() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.camera);
//     if (pickedFile != null) {
//       image = File(pickedFile.path);
//       //トリミング画面にバイトデータとして送る為に変換
//       byteImage = await image!.readAsBytes();
//       await Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => SelectCheck(),
//         ),
//       );
//     } else {
//       return;
//     }
//   }
// }


//   File? image; // 画像を保存する変数
//   final picker = ImagePicker(); // ImagePickerのインスタンス
//   Uint8List? byteImage;
//
// // カメラから画像を取得するメソッド
//   Future getImageFromCamera(BuildContext context) async {
//     final pickedFile = await picker.pickImage(source: ImageSource.camera);
//     if (pickedFile != null) {
//       image = File(pickedFile.path);
//       //トリミング画面にバイトデータとして送る為に変換
//       byteImage = await image!.readAsBytes();
//       await Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => SelectCheck(),
//         ),
//       );
//     } else {
//       return;
//     }
//   }
