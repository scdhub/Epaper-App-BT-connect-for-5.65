import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'photoselect_nameselect.dart';
import 'photo-select_image-list.dart';

class imageSelect_Album extends StatefulWidget {
  @override
  _imageSelectAlbumState createState() => _imageSelectAlbumState();
}

class _imageSelectAlbumState extends State<imageSelect_Album> {

  List<AssetPathEntity> albums = [];//ポップメニュー
  List<AssetEntity> photos = [];//gridviewに映す
  int? selectedAlbumIndex;

  @override
  void initState() {
    super.initState();
    _fetchAlbums();//初期化時にアルバム取得

  }

  _fetchAlbums() async {
    final permitted = await PhotoManager.requestPermissionExtend();//初回写真へのアクセス許可を要求
    if (permitted.isAuth) {
      // onlyAll: をtrueにすると最初のファイルしかリスト一覧に出ないため、falseに設定
      albums = await PhotoManager.getAssetPathList(onlyAll: false);//アルバムリスト取得
      _fetchPhotos(albums.first);
    } else {
      PhotoManager.openSetting();//許可がない時設定を開く
    }
  }
  //アルバムの写真のリスト
  _fetchPhotos(AssetPathEntity album) async {
    final photoList = await album.getAssetListPaged(page: 0, size: 100);//今のところ100枚の画像を取得するようにしている。後ほどすべて抜き出せるように修正。
    setState(() {
      photos = photoList;
    });
  }
  // フォルダリストの数を取得
  Future<int> _fetchAssetCount(AssetPathEntity album) async {
    final photoList = await album.getAssetListPaged(page: 0, size: 100);//今のところ100枚の画像を取得するようにしている。後ほどすべて抜き出せるように修正。
    return photoList.length;
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
