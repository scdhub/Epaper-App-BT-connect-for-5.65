import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:transparent_image/transparent_image.dart';

// import 'appserver.dart';
import '../server_upload/select-photo-check_page.dart';
import 'crop_page.dart';

// import 'photo-select_name-select.dart';
// import 'photo-select_image-list.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
// import 'select-photo-check_page.dart';

class Media {
  final AssetEntity assetEntity;
  final Widget widget;

  Media({
    required this.assetEntity,
    required this.widget,
  });
}

class CropImageSelect_Album extends StatefulWidget {
  @override
  _CropImageSelectAlbumState createState() => _CropImageSelectAlbumState();
}

class _CropImageSelectAlbumState extends State<CropImageSelect_Album> {
  final ScrollController _scrollController = ScrollController();
  AssetPathEntity? _currentAlbum;
  List<AssetPathEntity> _albums = [];
  final List<Media> _medias = [];
  int _lastPage = 0;
  int _currentPage = 0;
  List<AssetPathEntity> albums = [];
  final List<Media> _selectedMedias = [];
  final List<Media> selectedMedias = [];

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
    final permitted = await PhotoManager.requestPermissionExtend();
    if (permitted.isAuth) {
      albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
      );
      //アルバムリスト取得
      if (albums.isNotEmpty) {
        _currentAlbum = albums.first;
        _albums = albums;
        _loadMedias();
      }
    } else {
      PhotoManager.openSetting(); //許可がない時設定を開く
    }
  }

  // Method to load media items asynchronously
  void _loadMedias() async {
    // Store the current page as the last page
    _lastPage = _currentPage;
    if (_currentAlbum != null) {
      // Fetch media items for the current album
      List<Media> medias =
          await fetchMedias(album: _currentAlbum!, page: _currentPage);
      setState(() {
        // Add fetched media items to the list
        _medias.addAll(medias);
      });
    }
  }

  // Method to load more media items when scrolling
  void _loadMoreMedias() {
    if (_scrollController.position.pixels /
            _scrollController.position.maxScrollExtent >
        0.33) {
      // Check if scrolled beyond 33% of the scroll extent
      if (_currentPage != _lastPage) {
        // Load more media items
        _loadMedias();
      }
    }
  }

  // Method to select or deselect a media item
  void _selectMedia(Media media) {
    bool isSelected = _selectedMedias.any((element) =>
        element.assetEntity.id ==
        media.assetEntity.id); // Check if the media item is already selected
    setState(() {
      if (isSelected) {
        // Deselect the media item if already selected
        _selectedMedias.removeWhere(
            (element) => element.assetEntity.id == media.assetEntity.id);
      } else {
        _selectedMedias.clear();

        _selectedMedias.add(media);
      }
    });
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('エラー'),
          content: Text('この画像は選択できません。\n他の画像を選択するか\nスマホ内に保存されているか確認ください。'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _cropImage(AssetEntity asset) async {
    final file = await asset.file;
    ImageCropper imageCropper = ImageCropper();
    final croppedFile = await imageCropper.cropImage(
      sourcePath: file!.path,
      // aspectRatio: CropAspectRatio(ratioX: 600, ratioY: 448),
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        // CropAspectRatio(ratioX: 600, ratioY: 448),
        // CropAspectRatioPreset.ratio3x2,
        // CropAspectRatioPreset.original,
        // CropAspectRatioPreset.ratio4x3,
        // CropAspectRatioPreset.ratio16x9
      ],
      aspectRatio: CropAspectRatio(ratioX: 600, ratioY: 448),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'トリミング画面',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'トリミング画面',
          cancelButtonTitle: 'Cancel',
          doneButtonTitle: 'Crop',
          // minimumAspectRatio: 1.0,
          minimumAspectRatio: 600/448,

        ),
      ],
    );

    if (croppedFile != null) {
      // クロップされた画像を使用
      // クロップされた画像ファイルをUint8Listに変換
      Uint8List cropBytes = await File(croppedFile.path).readAsBytes();
      var croppedBytes = [cropBytes];
      // Uint8Listを次のページに渡す
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelectCheck(imageData: croppedBytes),
        ),
      );

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // toolbarTextStyle: TextStyle(color:Colors.white),
        title: DropdownButton<AssetPathEntity>(
          borderRadius: BorderRadius.circular(16.0),
          value: _currentAlbum,
          items: _albums
              .map(
                (e) => DropdownMenuItem<AssetPathEntity>(
                  value: e,
                  // Display album name in dropdown
                  child: Text(e.name.isEmpty ? "0" : e.name),
                ),
              )
              .toList(),
          onChanged: (AssetPathEntity? value) {
            setState(() {
              // Set the selected album as the current album
              _currentAlbum = value;
              // Reset current page to load from the beginning
              _currentPage = 0;
              // Reset last page
              _lastPage = 0;
              // Clear existing media items
              _medias.clear();
            });
            // Load media items for the selected album
            _loadMedias();
            // Scroll to the top
            _scrollController.jumpTo(0.0);
          },
        ),

        // backgroundColor: Colors.blue,
      ),
      body: MediasGridView(
        // Pass the list of media items to the grid view
        medias: _medias,
        // Pass the list of selected media items to the grid view
        selectedMedias: _selectedMedias,
        // Pass the method to select or deselect a media item
        selectMedia: _selectMedia,
        // Pass the scroll controller to the grid view
        scrollController: _scrollController,

        // albums:albums,
      ),
      floatingActionButton: _selectedMedias.isEmpty
          ? null
          : FloatingActionButton(
              onPressed: () async {
                try{
                Uint8List? cropImageData;
                // List<String?> imageMetaData = [];
                for (Media media in _selectedMedias) {
                  // Uint8List? data = await getMediaData(media.assetEntity);
                  // if (data != null) {
                  //   setState(() {
                  //     cropImageData = data;
                  //   });
                  // }
                  AssetEntity asset = media.assetEntity;
                  // _cropImageメソッドを呼び出し


                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) =>
                  //         TrimmingPage(imageData: cropImageData),
                  //   ),
                  // );
                  _cropImage(asset);
                }
                }catch(e){
                  _showErrorDialog();
                }
              },

              backgroundColor: Colors.lightGreenAccent,
              child: const Icon(Icons.add_task_outlined),
            ),
    );
  }
}

Future<Uint8List?> getMediaData(AssetEntity assetEntity) async {
  return await assetEntity.originBytes;
}

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
          placeholder: MemoryImage(kTransparentImage),
          fit: BoxFit.cover,
          image: AssetEntityImageProvider(
            entity,
            thumbnailSize: const ThumbnailSize.square(300),
            isOriginal: false,
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

  Widget _buildMediaWidget() {
    return Positioned.fill(
      child: Padding(
        padding: EdgeInsets.all(isSelected ? 10.0 : 0.0),
        child: media.widget,
      ),
    );
  }

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
        physics: const BouncingScrollPhysics(),
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
