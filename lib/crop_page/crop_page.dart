//　選択された画像をトリミングする
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:photo_manager/photo_manager.dart';

import '../server_upload/select-photo-check_page.dart';

void cropImage(BuildContext context, AssetEntity asset) async {
  final file = await asset.file; //アセットファイルとして、変換
  ImageCropper imageCropper = ImageCropper(); //image_cropper機能を呼び出す。
  final croppedFile = await imageCropper.cropImage(
    //画像をクロップ
    sourcePath: file!.path, //クロップする画像のファイルパス

    aspectRatio: const CropAspectRatio(
        ratioX: 600, ratioY: 448), //クロップする画角のアスペクト比を600/400に設定
    uiSettings: [
      AndroidUiSettings(
        //アンドロイド端末用の設定
        toolbarTitle: 'トリミング画面',
        toolbarColor: Colors.black,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: true,
      ),
      IOSUiSettings(
        //iOS端末用の設定
        title: 'トリミング画面',
        cancelButtonTitle: 'Cancel',
        doneButtonTitle: 'Crop',
        minimumAspectRatio: 600 / 448,
      ),
    ],
  );

  if (croppedFile != null) {
    // クロップされた画像を使用
    // クロップされた画像ファイルをUint8Listに変換
    Uint8List cropBytes = await File(croppedFile.path).readAsBytes();
    var croppedBytes = [cropBytes];
    // Uint8Listを次のページに渡す
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectCheck(imageData: croppedBytes),
      ),
    );
  }
}
