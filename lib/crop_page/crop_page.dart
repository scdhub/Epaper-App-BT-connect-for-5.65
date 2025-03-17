//　選択された画像をトリミングする
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:photo_manager/photo_manager.dart';
//import 'package:photo_manager/photo_manager.dart';

import '../server_upload/select-photo-check_page.dart';

void cropImage(BuildContext context, {File? imageFile, AssetEntity? asset}) async
{File? fileToCrop;

//カメラ画像なら、そのまま使う
if (imageFile != null) {
  fileToCrop = imageFile;
}

// アルバム画像なら、AssetEntity を File に変換する
if (asset != null) {
  fileToCrop = await asset.file; // AssetEntity → File に変換
}

// どっちもnulの場合は中断（ファイルが取得できなかった場合、処理を中断する）
if (fileToCrop == null) {
  print("画像の取得に失敗しました");
  return;
}

//画像をトリミングする
final croppedFile = await ImageCropper().cropImage(
  sourcePath: fileToCrop.path, // `File` のパスを渡す
  aspectRatio: const CropAspectRatio(ratioX: 600, ratioY: 448),
  uiSettings: [
    AndroidUiSettings(
      toolbarTitle: 'トリミング',
      toolbarColor: Colors.black,
      toolbarWidgetColor: Colors.white,
      lockAspectRatio: true,
    ),
    IOSUiSettings(
      title: 'トリミング画面',
      cancelButtonTitle: 'Cancel',
      doneButtonTitle: 'Crop',
      minimumAspectRatio: 600 / 448,
    ),
  ],
);

//トリミング後の画像を `Uint8List` に変換
if (croppedFile != null) {
  Uint8List cropBytes = await File(croppedFile.path).readAsBytes();

  //次の画面に渡す
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => SelectCheck(imageData: [cropBytes]),
    ),
  );
}
}




//初期
// //void cropImage(BuildContext context, AssetEntity asset) async {
//   // final file = await asset.file; //アセットファイルとして、変換　
//     // カメラ処理、アルバム処理の際に分岐して処理を行う。
//
//   ImageCropper imageCropper = ImageCropper(); //image_cropper機能を呼び出す。
//
//   final croppedFile = await imageCropper.cropImage(
//     // //画像をクロップ
//     // sourcePath: file!.path, //クロップする画像のファイルパス
//
//       //AWSへアップロードする写真は幅600、高448の画像でアップロード
//     aspectRatio: const CropAspectRatio(ratioX: 600, ratioY: 448), //クロップする画角のアスペクト比を600/400に設定
//     uiSettings: [
//       AndroidUiSettings(
//         //アンドロイド端末用の設定
//         toolbarTitle: 'トリミング',
//         toolbarColor: Colors.black,
//         toolbarWidgetColor: Colors.white,
//         // initAspectRatio: CropAspectRatioPreset.original,
//         lockAspectRatio: true,
//       ),
//       IOSUiSettings(
//         //iOS端末用の設定
//         title: 'トリミング画面',
//         cancelButtonTitle: 'Cancel',
//         doneButtonTitle: 'Crop',
//         minimumAspectRatio: 600 / 448,
//       ),
//     ],
//   );
//
//   if (croppedFile != null) {
//     // クロップされた画像を使用
//     // クロップされた画像ファイルをUint8Listに変換
//     Uint8List cropBytes = await File(croppedFile.path).readAsBytes();
//     // var croppedBytes = [cropBytes];
//
//     // Uint8Listを次のページに渡す
//     // Navigator.push →　select-photo-check_page.dartページ
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => SelectCheck(imageData: [cropBytes]),
//       ),
//     );
//   }
// }
