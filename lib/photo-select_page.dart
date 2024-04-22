import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:transparent_image/transparent_image.dart';
import 'appserver.dart';
import 'photo-select_name-select.dart';
import 'photo-select_image-list.dart';
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

class imageSelect_Album extends StatefulWidget {


  @override
  _imageSelectAlbumState createState() => _imageSelectAlbumState();
}

class _imageSelectAlbumState extends State<imageSelect_Album> {

  final ScrollController _scrollController = ScrollController();
  AssetPathEntity? _currentAlbum;
  List<AssetPathEntity> _albums = [];
  // List<AssetEntity> _albums = [];
  final List<Media> _medias = [];
  int _lastPage = 0;
  int _currentPage = 0;
  List<AssetPathEntity> albums = [];
  final List<Media> _selectedMedias = [];
  final List<Media> selectedMedias =[];
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
      // albums = await fetchAlbums();
      albums = await PhotoManager.getAssetPathList(
        // onlyAll: false,
        type: RequestType.image,
      );//アルバムリスト取得
      // _fetchPhotos(albums.first);
      // _currentAlbum(albums.first);
      if(albums.isNotEmpty){
        _currentAlbum = albums.first;
        _albums = albums;
        _loadMedias();
      }

    } else {
      PhotoManager.openSetting();//許可がない時設定を開く
    }
  }
  _fetchPhotos(AssetPathEntity album) async {
    // final photoList = await album.getAssetListPaged(page: 0, size: 100);//今のところ100枚の画像を取得するようにしている。後ほどすべて抜き出せるように修正。
    // setState(() {
    //   _currentAlbum = album
    // });

    // setState(() {
    //   _albums = photoList;
    // });
  }
  //   if (albums.isNotEmpty) {
  //     setState(() {
  //       // Set the first album as the current album
  //       _currentAlbum = albums.first;
  //       // Update the list of albums
  //       _albums = albums;
  //     });
  //     // Load media items for the current album
  //     _loadMedias();
  //   }
  // }

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
        // Select the media item if not already selected
        _selectedMedias.add(media);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        // Close the screen and pass selected media items back
        // onPressed: () => Navigator.push(context,
        //
        //     MaterialPageRoute(builder: (context) =>
        //         SelectCheck(imageData: _selectedMedias))),
        onPressed: () async{
          List<Uint8List?> imageDataList = [];
          for (Media media in _selectedMedias){
            Uint8List? data = await getMediaData(media.assetEntity);
            if(data != null){
              imageDataList.add(data);
            }
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SelectCheck(imageData: imageDataList),
            ),
          );
        },

        // Display check icon
        child: const Icon(Icons.check_rounded),
      ),
    );
  }
}

Future<Uint8List?> getMediaData(AssetEntity assetEntity) async {
  return await assetEntity.originBytes;
}

// Function to fetch media items from a specific album and page
Future<List<Media>> fetchMedias({
  required AssetPathEntity album,
  required int page,
}) async {
  List<Media> medias = [];

  try {
    // Get a list of asset entities from the specified album and page
    final List<AssetEntity> entities =
    await album.getAssetListPaged(page: 0, size: 30);

    // Loop through each asset entity and create corresponding Media objects
    for (AssetEntity entity in entities) {
      // Assign the asset entity to the Media object
      Media media = Media(
        assetEntity: entity,
        // Create a FadeInImage widget to display the media thumbnail
        widget: FadeInImage(
          // Placeholder image
          placeholder: MemoryImage(kTransparentImage),
          // Set the fit mode to cover
          fit: BoxFit.cover,
          // Use AssetEntityImageProvider to load the media thumbnail
          image: AssetEntityImageProvider(
            entity,
            // Thumbnail size
            thumbnailSize: const ThumbnailSize.square(300),
            // Load a non-original (thumbnail) image
            isOriginal: false,
          ),
        ),
      );

      // Media media = Media(
      //   assetEntity: entity,
      //   widget: imageWidget,
      // );
      // Add the created Media object to the list
      medias.add(media);
    }


  } catch (e) {
    // Handle any exceptions that occur during fetching
    debugPrint('Error fetching media: $e');
  }

  // Return the list of fetched media items
  return medias;
}

// Widget to display a media item with optional selection overlay
class MediaItem extends StatelessWidget {
  // The media to display
  final Media media;

  // Indicates whether the media is selected
  final bool isSelected;

  // Callback function when the media is tapped
  final Function selectMedia;

  // Unique identifier for the widget, passes the key to the super constructor
  const MediaItem({
    required this.media,
    required this.isSelected,
    required this.selectMedia,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Callback function when the media is tapped
      onTap: () => selectMedia(media),
      child: Stack(
        children: [
          //     // Display the media widget with optional padding
          _buildMediaWidget(),
          //     // Display the selected overlay if the media is selected
          if (isSelected) _buildIsSelectedOverlay(),
        ],
      ),
    );
  }

  // Build the media widget with optional padding
  Widget _buildMediaWidget() {
    return Positioned.fill(
      child: Padding(
        padding: EdgeInsets.all(isSelected ? 10.0 : 0.0),
        // Display the media widget
        child: media.widget,
      ),
    );
  }

  // Build the selected overlay
  Widget _buildIsSelectedOverlay() {
    return Positioned.fill(
      child: Container(
        // Semi-transparent black overlay
        color: Colors.black.withOpacity(0.1),
        child: const Center(
          child: Icon(
            // Checkmark icon
            Icons.check_circle_rounded,
            // White color for the icon
            color: Colors.white,
            // Size of the icon
            size: 30,
          ),
        ),
      ),
    );
  }
}

// Widget to display a grid of media items
class MediasGridView extends StatelessWidget {
  // List of all media items
  final List<Media> medias;

  // List of selected media items
  final List<Media> selectedMedias;

  // Callback function to select a media item
  final Function(Media) selectMedia;

  // Controller for scrolling
  final ScrollController scrollController;

  // final List<AssetPathEntity> albums;

  const MediasGridView({
    // Unique identifier for the widget
    super.key,
    // List of all media items
    required this.medias,
    // List of selected media items
    required this.selectedMedias,
    // Callback function to select a media item
    required this.selectMedia,
    // Controller for scrolling
    required this.scrollController,

    // required this.albums
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.0),
      child: GridView.builder(
        // Assign the provided scroll controller
        controller: scrollController,
        // Apply bouncing scroll physics
        physics: const BouncingScrollPhysics(),
        // Set the number of items in the grid
        itemCount: medias.length,
        // 3 columns in the grid
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          // Spacing between rows
          mainAxisSpacing: 4,
          // Spacing between columns
          crossAxisSpacing: 3,
        ),
        // Build each media item using the MediaItem widget
        itemBuilder: (context, index) => MediaItem(
          // Pass the current media item
          media: medias[index],
          // Check if the media item is selected
          isSelected: selectedMedias.any((element) =>
          element.assetEntity.id == medias[index].assetEntity.id),
          // Pass the selectMedia callback function
          selectMedia: selectMedia,
        ),
      ),
    );
  }
}


//   List<AssetPathEntity> albums = [];//ポップメニュー
//   List<AssetEntity> photos = [];//gridviewに映す
//   int? selectedAlbumIndex;
//
//
//
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchAlbums();//初期化時にアルバム取得
//
//   }
//
//
//
//   _fetchAlbums() async {
//     final permitted = await PhotoManager.requestPermissionExtend();//初回写真へのアクセス許可を要求
//     if (permitted.isAuth) {
//       // onlyAll: をtrueにすると最初のファイルしかリスト一覧に出ないため、falseに設定
//       albums = await PhotoManager.getAssetPathList(
//           // onlyAll: false,
//         type: RequestType.image,
//       );//アルバムリスト取得
//       _fetchPhotos(albums.first);
//     } else {
//       PhotoManager.openSetting();//許可がない時設定を開く
//     }
//   }
//   //アルバムの写真のリスト
//   _fetchPhotos(AssetPathEntity album) async {
//     final photoList = await album.getAssetListPaged(page: 0, size: 100);//今のところ100枚の画像を取得するようにしている。後ほどすべて抜き出せるように修正。
//     setState(() {
//       photos = photoList;
//     });
//   }
//
//   Future<int> _fetchAssetCount(AssetPathEntity album) async {
//     final photoList = await album.getAssetListPaged(page: 0, size: 1000000);
//     final filteredPhotos = photoList.where((asset) => asset.type == AssetType.image).toList();
//     return filteredPhotos.length;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back, color: Colors.white),
//             onPressed: () => Navigator.of(context).pop(),
//           ),
//           title: PopupMenuAlbumName(//写真フォルダリスト名表示
//             albums: albums,
//             onAlbumSelected: (index) {//リスト名を選択したら表示する
//               setState(() {
//                 selectedAlbumIndex = index;
//                 _fetchPhotos(albums[index]);
//               });
//             },
//             selectedAlbumIndex: selectedAlbumIndex,
//             photos: photos,
//             fetchAssetCount: _fetchAssetCount,
//           ),
//           backgroundColor: Colors.black,
//         ),
//         body: ImageList(photos: photos),
//       ),
//     );
//   }
// }

