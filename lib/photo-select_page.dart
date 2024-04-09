import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'photo-select_name-select.dart';
import 'photo-select_image-list.dart';

class imageSelect_Album extends StatefulWidget {
  @override
  _imageSelectAlbumState createState() => _imageSelectAlbumState();
}

class _imageSelectAlbumState extends State<imageSelect_Album> {

  List<AssetPathEntity> albums = [];//ポップメニュー
  List<AssetEntity> photos = [];//gridviewに映す
  int? selectedAlbumIndex;
  List<AssetPathEntity> popImage =[];

  @override
  void initState() {
    super.initState();
    _fetchAlbums();//初期化時にアルバム取得

  }

  // _fetchAlbums() async {
  //   final permitted = await PhotoManager.requestPermissionExtend();//初回写真へのアクセス許可を要求
  //   if (permitted.isAuth) {
  //     // onlyAll: をtrueにすると最初のファイルしかリスト一覧に出ないため、falseに設定
  //     albums = await PhotoManager.getAssetPathList(onlyAll: false);//アルバムリスト取得
  //     _fetchPhotos(albums.first);
  //   } else {
  //     PhotoManager.openSetting();//許可がない時設定を開く
  //   }
  // }
  // //アルバムの写真のリスト
  // _fetchPhotos(AssetPathEntity album) async {
  //   final photoList = await album.getAssetListPaged(page: 0, size: 100);//今のところ100枚の画像を取得するようにしている。後ほどすべて抜き出せるように修正。
  //   setState(() {
  //     photos = photoList;
  //   });
  // }

  // _fetchAlbums() async {
  //   final permitted = await PhotoManager.requestPermissionExtend();//初回写真へのアクセス許可を要求
  //   if (permitted.isAuth) {
  //     final allAlbums = await PhotoManager.getAssetPathList(onlyAll: false);
  //     // データが入っているアルバムのみをフィルタリング
  //     albums = allAlbums.where((album) async {
  //       final assetCount = await album.assetCount;
  //       return assetCount > 0;
  //     }).toList();
  //     _fetchPhotos(albums.first);
  //   } else {
  //     PhotoManager.openSetting();
  //   }
  // }
  _fetchAlbums() async {
    final permitted = await PhotoManager.requestPermissionExtend();//初回写真へのアクセス許可を要求
    if (permitted.isAuth) {
      albums = await PhotoManager.getAssetPathList(onlyAll: false);
      if (albums.isNotEmpty) {
        // 最初のアルバムの写真を取得
        _fetchPhotos(albums.first);
      }
    } else {
      PhotoManager.openSetting();
    }
  }

  //アルバムの写真のリスト
  _fetchPhotos(AssetPathEntity album) async {
    final photoList = await album.getAssetListPaged(page: 0, size:1000000);
    // フィルタリング: 動画データ以外の画像のみを選択
    final filteredPhotos = photoList.where((asset) => asset.type == AssetType.image).toList();
    setState(() {
      photos = filteredPhotos;
    });
  }
  // // フォルダリストの数を取得
  // Future<int> _fetchAssetCount(AssetPathEntity album) async {
  //   final photoFList = await album.getAssetListPaged(page: 0, size:1000000);//今のところ100枚の画像を取得するようにしている。後ほどすべて抜き出せるように修正。
  //   return photoFList.length;
  // }
  // フォルダリストの数を取得
  Future<int> _fetchAssetCount(AssetPathEntity album) async {
    final photoFList = await album.getAssetListPaged(page: 0, size:1000000);//今のところ100枚の画像を取得するようにしている。後ほどすべて抜き出せるように修正。
    final filteredFolder = photoFList.where((asset) => asset.type == AssetType.image).toList();
    return filteredFolder.length;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: PopupMenuAlbumName(//写真フォルダリスト名表示
            albums: albums,
            onAlbumSelected: (index) {//リスト名を選択したら表示する
              setState(() {
                selectedAlbumIndex = index;
                _fetchPhotos(albums[index]);
              });
            },
            selectedAlbumIndex: selectedAlbumIndex,
            photos: photos,
            fetchAssetCount: _fetchAssetCount,
          ),
          backgroundColor: Colors.black,
        ),
        body: ImageList(photos: photos),
      ),
    );
  }
}
