//　選択された画像をトリミングする
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:photo_manager/photo_manager.dart';
//import 'package:photo_manager/photo_manager.dart';

import '../server_upload/select-photo-check_page.dart';

void cropImage(BuildContext context,
    {File? imageFile, AssetEntity? asset}) async {
  File? fileToCrop;

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
    debugPrint("画像の取得に失敗しました");
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

    // 解像度を固定するために flutter_image_compress でリサイズ
    final result = await FlutterImageCompress.compressWithList(
      cropBytes,
      minWidth: 600, // 固定幅
      minHeight: 448, // 固定高さ
      quality: 88, // 圧縮品質（0〜100の範囲）
      // rotate: 0, // 回転
      format: CompressFormat.png, // 画像形式を指定
    );

    // 圧縮後の `Uint8List`（指定した解像度にリサイズされた画像）
    Uint8List compressedBytes = result;

    //次の画面に渡す
    Navigator.push(
      context,
      MaterialPageRoute(
        // builder: (context) => SelectCheck(imageData: [cropBytes]),
        builder: (context) => SelectCheck(imageData: [compressedBytes]),
      ),
    );
  }
}
