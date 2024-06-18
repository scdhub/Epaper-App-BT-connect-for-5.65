import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class ServerImageDelGridView extends StatelessWidget {

  final List<dynamic> imageItems;
  final List<dynamic> selectedMedias;
  final Function(dynamic) selectMedia;
  final ScrollController scrollController;
  final bool gridReverse;
  final List<dynamic> delImageDataList;


  const ServerImageDelGridView({
    super.key,
    required this.imageItems,
    required this.selectedMedias,
    required this.selectMedia,
    required this.scrollController,
    required this.gridReverse, required this.delImageDataList,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.0),
      child: GridView.builder(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        itemCount:imageItems.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 1.0,
          crossAxisSpacing: 1.0,
        ),
        itemBuilder: (context, index) => DeleteItem(

          media: imageItems[index],
          isSelected: selectedMedias.any((element) =>
          element.url == imageItems[index].url || element.url == imageItems[index].url),
          selectMedia: selectMedia,
            gridReverse:gridReverse
        ),
      ),
    );
  }
}

class DeleteItem extends StatelessWidget {
  final bool isSelected;
  final bool gridReverse;
  final dynamic media;
  final Function(dynamic) selectMedia;

  const DeleteItem({
    required this.media,
    required this.isSelected,
    required this.selectMedia,
    required this.gridReverse,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // メディアがタップされたときのコールバック関数
      onTap: () => gridReverse?selectMedia(media):selectMedia(media),
      child: Stack(
        children: [
          // メディアウィジェットをオプションのパディングと共に表示
          _buildMediaWidget(),
          // メディアが選択されている場合、選択オーバーレイを表示
           isSelected ? _buildIsSelectedOverlay() : SizedBox.shrink(),
        ],
      ),
    );
  }
// 画像を選択した時に、画像の周りにpaddingを設ける
  Widget _buildMediaWidget() {
    return Positioned.fill(
      child: Padding(
        padding:EdgeInsets.all(isSelected ? 10.0 : 0.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!, width: 1),

          ),
          child: Center(
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              // image: gridReverse ? media.url : media.url,
              image: media.url,
              ),
          ),
        ),
      ),
    );
  }

  // 選択した時に画像上に✔マークを出す。
  Widget _buildIsSelectedOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: const Center(
          child: Icon(
            Icons.check_circle_rounded,
            color: Colors.redAccent,
            size: 30,
          ),
        ),
      ),
    );
  }
}

