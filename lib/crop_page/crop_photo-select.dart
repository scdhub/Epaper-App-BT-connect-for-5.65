import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

import '../app_body_color.dart';
import 'crop_photo_select_gridview.dart';
import 'crop_page.dart';

class Media {
  final AssetEntity assetEntity;
  final Widget widget;

  Media({
    required this.assetEntity,
    required this.widget,
  });
}

class CropImageSelect_Album extends StatefulWidget {
  const CropImageSelect_Album({super.key});

  @override
  State<CropImageSelect_Album> createState() => _CropImageSelectAlbumState();
}

class _CropImageSelectAlbumState extends State<CropImageSelect_Album> {
  final ScrollController _scrollController = ScrollController(); //スクロール制御
  AssetPathEntity? _currentAlbum; //選択したアルバム名
  List<AssetPathEntity> _albums = []; //アルバムリスト
  final List<Media> _medias = []; //選択したアルバムのリスト
  int _lastPage = 0; // 最後に読み込まれたページ
  int _currentPage = 0; //現在読み込まれたページ
  List<AssetPathEntity> albums = []; //アルバムリストの一時保存
  final List<Media> _selectedMedias = []; //選択した画像のリスト保存
  final List<Media> selectedMedias = []; //選択された画像の一時保存
  final Map<AssetPathEntity, int> _albumImageCounts = {}; //画像数取得

  @override
  void initState() {
    super.initState();
    _selectedMedias.addAll(selectedMedias); //選択した画像の初期化
    _loadAlbums();
    _scrollController.addListener(_loadMoreMedias); //スクロールイベントのリッスン
  }

  //?
  @override
  void dispose() {
    _scrollController.removeListener(_loadMoreMedias); //スクロール位置に応じて画像を読み込む
    _scrollController.dispose(); //メモリリークを防ぐため。widgetが破棄されるとき呼び出される
    super.dispose();
  }

  void _loadAlbums() async {
    //アルバム情報を読み込む許可
    final permitted = await PhotoManager.requestPermissionExtend();
    if (permitted.isAuth) {
      //許可が出た場合
      albums = await PhotoManager.getAssetPathList(
        //画像のみを取得
        type: RequestType.image,
      );
      //アルバムリスト取得
      if (albums.isNotEmpty) {
        _currentAlbum = albums.first; //最初のアルバムを現在参照するアルバムに設定する
        _albums = albums; //アルバムリストの保存

        // 各アルバムの画像数を取得
        for (var album in albums) {
          final List<AssetEntity> entities =
              await album.getAssetListPaged(page: 0, size: 100000000);
          // final List<AssetEntity> entities = await album.getAssetList();
          _albumImageCounts[album] = entities.length;
        }

        _loadMedias();
      }
    } else {
      PhotoManager.openSetting(); //許可がない時設定を開く
    }
  }

//選択されたアルバム名の情報を取得
  void _loadMedias() async {
    _lastPage = _currentPage; //最後に読み込んだページとして保存
    if (_currentAlbum != null) {
      List<Media> medias =
          await fetchMedias(album: _currentAlbum!, page: _currentPage);
      setState(() {
        _medias.addAll(medias);
      });
    }
  }

//スクロール位置に応じてメディアを読み込む
  void _loadMoreMedias() {
    if (_scrollController.position.pixels /
            _scrollController.position.maxScrollExtent >
        0.33) {
      if (_currentPage != _lastPage) {
        _loadMedias();
      }
    }
  }

//画像の選択、解除
  void _selectMedia(Media media) {
    bool isSelected = _selectedMedias
        .any((element) => element.assetEntity.id == media.assetEntity.id);
    setState(() {
      if (isSelected) {
        _selectedMedias.removeWhere(
            (element) => element.assetEntity.id == media.assetEntity.id);
      } else {
        _selectedMedias.clear();

        _selectedMedias.add(media);
      }
    });
  }

  // エラーダイアログを表示
  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('エラー'),
          content:
              const Text('この画像は選択できません。\n他の画像を選択するか\nスマホ内に保存されているか確認ください。'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: DropdownButton<AssetPathEntity>(
          dropdownColor: Colors.grey,
          borderRadius: BorderRadius.circular(16.0),
          value: _currentAlbum, //選択したアルバム情報
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
              _currentAlbum = value; //選択したアルバムを表示ため
              _currentPage = 0; //スクロール位置リセットのため
              _lastPage = 0; //スクロール位置リセットのため
              _medias.clear(); //今現在のアルバムリセット
            });
            _loadMedias(); //選択したアルバムの画像を読み込む
            _scrollController.jumpTo(0.0); //スクロール位置をトップに戻す
          },
        ),
      ),
      body: CustomPaint(
        painter: HexagonPainter(),
        child: MediasGridView(
          //画像をgridview表示するクラス
          medias: _medias,
          selectedMedias: _selectedMedias,
          selectMedia: _selectMedia,
          scrollController: _scrollController,
        ),
      ),
      floatingActionButton: _selectedMedias.isEmpty
          ? null
          : FloatingActionButton(
              onPressed: () async {
                try {
                  for (Media media in _selectedMedias) {
                    AssetEntity asset = media.assetEntity;
                    cropImage(context, asset); //クロップ画面に移動する
                  }
                } catch (e) {
                  _showErrorDialog();
                }
              },
              backgroundColor: Colors.lightGreenAccent,
              child: const Icon(Icons.add_task_outlined),
            ),
    );
  }
}

//バイトデータに変換
Future<Uint8List?> getMediaData(AssetEntity assetEntity) async {
  return await assetEntity.originBytes;
}

//アルバムから画像を読み込む
Future<List<Media>> fetchMedias({
  required AssetPathEntity album,
  required int page,
}) async {
  List<Media> medias = [];

  try {
    final List<AssetEntity> entities =
        await album.getAssetListPaged(page: 0, size: 100000000);

    for (AssetEntity entity in entities) {
      Media media = Media(
        assetEntity: entity,
        widget: FadeInImage(
          //プレースホルダーから実際の画像に滑らかに表示
          placeholder: MemoryImage(kTransparentImage), //プレースホルダー
          fit: BoxFit.cover,
          image: AssetEntityImageProvider(
            //元の画像のサムネイル化
            entity,
            thumbnailSize: const ThumbnailSize.square(300),
            isOriginal: false, //falseにすることで、サムネイル画像設定する
          ),
        ),
      );
      medias.add(media);
    }
  } catch (e) {
    debugPrint('Error fetching media: $e');
  }

  return medias;
}
