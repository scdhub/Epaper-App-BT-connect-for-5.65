import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:typed_data';

// class PopupMenuAlbumName extends StatefulWidget{
//
//   final List<AssetPathEntity> albums;
//   final ValueChanged<int> onAlbumSelected;
//   final int? selectedAlbumIndex;
//   final List<AssetEntity> photos;
//   final Future<int> Function(AssetPathEntity album) fetchAssetCount;
//
//   PopupMenuAlbumName({
//     Key? key,
//     required this.albums,
//     required this.onAlbumSelected,
//     required this.selectedAlbumIndex,
//     required this.photos,
//     required this.fetchAssetCount,
//   }) : super(key: key);
//
//   @override
//   _PopupMenuAlbumNameState createState() => _PopupMenuAlbumNameState();
// }
//
// class _PopupMenuAlbumNameState extends State<PopupMenuAlbumName> {

  class PopupMenuAlbumName extends StatelessWidget{final List<AssetPathEntity> albums;

  final ValueChanged<int> onAlbumSelected;
  final int? selectedAlbumIndex;
  final List<AssetEntity> photos;
  final Future<int> Function(AssetPathEntity album) fetchAssetCount;

  PopupMenuAlbumName({
    Key? key,
    required this.albums,
    required this.onAlbumSelected,
    required this.selectedAlbumIndex,
    required this.photos,
    required this.fetchAssetCount,
  }) : super(key: key);

// List<AssetPathEntity> deletedAlbums =[];
// List<AssetPathEntity> newAlbums = [];
//
//   void _deleteAlbum(int index) {
//     if (widget.albums.isNotEmpty && index >= 0 && index < widget.albums.length) {
//       final albumToDelete = widget.albums[index];
//       if (widget.fetchAssetCount(albumToDelete) == 0) {
//         setState(() {
//           deletedAlbums.add(albumToDelete);
//           widget.albums.removeAt(index);
//         });
//       } else {
//         // アルバム内に写真があるため削除できません
//         // エラーメッセージを表示するなどの処理を追加できます
//         return;
//       }
//     }
//   }
// Future<int> _fetchAssetCount(AssetPathEntity album) async {
//   final photoList = await album.getAssetListPaged(page: 0, size: 1000000);
//   final filteredPhotos = photoList.where((asset) => asset.type == AssetType.image).toList();
//   return filteredPhotos.length;
// }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Center(
        child: PopupMenuButton<int>(
          offset: Offset(0, 54),//(水平方向,垂直方向)
          constraints: BoxConstraints(
            minWidth: screenWidth,
            maxWidth: screenWidth,
          ),
          onSelected: (int result) { //選択したリスト名を入れ替える
            // widget.onAlbumSelected(result);
            onAlbumSelected(result);

          },
          child: IntrinsicWidth(
            stepWidth: 10.0,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child:Row(

                  children:[
                    Text(
                      //選択画面起動時、「：albums[0].name」にするとエラーが発生するため「:'Recent'」に設定
                      // selectedAlbumIndex != null ? albums[selectedAlbumIndex!].name :'Recent',
                      // widget.selectedAlbumIndex != null ? widget.albums[widget.selectedAlbumIndex!].name :'Recent',
                      selectedAlbumIndex != null ? albums[selectedAlbumIndex!].name :'Recent',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    //containerが押されたときの回転動作をあとで付け加える。
                    IconButton(
                      icon: Icon(Icons.expand_more, color: Colors.white),
                      onPressed: () {
                        //回転動作
                      },
                    ),
                  ] ),
            ),
          ),
          // メニューのアイテムリストを作成
          // itemBuilder: (BuildContext context) => widget.albums.asMap().entries.map((entry) {
    itemBuilder: (BuildContext context) => albums.asMap().entries.map((entry) {
            int index = entry.key;// アルバムのインデックスを取得
            AssetPathEntity album = entry.value;// アルバムを取得


            // リスト欄にアルバムの最初の画像とアルバム名を設定。
            // 下記コードでは、アルバム名があっても画像がない場合、永遠にインジケーターが回るため、画像ない時の処理の追加が必要
            return PopupMenuItem<int>(
              value: index,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // FutureBuilder<Uint8List?>(
                  //   future: _fetchFirstImage(album),// アルバムの最初の画像を非同期に取得。
                  //   builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
                  //     if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                  //       return Image.memory(snapshot.data!, width: 100, height: 100, fit: BoxFit.cover,);
                  //     } else {
                  //       return CircularProgressIndicator();
                  //     }
                  //   },
                  // ),
                  FutureBuilder<Uint8List?>(
                    future: _fetchFirstImage(album),// アルバムの最初の画像を非同期に取得。
                    builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {


                      if (snapshot.connectionState == ConnectionState.done ) {
                        if(snapshot.data != null) {
                          // print(snapshot);
                          return Image.memory(snapshot.data!, width: 100,
                            height: 100,
                            fit: BoxFit.cover,);
                        }else{
                          return SizedBox.shrink();
                        }
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                  SizedBox(width: 8),
                  FutureBuilder(
                    future: fetchAssetCount(album),
                    builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Text('${album.name} (${snapshot.data})');
                      } else {
                        return Text(album.name);
                      }
                    },
                  ),
                  // FutureBuilder(
                  //   future: fetchAssetCount(album),
                  //   builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  //     if (snapshot.connectionState == ConnectionState.done) {
                  //       if(snapshot.data ==0){
                  //         return SizedBox.shrink();
                  //       }else {
                  //         return Text('${album.name} (${snapshot.data})');
                  //       }
                  //     } else {
                  //       return Text(album.name);
                  //     }
                  //   },
                  // ),

                  // FutureBuilder(
                  //   future: fetchAssetCount(album),
                  //   builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  //     if (snapshot.connectionState == ConnectionState.done) {
                  //       final albumName = album.name;
                  //       final assetCount = snapshot.data ?? 0; // アセット数が null の場合は 0 として扱う
                  //       if (assetCount > 0) {
                  //         return
                  //             Text('$albumName ($assetCount)');
                  //       }else{
                  //         return SizedBox.shrink();
                  //       }
                  //     } else {
                  //       return Text(album.name);
                  //     }
                  //   },
                  // )

                ],
              ),
            );
          }).toList(),

            // return PopupMenuItem<int>(
            //   value: index,
            //   child: Row(
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       FutureBuilder<Uint8List?>(
            //         future: _fetchFirstImage(album), // アルバムの最初の画像を非同期に取得
            //         builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
            //           if (snapshot.connectionState == ConnectionState.done) {
            //             // if (snapshot.data != null) {
            //             if (snapshot.hasData && snapshot.data != null) {
            //               return Image.memory(
            //                 snapshot.data!,
            //                 width: 100,
            //                 height: 100,
            //                 fit: BoxFit.cover,
            //               );
            //             } else {
            //               return Visibility(
            //                 // visible: snapshot.data != null, // 条件に応じてウィジェットを表示または非表示にする
            //                 visible: snapshot.hasData && snapshot.data != null, // 条件に応じてウィジェットを表示または非表示にする
            //                 child: Image.memory(
            //                   snapshot.data!,
            //                   width: 100,
            //                   height: 100,
            //                   fit: BoxFit.cover,
            //                 ),
            //               );
            //             }
            //           } else {
            //             return CircularProgressIndicator();
            //           }
            //         },
            //       ),
            //       SizedBox(width: 8),
            //       FutureBuilder<int>(
            //         future: fetchAssetCount(album),
            //         builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            //           if (snapshot.connectionState == ConnectionState.done) {
            //             final albumName = album.name;
            //             final assetCount = snapshot.data ?? 0; // アセット数が null の場合は 0 として扱う
            //             if (assetCount > 0) {
            //               return Text('$albumName ($assetCount)');
            //             } else {
            //               return Visibility(
            //                 // visible: snapshot.data != null, // 条件に応じてウィジェットを表示または非表示にする
            //                 visible: snapshot.hasData && snapshot.data != null,
            //                 child:
            //                 // Image.memory(
            //                 //   snapshot.data!,
            //                 //   width: 100,
            //                 //   height: 100,
            //                 //   fit: BoxFit.cover,
            //                 // ),
            //                 Text('$albumName ($assetCount)'),
            //               );
            //             }
            //           } else {
            //             return Text(album.name);
            //           }
            //         },
            //       ),
            //     ],
            //   ),
            // );
            // }).toList(),

          //   return PopupMenuItem<int>(
          //     value: index,
          //     child: Row(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         FutureBuilder<Uint8List?>(
          //           future: _fetchFirstImage(album),
          //           builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
          //             if (snapshot.connectionState == ConnectionState.done) {
          //               if (snapshot.hasData && snapshot.data != null) {
          //                 return Image.memory(
          //                   snapshot.data!,
          //                   width: 100,
          //                   height: 100,
          //                   fit: BoxFit.cover,
          //                 );
          //               } else {
          //                 return Visibility(
          //                   visible: snapshot.hasData && snapshot.data != null,
          //                   child: SizedBox.shrink(), // Use SizedBox.shrink() to remove the widget's space
          //                 );
          //               }
          //             } else {
          //               return CircularProgressIndicator();
          //             }
          //           },
          //         ),
          //         SizedBox(width: 8),
          //         FutureBuilder<int>(
          //           // future: widget.fetchAssetCount(album),
          //           future: fetchAssetCount(album),
          //           builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          //             if (snapshot.connectionState == ConnectionState.done) {
          //               final albumName = album.name;
          //               final assetCount = snapshot.data ?? 0;
          //               if (assetCount > 0) {
          //                 return Text('$albumName ($assetCount)');
          //               } else {
          //                 return Visibility(
          //                   visible: snapshot.hasData && snapshot.data != null,
          //                   child: SizedBox.shrink(),
          //                 );
          //               }
          //             } else {
          //               return Text(album.name);
          //             }
          //           },
          //         ),
          //       ],
          //     ),
          //   );
          //
          //
          //
          // }).toList(),
//----------------------------------------------------------------------------------------------
//           itemBuilder: (BuildContext context) => albums.asMap().entries.where((entry) {
//             // アルバムの種類が画像の場合のみ表示
//             return entry.value.assetType == AssetType.image;
//           }).map((entry) {
//             int index = entry.key; // アルバムのインデックスを取得
//             AssetPathEntity album = entry.value; // アルバムを取得

          // itemBuilder: (BuildContext context) => albums.asMap().entries.where((entry) {
          //   // アルバム内の画像のみを表示
          //   final album = entry.value;
          //   final assetList = album.assetList;
          //   final imageAssets = assetList.where((asset) => asset.type == AssetType.image).toList();
          //   return imageAssets.isNotEmpty;
          // }).map((entry) {
          //   int index = entry.key; // アルバムのインデックスを取得
          //   AssetPathEntity album = entry.value; // アルバムを取得
          //
          //   return PopupMenuItem<int>(
          //     value: index,
          //     child: Row(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         FutureBuilder<Uint8List?>(
          //           future: _fetchFirstImage(album), // アルバムの最初の画像を非同期に取得
          //           builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
          //             if (snapshot.connectionState == ConnectionState.done) {
          //               if (snapshot.data != null) {
          //                 return Image.memory(
          //                   snapshot.data!,
          //                   width: 100,
          //                   height: 100,
          //                   fit: BoxFit.cover,
          //                 );
          //               } else {
          //                 return SizedBox.shrink();
          //               }
          //             } else {
          //               return CircularProgressIndicator();
          //             }
          //           },
          //         ),
          //         SizedBox(width: 8),
          //         FutureBuilder<int>(
          //           future: fetchAssetCount(album),
          //           builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          //             if (snapshot.connectionState == ConnectionState.done) {
          //               final albumName = album.name;
          //               final assetCount = snapshot.data ?? 0; // アセット数が null の場合は 0 として扱う
          //               if (assetCount > 0) {
          //                 return Text('$albumName ($assetCount)');
          //               } else {
          //                 return SizedBox.shrink();
          //               }
          //             } else {
          //               return Text(album.name);
          //             }
          //           },
          //         ),
          //       ],
          //     ),
          //   );
          // }).toList(),

          // itemBuilder: (BuildContext context) => albums.asMap().entries.where((entry) {
          //   // アルバム内の画像のみを表示
          //   final album = entry.value;
          //   // final assetCount = album.assetCount;
          //   // return assetCount > 0;
          //
          //   // return album.assetType == AssetType.image;
          //
          //   // return album.isAll || album.isImage;
          //
          //   // return album.assetType == AssetType.image;
          //
          //   return  album.assetCount > 0;
          // }).map((entry) {
          //   int index = entry.key; // アルバムのインデックスを取得
          //   AssetPathEntity album = entry.value; // アルバムを取得
          //
          //   return PopupMenuItem<int>(
          //     value: index,
          //     child: Row(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         FutureBuilder<Uint8List?>(
          //           future: _fetchFirstImage(album), // アルバムの最初の画像を非同期に取得
          //           builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
          //             if (snapshot.connectionState == ConnectionState.done) {
          //               if (snapshot.data != null) {
          //                 return Image.memory(
          //                   snapshot.data!,
          //                   width: 100,
          //                   height: 100,
          //                   fit: BoxFit.cover,
          //                 );
          //               } else {
          //                 return SizedBox.shrink();
          //               }
          //             } else {
          //               return CircularProgressIndicator();
          //             }
          //           },
          //         ),
          //         SizedBox(width: 8),
          //         FutureBuilder<int>(
          //           future: fetchAssetCount(album),
          //           builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          //             if (snapshot.connectionState == ConnectionState.done) {
          //               final albumName = album.name;
          //               final assetCount = snapshot.data ?? 0; // アセット数が null の場合は 0 として扱う
          //               if (assetCount > 0) {
          //                 return Text('$albumName ($assetCount)');
          //               } else {
          //                 return SizedBox.shrink();
          //               }
          //             } else {
          //               return Text(album.name);
          //             }
          //           },
          //         ),
          //       ],
          //     ),
          //   );
          // }).toList(),



        ));
  }


  // Future<Uint8List?> _fetchFirstImage(AssetPathEntity album) async {
  //   final assetList = await album.getAssetListPaged(page: 0, size: 1);
  //   // final imageAssets = assetList.where((asset)=>asset.type == AssetType.image).toList();
  //   if (assetList.isNotEmpty) {
  //     final byteData = await assetList.first.originBytes;
  //     return byteData;
  //   }
  //   return null;
  // }
  Future<Uint8List?> _fetchFirstImage(AssetPathEntity album) async {
    final assetList = await album.getAssetListPaged(page: 0, size: 10000);
    final imageAssets = assetList.where((asset) => asset.type == AssetType.image).toList();
    if (imageAssets.isNotEmpty) {
      final byteData = await imageAssets.first.originBytes;
      // print(byteData);
      return byteData;
    }
    // else if (imageAssets.isEmpty){
    //
    // }
    return null;
  }

}