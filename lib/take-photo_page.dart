import 'dart:io';
import 'dart:typed_data';

import 'server_upload/photo-select_page.dart';
import 'server_upload/select-photo-check_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

File? image; // 画像を保存する変数
Uint8List? byteImage;
List<Uint8List>? byteImages;
List<Media> medias = [];

Future getImageFromCamera(BuildContext context) async {
  // ImagePickerのインスタンス
  final picker = ImagePicker();
  // カメラ機能を起動する
  final pickedFile = await picker.pickImage(source: ImageSource.camera);
  if (pickedFile != null) {
    image = File(pickedFile.path);
    //他の画面にバイトデータとして送る為に変換
    byteImage = await image!.readAsBytes();
  } else {
    // この部分を抜かすと写真をキャンセルした時、画面が暗くなる。
    return;
  }
  // List＜＞化する為、
  byteImages = [byteImage!];
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => SelectCheck(imageData: byteImages!),
    ),
  );
}
