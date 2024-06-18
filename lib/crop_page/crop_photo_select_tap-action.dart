import 'package:flutter/material.dart';

import 'crop_photo-select.dart';

class TapAction extends StatelessWidget {
  final Media media;

  final bool isSelected;

  final Function selectMedia;

  const TapAction({
    required this.media,
    required this.isSelected,
    required this.selectMedia,
    super.key,
  });
//
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

  //画像を選択した時、画像の周りに隙間を作り、視覚的にわかりやすくする。
  Widget _buildMediaWidget() {
    return Positioned.fill(
      child: Padding(
        padding: EdgeInsets.all(isSelected ? 10.0 : 0.0),
        child: media.widget,
      ),
    );
  }

  //画像を選択した時の画像上に✔ボタンを表示
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