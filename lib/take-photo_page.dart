import 'dart:io';
import 'dart:typed_data';

import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:transparent_image/transparent_image.dart';

import 'photo-select_page.dart';
import 'select-photo-check_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path_provider/path_provider.dart';

File? image; // 画像を保存する変数
final picker = ImagePicker(); // ImagePickerのインスタンス
Uint8List? byteImage;
List<Uint8List>? byteImages;
final List<Media> selectedMedias =[];
List<Media> medias = [];
List<AssetEntity>? entities;
final List<Media> savePhoto = [];




// Future<void> getImageFromCamera(BuildContext context)async{
//   final picker = ImagePicker(); // ImagePickerのインスタンス
//   final XFile? image = await picker.pickImage(source: ImageSource.camera);
//   if(image != null){
//     AssetEntity? assetEntity = await convertXFileToAssetEntity(image);
//     if (assetEntity != null) {
//       Media media = Media(
//         assetEntity: assetEntity,
//         // assetEntity: null,
//         widget: Image.file(File(image.path)), // XFileからImageウィジェットを作成
//       );
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) =>
//               SelectCheck(imageData: [media
//                 // Media(assetEntity: assetEntity, widget: Image.file(File(image.path)))
//                 // Media(assetEntity: assetEntity, widget: Image.file(File(image.path)))
//               ]),
//         ),
//       );
//     }
//   }
// }
//
// Future<AssetEntity?> convertXFileToAssetEntity(XFile file) async {
//   // XFileからFileに変換
//   File imageFile = File(file.path);
//
//
//   // 画像ファイルをアルバムに追加
//   AssetEntity? assetEntity = await PhotoManager.editor.saveImage(
//     Uint8List.fromList(await imageFile.readAsBytes()),
//     title: 'camera_image', // 任意のタイトル
//   );
//
//   return assetEntity;
// }

//元データーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
// Future<AssetEntity?> convertXFileToAssetEntity(XFile file) async {
//   // XFileからFileに変換
//   File imageFile = File(file.path);
//
//
//   // 画像ファイルをアルバムに追加
//   AssetEntity? assetEntity = await PhotoManager.editor.saveImage(
//     Uint8List.fromList(await imageFile.readAsBytes()),
//     title: 'camera_image', // 任意のタイトル
//   );
//
//   return assetEntity;
// }
//
//
// Future<void> getImageFromCamera(BuildContext context)async{
//   final picker = ImagePicker(); // ImagePickerのインスタンス
// final XFile? image = await picker.pickImage(source: ImageSource.camera);
// if(image != null){
//   AssetEntity? assetEntity = await convertXFileToAssetEntity(image);
//   if (assetEntity != null) {
//     Media media = Media(
//       assetEntity: assetEntity,
//       // assetEntity: null,
//       widget: Image.file(File(image.path)), // XFileからImageウィジェットを作成
//     );
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) =>
//             SelectCheck(imageData: [media
//               // Media(assetEntity: assetEntity, widget: Image.file(File(image.path)))
//               // Media(assetEntity: assetEntity, widget: Image.file(File(image.path)))
//             ]),
//       ),
//     );
//   }
// }
// }


//-------------------------------------------------------------------------------------------
//   Future<AssetEntity?> createTemporaryAssetEntity(XFile file) async {
//     // XFileからFileに変換
//     File imageFile = File(file.path);
//     // 一時的なファイルを作成
//     final tempDir = await getTemporaryDirectory();
//     final tempFile = await imageFile.copy('${tempDir.path}/temp_${DateTime.now().millisecondsSinceEpoch}.jpg');
//
//     // 一時的なファイルをメディアライブラリに登録
//     AssetEntity? assetEntity = await PhotoManager.editor.saveImage(
//       await tempFile.readAsBytes(),
//       title: 'Temporary Image', // 任意のタイトル
//     );
//
//     // 一時的なファイルを削除
//     await tempFile.delete();
//
//     return assetEntity;
//   }

Future getImageFromCamera(BuildContext context) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.camera);
  if (pickedFile != null) {
    image = File(pickedFile.path);
    //トリミング画面にバイトデータとして送る為に変換
    byteImage = await image!.readAsBytes();
  } else {
    return;
  }
   byteImages = [byteImage!];
  await Navigator.push(
    context,
      MaterialPageRoute(
        builder: (context) => SelectCheck(imageData:byteImages!),
      ),
    );
}
  //   final XFile? image = await picker.pickImage(source: ImageSource.camera);
//   if (image != null) {
//     image = File(pickedFile.path);
// //     //トリミング画面にバイトデータとして送る為に変換
//     byteImage = await image!.readAsBytes();
//       // SelectCheckにMediaオブジェクトを渡して遷移
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => SelectCheck(imageData:imagebyte!),
//         ),
//       );
//     }
//   }
// }
//---------------------------------------------------------------------------------



// Future<void> getImageFromCamera(BuildContext context) async {
//   final ImagePicker _picker = ImagePicker();
//   final XFile? image = await _picker.pickImage(source: ImageSource.camera);
//   // final List<AssetEntity> entities = _picker.pickImage(source: ImageSource.camera);
//   // カメラから画像を取得
//   // final XFile? image = await _picker.pickImage(source: ImageSource.camera);
//   if (image != null) {
//     final String imagePath = image.path;
//     // 画像をMediaオブジェクトに変換
//     // final List<AssetEntity> entities =
//     // await album.getAssetListPaged(page: 0, size: 30);
//     final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList();
//     if (albums.isNotEmpty) {
//       final AssetPathEntity album = albums.first;
//       final AssetEntity asset = await album.saveImageWithPath(imagePath);
// // if (entities != null){
//       for (AssetEntity entity in entities) {
//         final Media media = Media(
//           assetEntity: entity,
//           widget: FadeInImage(
//             placeholder: MemoryImage(kTransparentImage),
//             fit: BoxFit.cover,
//             image: AssetEntityImageProvider(
//               entity,
//               thumbnailSize: const ThumbnailSize.square(500),
//               isOriginal: false,
//             ),),
//
//           // assetEntity: AssetEntity(id: 'cameraImage', type: AssetType.image),
//           // widget: Image.file(File(image.path)),
//         );
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => SelectCheck(imageData: [media]),
//           ),
//         );
//         medias.add(media);
//       }
//     }
//   }
// }
// // カメラから画像を取得するメソッド
// Future getImageFromCamera(BuildContext context) async {
//   final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
//   if (pickedFile != null) {
//     final Media media = Media(
//       assetEntity: AssetEntity(id: 'cameraImage', type: AssetType.image),
//       widget: Image.file(File(image.path)),
//     );
//     setState(() {
//       widget.imageData.add(media);
//     });
//   }
//
// }

// // カメラから画像を取得するメソッド
// Future getImageFromCamera(BuildContext context) async {
//   final  pickedFile = await picker.pickImage(source: ImageSource.camera);
//   if (pickedFile != null) {
//     image = File(pickedFile.path);
//     //トリミング画面にバイトデータとして送る為に変換
//     byteImage = await image!.readAsBytes();
//
//     AssetEntity? assetEntity = await PhotoManager.editor.saveImage(byteImage!, title: 'camera_image');
//     if (assetEntity != null) {
//       Media media = Media(
//         // assetEntity: AssetEntity(id: 'camera', type: AssetType.image, width: 0, height: 0), // 仮のAssetEntityを作成
//         assetEntity: assetEntity,
//         widget: Image.memory(byteImage!), // バイトデータからウィジェットを作成
//       );
//       print('Media object created: ${media.assetEntity.id}');
//       await Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => SelectCheck(imageData: [media]),
//         ),
//       );
//     } else {
//       print('Error: AssetEntity is null');
//     }
//   } else {
//     print('No image selected');
//   }
// }
//
//     }
//   } else {
//     return;
//   }
// }


// // カメラから画像を取得するメソッド
// Future getImageFromCamera(BuildContext context) async {
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

// File? image; // 画像を保存する変数
// final picker = ImagePicker(); // ImagePickerのインスタンス
// Uint8List? byteImage;
//
// // カメラから画像を取得するメソッド
// Future getImageFromCamera() async {
//   final pickedFile = await picker.pickImage(source: ImageSource.camera);
//   if (pickedFile != null) {
//     image = File(pickedFile.path);
//     //トリミング画面にバイトデータとして送る為に変換
//     byteImage = await image!.readAsBytes();
//   } else {
//     return;
//   }
// }
  // await Navigator.push(
  //   context,
  //     MaterialPageRoute(
  //       builder: (context) => SelectCheck(),
  //     ),
  //   );
  // // プログレスインジケータを表示するダイアログを表示
  // showDialog(
  //   context: context,
  //   useRootNavigator: false,
  //   builder: (context) {
  //     return Container(
  //         alignment: Alignment.center,
  //         child: SizedBox(
  //             width: 50,
  //             height: 50,
  //             child: ColoredBox(
  //                 color: Colors.white54,
  //                 child: Padding(
  //                     padding: EdgeInsets.all(10.0),
  //                     child: CircularProgressIndicator(
  //                       color: Colors.green,
  //                     )))));
  //   },
  // );
  // // 撮影した写真をトリミング画面渡して遷移する
  // await Navigator.push(
  //   context,
  //   MaterialPageRoute(
  //     builder: (context) => SelectCheck(),
  //   ),
  // );
  // Navigator.of(context).pop();
// }