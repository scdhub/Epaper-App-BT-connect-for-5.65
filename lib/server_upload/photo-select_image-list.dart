// import 'package:flutter/material.dart';
// import 'package:photo_manager/photo_manager.dart';
// import 'dart:typed_data';
// import 'select-photo-check_page.dart';
// import 'package:collection/collection.dart';
//
// // class ImageList extends StatelessWidget {
// //   final List<AssetEntity> photos;
// //
// //   ImageList({
// //     Key? key,
// //     required this.photos,
// //   }) : super(key: key);
// //
// //   List<Uint8List> savedPhotos = [];
//
//
// class ImageList extends StatefulWidget {
//   final List<AssetEntity> photos;
//
//   ImageList({Key? key, required this.photos}) : super(key: key);
//
//   @override
//   _ImageListState createState() => _ImageListState();
// }
//
// class _ImageListState extends State<ImageList> {
//   // List<Uint8List> savedPhotos = [];
//   // List<bool> tapStatus = [];
//
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   // すべての画像のタップ状態をfalseで初期化
//   //   tapStatus = List<bool>.filled(widget.photos.length, false);
//   // }
//
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   tapStatus = List.generate(widget.photos.length, (index) => false);
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           //グリッドの列数を固定する
//           crossAxisCount: 4, //1行に4つの画像を表示
//         ),
//         itemCount: widget.photos.length,
//         itemBuilder: (context, index) {
//           // return FutureBuilder<Uint8List?>(
//           final AssetEntity photo = widget.photos[index];
//           return FutureBuilder<Uint8List?>(
//             // future: widget.photos[index].thumbnailData,
//             future:photo.thumbnailData,
//             builder: (_, snapshot) {
//               final bytes = snapshot.data;
//               if (bytes == null) return CircularProgressIndicator();
//
//               return GestureDetector(
//                 onTap: () async {
//     // if (photo.isSelectable) {
//       final byteData = await widget.photos[index].originBytes;
//       if (byteData != null) {
//         // savedPhotos.add(byteData);
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) =>
//               SelectCheck(imageData: byteData)),
//         );
//       }
//       // tapStatus[index] = !tapStatus[index];
//     // }
//                 },
//                 // onTap:(){
//                 //
//                 //     // tapStatus[index] = !tapStatus[index];
//                 //
//                 // },
//                 // onTap: photo.isSelectable ? () async {
//                 //   final byteData = await photo.originBytes;
//                 //   if (byteData != null) {
//                 //     Navigator.push(
//                 //       context,
//                 //       MaterialPageRoute(builder: (context) => SelectCheck(imageData: byteData)),
//                 //     );
//                 //   }
//                 // } : null,
//                 // onTap:  photo.isSelectable && !photo.hasRaw ||
//                 //     !photo.hasRaw && photo.title.isNotEmpty // ここにcheck_circle_roundedがついている条件を追加
//                 //     ? () async {
//                 //   final byteData = await photo.originBytes;
//                 //   if (byteData != null) {
//                 //     Navigator.push(
//                 //       context,
//                 //       MaterialPageRoute(builder: (context) => SelectCheck(imageData: byteData)),
//                 //     );
//                 //   }
//                 // }
//                 //     : null,
//                 child: Stack(
//                   children: [
//                     Positioned.fill(
//                       child: Padding(
//                         padding: EdgeInsets.all(10.0),
//                         // Display the media widget
//                         child: Image.memory(bytes, fit: BoxFit.cover),
//                       ),
//                     ),
//                     // Positioned.fill(
//                     //   child: Container(
//                     //     // Semi-transparent black overlay
//                     //     color: Colors.black.withOpacity(0.1),
//                     //     child: const Center(
//                     //       child: Icon(
//                     //         // Checkmark icon
//                     //         Icons.check_circle_rounded,
//                     //         // White color for the icon
//                     //         color: Colors.white,
//                     //         // Size of the icon
//                     //         size: 30,
//                     //       ),
//                     //     ),
//                     //   ),
//                     // ),
//                     // if (photo.isSelectable)
//                     Positioned.fill(
//                       child:
//                       // tapStatus[index]
//                       //     ?
//                     // child: photo.hasRaw && photo.isSelectable // 追加条件
//                     //     ? Container(
//                     //   color: Colors.black.withOpacity(0.1),
//                     //   child: const Center(
//                     //     child: Icon(
//                     //       Icons.check_circle_rounded,
//                     //       color: Colors.white,
//                     //       size: 30,
//                     //     ),
//                     //   ),
//                     // )
//                     //     : Container(),
//                     Container(
//                         color: Colors.black.withOpacity(0.1),
//                         child: const Center(
//                           child: Icon(
//                             Icons.check_circle_rounded,
//                             color: Colors.white,
//                             size: 30,
//                           ),
//                         ),
//                       )
//                           // : Container(),
//                     ),
//                   ],
//                 ), // Image.memory(bytes, fit: BoxFit.cover),
//
//                 // },
//               );
//             },
//           );
//         });
//
//     // Widget _buildMediaWidget() {
//     //   return Positioned.fill(
//     //     child: Padding(
//     //       padding: EdgeInsets.all(10.0),
//     //       // Display the media widget
//     //       child: Image.memory(bytes, fit: BoxFit.cover),
//     //     ),
//     //   );
//     // }
//
// // bool isPhotoSaved(Uint8List? photo) {
// //   for (var savedPhoto in savedPhotos) {
// //     if (ListEquality().equals(photo, savedPhoto)) {
// //       return true;
// //     }
// //   }
// //   return false;
// // }
//   }
// }
