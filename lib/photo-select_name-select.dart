import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:typed_data';

class PopupMenuAlbumName extends StatelessWidget{
  final List<AssetPathEntity> albums;
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
                      //選択画面起動時、「：albums[0].name」にするとエラーが発生するため今のところ「:'Recent'」に設定
                      selectedAlbumIndex != null ? albums[selectedAlbumIndex!].name :'Recent',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    //containerが押されたときの回転動作をあとで付け加える。ボタン機能は無くす予定
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
          itemBuilder: (BuildContext context) => albums.asMap().entries.map((entry) {
            int index = entry.key;// アルバムのインデックスを取得
            AssetPathEntity album = entry.value;// アルバムを取得

            // リスト欄にアルバムの最初の画像とアルバム名を設定。
            // 下記コードでは、アルバム名があっても画像がない場合、永遠にインジケーターが回るため、画像ない時の処理の追加が必要
            return PopupMenuItem<int>(
              value: index,
              child: Row(
                children: [
                  FutureBuilder<Uint8List?>(
                    future: _fetchFirstImage(album),// アルバムの最初の画像を非同期に取得。
                    builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                        return Image.memory(snapshot.data!, width: 100, height: 100, fit: BoxFit.cover,);
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
                ],
              ),
            );
          }).toList(),
        ));
  }


  Future<Uint8List?> _fetchFirstImage(AssetPathEntity album) async {
    final assetList = await album.getAssetListPaged(page: 0, size: 1);
    if (assetList.isNotEmpty) {
      final byteData = await assetList.first.originBytes;
      return byteData;
    }
    return null;
  }

}