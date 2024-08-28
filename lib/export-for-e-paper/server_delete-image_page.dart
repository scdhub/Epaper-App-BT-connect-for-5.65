import 'package:flutter/material.dart';
// import 'package:iphone_bt_epaper/export-for-e-paper/sever_data_bind.dart';
import 'package:transparent_image/transparent_image.dart';

class ServerImageDelGridView extends StatefulWidget {
  const ServerImageDelGridView({
    Key? key,
    required this.imageItems,
    required this.selectedMedias,
    required this.selectMedia,
    required this.scrollController,
    required this.gridReverse,
    required this.count,
  }) : super(key: key);
  final List<dynamic> imageItems;
  final List<dynamic> selectedMedias;
  final Function(dynamic) selectMedia;
  final ScrollController scrollController;
  final bool gridReverse;
  final int count;

  @override
  State<ServerImageDelGridView> createState() => _ServerImageDelGridView();
}

class _ServerImageDelGridView extends State<ServerImageDelGridView> {
  // final ScrollController scrollController = ScrollController();
  List<dynamic> _items = [];
  bool currentReverse = false;

// widget初回読み込み時処理
  @override
  void initState() {
    super.initState();
    currentReverse = widget.gridReverse;
    for (int i = 0; i < widget.count; i++) {
      _items.add(widget.imageItems[i]);
    }
    setItemPrecache();
    widget.scrollController.addListener(_loadContents);
  }

  @override
  void dispose() {
    // widget.scrollController.removeListener(_loadContents);
    // widget.scrollController.dispose();
    super.dispose();
  }

// 親widgetのsetState()をトリガーとして発火する処理
  @override
  void didUpdateWidget(ServerImageDelGridView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // ソート切り替えをトリガーとして_itemsをリセット
    if (isChengedSort()) {
      _items = [];
      for (int i = 0; i < widget.count; i++) {
        if (i < widget.imageItems.length) {
          _items.add(widget.imageItems[i]);
        } else {
          break;
        }
      }
    }
  }

  void _loadContents() {
    if (widget.scrollController.position.pixels /
            widget.scrollController.position.maxScrollExtent >
        0.80) {
      if (_items.length != widget.imageItems.length) {
        _addContents();
      }
    }
  }

// プリキャッシュ保存処理
  void setItemPrecache() {
    // 既存のキャッシュクリア
    imageCache.clear();
    final binding = WidgetsFlutterBinding.ensureInitialized();
    binding.deferFirstFrame(); // フレームの描画をストップさせる
    // 最初のフレームの描画が完了したら実行する関数を定義
    binding.addPostFrameCallback((_) {
      final Element? context = binding.rootElement;
      if (context != null) {
        for (int i = 0; i < widget.imageItems.length; i++) {
          if (widget.gridReverse) {
            final image = NetworkImage(widget.imageItems[i].url)
              ..resolve(const ImageConfiguration())
                  .addListener(ImageStreamListener((_, __) {
                binding.allowFirstFrame(); // フレームの描画を許可する
              }));
            precacheImage(image, context); // 読み込んだ画像をキャッシュする
          } else {
            final image = NetworkImage(widget.imageItems[i].url)
              ..resolve(const ImageConfiguration())
                  .addListener(ImageStreamListener((_, __) {
                binding.allowFirstFrame();
              }));
            precacheImage(image, context);
          }
        }
      }
    });
    // inspect(imageCache);
  }

// スクロールが画面下部に達した際の処理
  _addContents() {
    if (mounted) {
      setState(() {
        // ここで次に表示する件数を制御
        for (int i = 0; i < widget.count; i++) {
          if ((i + _items.length) < widget.imageItems.length) {
            _items.add(widget.imageItems[_items.length]);
          } else {
            break;
          }
        }
      });
    }
  }

  isChengedSort() {
    if (currentReverse != widget.gridReverse) {
      currentReverse = widget.gridReverse;
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.0),
      child: GridView.builder(
        controller: widget.scrollController,
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 150), // 下部のpadding
        itemCount: _items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 1.0,
          crossAxisSpacing: 1.0,
        ),
        itemBuilder: (context, index) => DeleteItem(
            media: _items[index],
            isSelected: widget.selectedMedias.any((element) =>
                element.url == _items[index].url ||
                element.url == _items[index].url),
            selectMedia: widget.selectMedia,
            gridReverse: widget.gridReverse),
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
    super.key,
    required this.media,
    required this.isSelected,
    required this.selectMedia,
    required this.gridReverse,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // メディアがタップされたときのコールバック関数
      onTap: () => gridReverse ? selectMedia(media) : selectMedia(media),
      child: Stack(
        children: [
          // メディアウィジェットをオプションのパディングと共に表示
          _buildMediaWidget(),
          // メディアが選択されている場合、選択オーバーレイを表示
          isSelected ? _buildIsSelectedOverlay() : const SizedBox.shrink(),
        ],
      ),
    );
  }

// 画像を選択した時に、画像の周りにpaddingを設ける
  Widget _buildMediaWidget() {
    return Positioned.fill(
      child: Padding(
        padding: EdgeInsets.all(isSelected ? 10.0 : 0.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!, width: 1),
          ),
          child: Center(
              child: Image.network(
            media.url,
            errorBuilder: (context, error, stackTrace) {
              return Image.network(media.url,
                  errorBuilder: (context, error, stackTrace) {
                return Image.network(
                  media.url,
                  errorBuilder: (c, o, s) {
                    return const Icon(
                      Icons.error,
                      color: Colors.red,
                    );
                  },
                );
              });
            },
          )),
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
