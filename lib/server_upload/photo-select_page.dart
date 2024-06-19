import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'select-photo-check_page.dart';

class Media {
  final AssetEntity assetEntity;
  final Widget widget;
  Media({
    required this.assetEntity,
    required this.widget,
  });
}

class ImageSelect_Album extends StatefulWidget {
  @override
  _ImageSelectAlbumState createState() => _ImageSelectAlbumState();
}

class _ImageSelectAlbumState extends State<ImageSelect_Album> {

  final ScrollController _scrollController = ScrollController();
  AssetPathEntity? _currentAlbum; //現在のアルバムを選択
  List<AssetPathEntity> _albums = [];//アルバムを保存する
  final List<Media> _medias = [];//　アルバムの画像を格納する
  int _lastPage = 0;
  int _currentPage = 0;
  List<AssetPathEntity> albums = [];//アルバム保存　一時保存
  final List<Media> _selectedMedias = [];//選択した画像
  final List<Media> selectedMedias =[];//選択した画像　一時保存
  Map<AssetPathEntity, int> _albumImageCounts = {};//画像数取得


  //初期化
  @override
  void initState() {
    super.initState();
    _selectedMedias.addAll(selectedMedias);
    _loadAlbums();
    _scrollController.addListener(_loadMoreMedias);
  }
  @override
  void dispose() {
    _scrollController.removeListener(_loadMoreMedias);
    _scrollController.dispose();
    super.dispose();
  }
  void _loadAlbums() async {
    //　アルバムへのアクセス許可を確認する
    final permitted = await PhotoManager.requestPermissionExtend();
    if (permitted.isAuth) {
      albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
      );
      //アルバムリスト取得
      if(albums.isNotEmpty){
        _currentAlbum = albums.first;
        _albums = albums;

        // 各アルバムの画像数を取得
        for (var album in albums) {
          final List<AssetEntity> entities = await album.getAssetListPaged(page: 0, size: 100000000);
          _albumImageCounts[album] = entities.length;
        }
        
        _loadMedias();
      }

    } else {
      //許可がない時設定を開く
      PhotoManager.openSetting();
    }
  }

  void _loadMedias() async {
    // 最後に見たページを現在のぺージとする
    _lastPage = _currentPage;
    if (_currentAlbum != null) {
      // 現在のアルバムから画像を読み取る
      List<Media> medias =
      await fetchMedias(album: _currentAlbum!, page: _currentPage);
      setState(() {
        _medias.addAll(medias);
      });
    }
  }

  // スクロールした時、画像のデータを取得する
  void _loadMoreMedias() {
    if (_scrollController.position.pixels /
        _scrollController.position.maxScrollExtent >
        0.33) {
      if (_currentPage != _lastPage) {
        _loadMedias();
      }
    }
  }

  // 画像の選択、解除する
  void _selectMedia(Media media) {
    bool isSelected = _selectedMedias.any((element) =>
    element.assetEntity.id == media.assetEntity.id);
    setState(() {
      if (isSelected) {
        // 既に選択されていたら外す。
        _selectedMedias.removeWhere(
                (element) => element.assetEntity.id == media.assetEntity.id);
      } else {
        // 選択されていない場合、追加する。
        _selectedMedias.add(media);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: DropdownButton<AssetPathEntity>(
          dropdownColor: Colors.grey,
          borderRadius: BorderRadius.circular(16.0),
          value: _currentAlbum,//現在の選択中のアルバム
          items: _albums.map((e) {
            final imageCount = _albumImageCounts[e] ?? 0;
            return DropdownMenuItem<AssetPathEntity>(
              value: e,
              child: Text(
                e.name.isEmpty ? "" : "${e.name}($imageCount)",
                style: TextStyle(color: Colors.yellow[100]),
              ),
            );
          }).toList(),
          onChanged: (AssetPathEntity? value) {
            setState(() {
              // 選択したアルバムを現在のアルバムとする
              _currentAlbum = value;
              // 現在のページをリセットし、最初から読み取る
              _currentPage = 0;
              // 最後のページをリセット
              _lastPage = 0;
              // 現在のアイテムをリセット
              _medias.clear();
            });
            // 選択したアルバムを読み込む
            _loadMedias();
            // スクロール位置を元に戻す。
            _scrollController.jumpTo(0.0);
          },
        ),
      ),
      body: MediasGridView(
        // メディアのアイテムを渡す。
        medias: _medias,
        // 選択した画像のアイテムをりすとgridviewに渡す。
        selectedMedias: _selectedMedias,
        // 選択または、選択解除するメソッドを渡す。
        selectMedia: _selectMedia,
        // スクロールコントローラーをgridviewに渡す。
        scrollController: _scrollController,
      ),
      floatingActionButton: _selectedMedias.isEmpty
          ? null
          : FloatingActionButton(
        onPressed: () async{
          List<Uint8List?> imageDataList = [];
          for (Media media in _selectedMedias){
            // 選択した画像をUint8List形式に変換する
            Uint8List? data = await getMediaData(media.assetEntity);
            if(data != null){
              //List<Uint8List>に入れる
              imageDataList.add(data);
            }
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              //サーバーupload画面に選択した画像を渡す。
              builder: (context) => SelectCheck(imageData: imageDataList),
            ),
          );
        },
        backgroundColor: Colors.lightGreenAccent,
        child: const Icon(Icons.add_task_outlined),
      ),
    );
  }
}

// assetEntityをバイトデータに変換する
Future<Uint8List?> getMediaData(AssetEntity assetEntity) async {
  return await assetEntity.originBytes;
}

Future<List<Media>> fetchMedias({
  required AssetPathEntity album,
  required int page,
}) async {
  //読み取ったデータを格納する
  List<Media> medias = [];

  try {
    //アルバムから画像を読み取る
    final List<AssetEntity> entities =
    await album.getAssetListPaged(page: 0, size: 100000000);

    for (AssetEntity entity in entities) {
      //画像をデータを格納する
      Media media = Media(
        assetEntity: entity,
        widget: FadeInImage(
          placeholder: MemoryImage(kTransparentImage),
          fit: BoxFit.cover,
          image: AssetEntityImageProvider(
            entity,
            thumbnailSize: const ThumbnailSize.square(300),
            isOriginal: false,
          ),
        ),
      );
      //読み取ったデータを入れる
      medias.add(media);
    }
  } catch (e) {
    debugPrint('Error fetching media: $e');
  }
  return medias;
}

class MediaItem extends StatelessWidget {
  final Media media;
  final bool isSelected;
  final Function selectMedia;
const MediaItem({
    required this.media,
    required this.isSelected,
    required this.selectMedia,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => selectMedia(media),
      child: Stack(
        children: [
          _buildMediaWidget(),
          if (isSelected) _buildIsSelectedOverlay(),
        ],
      ),
    );
  }
  //選択したら画像の周りにpaddingを表示する
Widget _buildMediaWidget() {
    return Positioned.fill(
      child: Padding(
        padding: EdgeInsets.all(isSelected ? 10.0 : 0.0),
        // Display the media widget
        child: media.widget,
      ),
    );
  }
  //選択した画像に✔マークを表示する
  Widget _buildIsSelectedOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.1),
        child: const Center(
          child: Icon(
            Icons.check_circle_rounded,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }
}

class MediasGridView extends StatelessWidget {
  final List<Media> medias;
  final List<Media> selectedMedias;
  final Function(Media) selectMedia;
  final ScrollController scrollController;
  const MediasGridView({
    super.key,
    required this.medias,
    required this.selectedMedias,
    required this.selectMedia,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.0),
      child: GridView.builder(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),//バウンド効果あるスクロール
        itemCount: medias.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 4,
         crossAxisSpacing: 3,
        ),
        itemBuilder: (context, index) => MediaItem(
          media: medias[index],
          isSelected: selectedMedias.any((element) =>
          element.assetEntity.id == medias[index].assetEntity.id),
          selectMedia: selectMedia,
        ),
      ),
    );
  }
}
