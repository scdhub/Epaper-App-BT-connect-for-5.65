// 画像一覧グリッド表示
import 'package:flutter/material.dart';

import 'crop_photo-select.dart';
import 'crop_photo_select_tap-action.dart';

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
        physics: const BouncingScrollPhysics(),//端まで移動した時、バウンド効果を持たせる
        itemCount: medias.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 4,
          crossAxisSpacing: 3,
        ),
        itemBuilder: (context, index) => TapAction(
          media: medias[index],
          isSelected: selectedMedias.any((element) =>
          element.assetEntity.id == medias[index].assetEntity.id),
          selectMedia: selectMedia,
        ),
      ),
    );
  }
}