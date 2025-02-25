import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:iphone_bt_epaper/export-for-e-paper/server_delete-image_page.dart';
import 'package:iphone_bt_epaper/export-for-e-paper/sever_data_bind.dart';
import 'package:transparent_image/transparent_image.dart';
import '../app_body_color.dart';
// import '../bt_connect_page/connect_bt_page.dart';
import 'server_get-image.dart';
import 'server_image_delete_check_popup.dart';
import 'scrollappbar.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class SendPictureSelect extends StatefulWidget {
  final BluetoothDevice deviceInfo;
  final CacheManager? cacheManager;
  const SendPictureSelect(
      {super.key, required this.deviceInfo, this.cacheManager});
  @override
  State<SendPictureSelect> createState() => _SendPictureSelectState();
}

class _SendPictureSelectState extends State<SendPictureSelect> {
  bool gridReverse = false; //表示順序切り替え 初期新しい順

  List<ImageItem> imageItems = []; //サーバーデータ：古い順
  List<ReversedData> reverseData = []; //サーバーデータ：新しい順
  List<DateSort> dateSort = []; //日付並び替え
  List<DelData> delImageDataList = []; //サーバ画像削除
  final List<DelData> _delImageDataList = []; //サーバ画像削除
  bool isOn = false; //削除ボタン切り替え
  List<ImageItem> delImageItems = []; //削除データ：古い順
  final List<ImageItem> _delImageItems = []; //削除データ：古い順
  List<ReversedData> delReverseData = []; //削除データ選択:新しい順
  final List<ReversedData> _delReverseData = []; //削除データ選択:新しい順
  List<BluetoothService> services = []; //接続したデバイスのサービス情報を読み取る

  final ScrollController _scrollController = ScrollController();

  int count = 50; //画像表示件数
  List<dynamic> _items = []; //実際の表示に使われるリスト
  bool isGetImages = false; //画像取得の状態

  @override
  void initState() {
    super.initState();
    initialize();
    _scrollController.addListener(_loadContents);
    _delImageItems.addAll(delImageItems);
    _delReverseData.addAll(delReverseData);
    _delImageDataList.addAll(delImageDataList);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_loadContents);
    _scrollController.dispose();
    super.dispose();
  }

  void _loadContents() {
    if (_scrollController.position.pixels /
            _scrollController.position.maxScrollExtent >
        0.80) {
      if (_items.length != imageItems.length) {
        _addContents();
      }
    }
  }

  // 画像URL取得
  Future<void> initialize() async {
    isGetImages = false;
    // final BuildContext context = binding.rootElement as BuildContext;
    await getImage(
      context: context,
      imageItems: imageItems,
      reverseData: reverseData,
      dateSort: dateSort,
    );
    // inspect(imageItems);

    if (imageItems.isNotEmpty) {
      for (int i = 0; i < count; i++) {
        if (gridReverse) {
          _items.add(reverseData[i]);
        } else {
          _items.add(imageItems[i]);
        }
      }
    }

    // プリキャッシュ保存処理
    setItemPrecache();

    if (mounted) {
      setState(() {
        isGetImages = true;
      });
    }
  }

// スクロールが画面下部に達した際の処理
  _addContents() {
    if (mounted) {
      setState(() {
        // ここで次に表示する件数を制御
        for (int i = 0; i < count; i++) {
          if (gridReverse) {
            if ((i + _items.length) < reverseData.length) {
              _items.add(reverseData[_items.length]);
            } else {
              break;
            }
          } else {
            if ((i + _items.length) < imageItems.length) {
              _items.add(imageItems[_items.length]);
            } else {
              break;
            }
          }
        }
      });
    }
  }

  // プリキャッシュ保存処理
  void setItemPrecache() {
    // 既存のキャッシュクリア
    imageCache.clear();
    imageCache.clearLiveImages();
    final binding = WidgetsFlutterBinding.ensureInitialized();
    binding.deferFirstFrame(); // フレームの描画をストップさせる
    // 最初のフレームの描画が完了したら実行する関数を定義
    binding.addPostFrameCallback((_) {
      final Element? context = binding.rootElement;
      if (context != null) {
        for (int i = 0; i < imageItems.length; i++) {
          if (gridReverse) {
            final image = NetworkImage(reverseData[i].url)
              ..resolve(const ImageConfiguration())
                  .addListener(ImageStreamListener((_, __) {
                binding.allowFirstFrame(); // フレームの描画を許可する
              }));
            precacheImage(image, context); // 読み込んだ画像をキャッシュする
          } else {
            final image = NetworkImage(imageItems[i].url)
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

  itemsReset() {
    _items = [];
    if (isGetImages) {
      for (int i = 0; i < count; i++) {
        if (gridReverse) {
          _items.add(reverseData[i]);
        } else {
          _items.add(imageItems[i]);
        }
      }
    }
  }

// 削除時に画像一覧を更新する関数
  Future<void> fetchData() async {
    if (mounted) {
      setState(() {
        isGetImages = false;
      });
      imageItems.clear();
      await getImage(
        // ignore: use_build_context_synchronously
        context: context,
        imageItems: imageItems,
        reverseData: reverseData,
        dateSort: dateSort,
      );

      // プリキャッシュ保存処理
      setItemPrecache();

      setState(() {
        _delImageDataList.clear();
        _delImageItems.clear();
        _delReverseData.clear();
        isGetImages = true;
      });
    }
  }

  // 下スワイプでの画面更新
  // Future<void> onRefresh() async {
  //   await getImage(
  //     // ignore: use_build_context_synchronously
  //     context: context,
  //     imageItems: imageItems,
  //     reverseData: reverseData,
  //     dateSort: dateSort,
  //   );

  //   // プリキャッシュ保存処理
  //   setItemPrecache();

  //   if (mounted) {
  //     setState(() {
  //       _delImageDataList.clear();
  //       _delImageItems.clear();
  //       _delReverseData.clear();
  //     });
  //   }
  //   // inspect(imageCache);
  // }

//選択した画像の✔の表示、非表示 古い順
  void _selectDelImageItems(dynamic media) {
    if (media is ImageItem) {
      bool isSelected = _delImageItems.any((element) => element.id == media.id);
      setState(() {
        if (isSelected) {
          _delImageItems.removeWhere((element) => element.id == media.id);
          _delImageDataList.removeWhere((element) => element.idDel == media.id);
        } else {
          _delImageItems.add(media);
          List<ImageItem> addImage = [];
          for (var items in _delImageItems) {
            if (items.id == media.id) {
              addImage.add(items);
              for (var item in addImage) {
                _delImageDataList.add(DelData(
                  idDel: item.id,
                  url: item.url,
                  lastModifiedDel: item.lastModified,
                ));
              }
            }
          }
        }
      });
      if (kDebugMode) {
        print(_delImageDataList);
      }
    }
  }

  // 新しい順
  void _selectDelReversedData(dynamic reversedImage) {
    if (reversedImage is ReversedData) {
      bool isSelected =
          _delReverseData.any((element) => element.idR == reversedImage.idR);
      setState(() {
        if (isSelected) {
          _delReverseData
              .removeWhere((element) => element.idR == reversedImage.idR);
          _delImageDataList
              .removeWhere((element) => element.idDel == reversedImage.idR);
        } else {
          _delReverseData.add(reversedImage);
          List<ReversedData> addReversedImage = [];
          for (var items in _delReverseData) {
            if (items.idR == reversedImage.idR) {
              addReversedImage.add(items);
              for (var item in addReversedImage) {
                _delImageDataList.add(DelData(
                  idDel: item.idR,
                  url: item.url,
                  lastModifiedDel: item.lastModifiedR,
                ));
              }
            }
          }
        }
      });
    }
  }

  Future onDiscoverServicesPressed({required String sendImage}) async {
    //目的UUID
    // BluetoothCharacteristic? targetCharacteristic;
    try {
      // デバイスと接続する
      await widget.deviceInfo.connect();

      if (kDebugMode) {
        print('コネクト成功');
      }
    } catch (e) {
      if (kDebugMode) {
        print('コネクト失敗：$e');
      }
    }
    try {
      // デバイスのサービス情報を読み取る
      services = await widget.deviceInfo.discoverServices();
/*
       //E-Paperの画像を書き込むUUIDを見つける
       for (BluetoothService service in services) {
        for (BluetoothCharacteristic characteristic in service.characteristics) {
          if (characteristic.uuid.toString() == "目的のCharacteristicのUUID") {
            targetCharacteristic = characteristic;
            break;
          }
        }
        if (targetCharacteristic != null) break;
      }
  */
      if (kDebugMode) {
        print('サービス情報を読み取り成功');
        print('$services');
        print(sendImage);
      }
    } catch (e) {
      if (kDebugMode) {
        print('サービス情報を読み取り失敗:$e');
      }
    }
    /*
   //ここでSDKサーバーに画像配信要求(画像ID）を発行する。
   //リクエストに指定する画像IDは「sendImage」で取得できます
   //　以下のWriteは応答後に行う。
    //E-Paperの特定のcharacteristicに書き込む
     try{
       if (targetCharacteristic != null) {
      // ここは応答時に実行するコード（書き込むデータはサーバーから取得した変換後のデータを指定）
         await targetCharacteristic.write('', withoutResponse: false);
       }
     }catch(e){
       print('目的のCharacteristicが見つかりませんでした');
     }
    */
    //デバイスとの接続を切る
    await widget.deviceInfo.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < imageItems.length; i++) {
      if (gridReverse) {
        precacheImage(NetworkImage(reverseData[i].url), context);
      } else {
        precacheImage(NetworkImage(imageItems[i].url), context);
      }
    }

    return Scaffold(
      appBar: ScrollAppBar(
          onTap: () {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                0.0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
          appBar: AppBar(
            title: const Text(
              '配信用登録画像一覧',
              textAlign: TextAlign.center,
            ),
            centerTitle: true,
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(56),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 64,
                  child: Column(children: [
                    Container(
                        margin: const EdgeInsets.fromLTRB(0, 1, 0, 0),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        color: isOn
                            ? const Color(0xff7077A1)
                            : const Color(0xffF6B17A),
                        child: Text(
                          isOn ? '<<< 削除 MODE >>>' : '<<< 配信 MODE >>>',
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Ink(
                            decoration: BoxDecoration(
                                color: isOn
                                    ? const Color(0xffF6B17A)
                                    : const Color(0xff7077A1),
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    spreadRadius: 1.0,
                                    blurRadius: 10.0,
                                    offset: Offset(2, 2),
                                  )
                                ]),
                            width: MediaQuery.of(context).size.width / 2,
                            height: 40,
                            child: InkWell(
                                // highlightColor: const Color(0xffF6B17A),
                                // splashColor: const Color(0xff7077A1),
                                onTap: () {
                                  setState(
                                    () {
                                      isOn = !isOn;
                                      _delImageDataList.clear();
                                      _delImageItems.clear();
                                      _delReverseData.clear();
                                      itemsReset();
                                    },
                                  );
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  child: isOn
                                      ? const Text('配信モードへ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20))
                                      : const Text('削除モードへ',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 211, 219, 223),
                                              fontSize: 20)),
                                ))),

                        Ink(
                          decoration: BoxDecoration(
                              color: const Color(0xff424769),
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  spreadRadius: 1.0,
                                  blurRadius: 10.0,
                                  offset: Offset(2, 2),
                                )
                              ]),
                          width: MediaQuery.of(context).size.width / 2,
                          height: 40,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                if (gridReverse) {
                                  for (var item in _delImageDataList) {
                                    _delReverseData.add(ReversedData(
                                      idR: item.idDel,
                                      url: item.url,
                                      lastModifiedR: item.lastModifiedDel,
                                    ));
                                  }
                                  _delImageItems.clear(); //追加
                                } else {
                                  for (var item in _delImageDataList) {
                                    _delImageItems.add(ImageItem(
                                      id: item.idDel,
                                      url: item.url,
                                      lastModified: item.lastModifiedDel,
                                    ));
                                  }
                                  _delReverseData.clear(); //追加
                                }
                                gridReverse = !gridReverse;
                              });
                            },
                            child: Container(
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(gridReverse ? '登録日:降順へ' : '登録日:昇順へ',
                                        style: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 211, 219, 223),
                                          fontSize: 20,
                                        )),
                                    const Icon(
                                      Icons.swap_vertical_circle_outlined,
                                      color: Color.fromARGB(255, 211, 219, 223),
                                    ),
                                  ],
                                )),
                          ),
                        )

                        // ),
                      ],
                    ),
                  ]),
                )), //高さ

            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),

            // backgroundColor: Colors.black,
          )),
      // body: RefreshIndicator(
      //   onRefresh: onRefresh,
      body: Scrollbar(
        radius: const Radius.circular(8.0),
        child: Stack(children: [
          isOn
              ? //削除機能ON
              CustomPaint(
                  painter: HexagonPainter(),
                  child: isGetImages
                      ? SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: imageItems.isEmpty
                              ? const NonServerPictureMess() //サーバーに画像がない場合のメッセージ表示￥
                              : ServerImageDelGridView(
                                  imageItems:
                                      gridReverse ? imageItems : reverseData,
                                  selectedMedias: gridReverse
                                      ? _delImageItems
                                      : _delReverseData,
                                  selectMedia: gridReverse
                                      ? _selectDelImageItems
                                      : _selectDelReversedData,
                                  scrollController: _scrollController,
                                  gridReverse: gridReverse,
                                  count: count,
                                ))
                      : const Center(child: CircularProgressIndicator()))
              //  削除機能OFF
              : CustomPaint(
                  painter: HexagonPainter(),
                  child: isGetImages
                      ? imageItems.isEmpty
                          ? const NonServerPictureMess()
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 3.0),
                              child: GridView.builder(
                                controller: _scrollController,
                                physics: const BouncingScrollPhysics(
                                    parent: AlwaysScrollableScrollPhysics()),
                                padding: const EdgeInsets.fromLTRB(
                                    0, 0, 0, 150), // 下部のpadding
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4, // 4マスずつ表示
                                  crossAxisSpacing: 1.0, // 縦幅
                                  mainAxisSpacing: 1.0, // 横幅
                                ),
                                itemCount: _items.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final photoIndex = index % imageItems.length;
                                  final photoIndexR =
                                      index % reverseData.length;
                                  return GestureDetector(
                                      onTap: gridReverse
                                          // 古い順に並び替え
                                          ? () {
                                              var value =
                                                  imageItems[photoIndex];
                                              selectImageCheckDialog(
                                                  context: context,
                                                  imageUrl: value.url,
                                                  onSendOK: () {
                                                    // Navigator.pop(context);
                                                    //       Navigator.pop(context);
                                                    onDiscoverServicesPressed(
                                                        sendImage: value.url);
                                                    // ePaperSend(context: context);
                                                  });
                                            }
                                          //   新しい順に並び替え
                                          : () {
                                              var value =
                                                  reverseData[photoIndexR];
                                              selectImageCheckDialog(
                                                  context: context,
                                                  imageUrl: value.url,
                                                  onSendOK: () {
                                                    // Navigator.pop(context);
                                                    //       Navigator.pop(context);
                                                    onDiscoverServicesPressed(
                                                        sendImage: value.url);

                                                    // ePaperSend(context: context);
                                                  });
                                            },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey[300]!,
                                              width: 1),
                                        ),
                                        child: gridReverse
                                            ? Image.network(
                                                imageItems[index].url,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Image.network(
                                                      imageItems[index].url,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                    return Image.network(
                                                      imageItems[index].url,
                                                      errorBuilder: (c, o, s) {
                                                        return const Icon(
                                                          Icons.error,
                                                          color: Colors.red,
                                                        );
                                                      },
                                                    );
                                                  });
                                                },
                                              )
                                            : Image.network(
                                                reverseData[index].url
                                                //   ,
                                                //   errorBuilder: (context, error,
                                                //       stackTrace) {
                                                //     return Image.network(
                                                //         reverseData[index].url,
                                                //         errorBuilder: (context,
                                                //             error, stackTrace) {
                                                //       return Image.network(
                                                //         reverseData[index].url,
                                                //         errorBuilder: (c, o, s) {
                                                //           print('***ERROR***');
                                                //           return const Icon(
                                                //             Icons.error,
                                                //             color: Colors.red,
                                                //           );
                                                //         },
                                                //       );
                                                //     });
                                                //   },
                                                // )
                                                ),
                                      ));
                                },
                              ))
                      // ローディング中の表示
                      : const Center(child: CircularProgressIndicator())),
        ]),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          isOn
              ? _delImageDataList.isNotEmpty
                  ? FloatingActionButton(
                      onPressed: () async {
                        for (var item in _delImageDataList) {
                          if (kDebugMode) {
                            print(
                                'ID: ${item.idDel}, URL: ${item.url}, Last Modified: ${item.lastModifiedDel}');
                          }
                        }
                        await showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => ServerImageDelCheckPopup(
                              selectDelImage: _delImageDataList,
                              fetchData: fetchData),
                        );
                      },
                      backgroundColor: Colors.lightGreenAccent,
                      // Display check icon
                      child: const Icon(Icons.add_task_outlined),
                    )
                  : const SizedBox.shrink()
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}

// class DialogHelper{
void selectImageCheckDialog(
    {required BuildContext context,
    required String imageUrl,
    required Function onSendOK}) {
  showDialog(
    barrierDismissible: false, //dialog以外の部分をタップしても消えないようにする。
    context: context,
    builder: (context) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AlertDialog(
            title: const Text('選択画像を配信しますか？',
                style: TextStyle(
                  fontSize: 20,
                )),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.black12, width: 2)),
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: imageUrl,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                        child: const Text("OK"),
                        onPressed: () {
                          onSendOK();
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }),
                    TextButton(
                        child: const Text("キャンセル"),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
      // ),
    ),
  );
}
// }

class NonServerPictureMess extends StatelessWidget {
  const NonServerPictureMess({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Stack(alignment: Alignment.center, children: [
        Icon(
          Icons.warning_amber_outlined,
          color: Colors.white38,
          size: 300,
        ),
        Text(
          '　　登録画像がありません\n\nまずは画像を登録しましょう！',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ]),
    );
  }
}
