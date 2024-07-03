import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iphone_bt_epaper/export-for-e-paper/server_delete-image_page.dart';
import 'package:transparent_image/transparent_image.dart';

import '../app_body_color.dart';
import '../export-for-e-paper/server_get-image.dart';
import '../export-for-e-paper/server_image_delete_check_popup.dart';
import '../export-for-e-paper/sever_data_bind.dart';

class PreSendPictureSelect extends StatefulWidget {
  const PreSendPictureSelect({super.key});

  @override
  State<PreSendPictureSelect> createState() => _PreSendPictureSelectState();
}

class _PreSendPictureSelectState extends State<PreSendPictureSelect> {
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

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _delImageItems.addAll(delImageItems);
    _delReverseData.addAll(delReverseData);
    _delImageDataList.addAll(delImageDataList);
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                height: 61,
                child: Column(children: [
                  Container(
                      margin: const EdgeInsets.fromLTRB(0, 1, 0, 0),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      color: isOn ? Colors.yellow : Colors.deepOrange,
                      child: Text(
                        isOn ? '<<< 削除 MODE >>>' : '<<< 配信 MODE >>>',
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                          onTap: () {
                            setState(
                              () {
                                isOn = !isOn;
                                _delImageDataList.clear();
                                _delImageItems.clear();
                                _delReverseData.clear();
                              },
                            );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width / 2,
                            height: 40,
                            decoration: BoxDecoration(
                                color: isOn ? Colors.deepOrange : Colors.yellow,
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    spreadRadius: 1.0,
                                    blurRadius: 10.0,
                                    offset: Offset(2, 2),
                                  )
                                ]),
                            child: Text(isOn ? '配信モードへ' : '削除モードへ',
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 20)),
                          )),
                      InkWell(
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
                          decoration: BoxDecoration(
                              color: Colors.blueAccent,
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(gridReverse ? '登録日:降順へ' : '登録日:昇順へ',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  )),
                              const Icon(
                                Icons.swap_vertical_circle_outlined,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // ),
                    ],
                  ),
                ]),
              )), //高さ

          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),

          backgroundColor: Colors.black,
        ),
        body: isOn
            ? //削除機能ON
            CustomPaint(
                painter: HexagonPainter(),
                child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.white60,
                    child: imageItems.isEmpty
                        ? const NonServerPictureMess() //サーバーに画像がない場合のメッセージ表示￥
                        : ServerImageDelGridView(
                            imageItems: gridReverse ? imageItems : reverseData,
                            selectedMedias:
                                gridReverse ? _delImageItems : _delReverseData,
                            selectMedia: gridReverse
                                ? _selectDelImageItems
                                : _selectDelReversedData,
                            scrollController: _scrollController,
                            gridReverse: gridReverse,
                            delImageDataList: delImageDataList,
                          )))
            //  削除機能OFF
            : CustomPaint(
                painter: HexagonPainter(),
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  // color: Colors.black,
                  child: FutureBuilder(
                    future: getImage(
                        context: context,
                        imageItems: imageItems,
                        reverseData: reverseData,
                        dateSort: dateSort),
                    builder:
                        (BuildContext context, AsyncSnapshot<void> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        // 非同期処理が完了したら画像を表示
                        if (imageItems.isEmpty) {
                          return const NonServerPictureMess();
                        } else {
                          return
                              // gridReverse ?
                              GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, // 3マスずつ表示
                              crossAxisSpacing: 1.0, // 縦幅
                              mainAxisSpacing: 1.0, // 横幅
                            ),
                            itemCount: gridReverse
                                ? imageItems.length
                                : reverseData.length,
                            itemBuilder: (BuildContext context, int index) {
                              final photoIndex = index % imageItems.length;
                              final photoIndexR = index % reverseData.length;
                              return GestureDetector(
                                onTap: gridReverse
                                    // 古い順に並び替え
                                    ? () {
                                        var value = imageItems[photoIndex];
                                        selectImageCheckDialog(
                                            context: context,
                                            imageUrl: value.url,
                                            onSendOK: () {
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            });
                                      }
                                    //   新しい順に並び替え
                                    : () {
                                        var value = reverseData[photoIndexR];
                                        selectImageCheckDialog(
                                            context: context,
                                            imageUrl: value.url,
                                            onSendOK: () {
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            });
                                      },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey[300]!, width: 1),
                                  ),
                                  child: Center(
                                    child: FadeInImage.memoryNetwork(
                                      placeholder: kTransparentImage,
                                      image: gridReverse
                                          ? imageItems[index].url
                                          : reverseData[index].url,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      } else {
                        // 非同期処理中はローディングインジケータを表示
                        return const Center(child: CircularProgressIndicator()
                            // Container(color: Colors.white,width:30,height: 30,)
                            );
                      }
                    },
                  ),
                )),
        floatingActionButton: isOn
            ? _delImageDataList.isNotEmpty
                // delImageItems.isNotEmpty
                ? FloatingActionButton(
                    onPressed: () async {
                      for (var item in _delImageDataList) {
                        print(
                            'ID: ${item.idDel}, URL: ${item.url}, Last Modified: ${item.lastModifiedDel}');
                      }
                      showDialog(
                        context: context,
                        builder: (context) => ServerImageDelCheckPopup(
                            selectDelImage: _delImageDataList),
                      );
                    },
                    backgroundColor: Colors.lightGreenAccent,
                    // Display check icon
                    child: const Icon(Icons.add_task_outlined),
                  )
                : null
            : null);
  }
}

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
            title: const Text('選択画像を転送しますか？',
                style: TextStyle(
                  fontSize: 20,
                )),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12, width: 2)),
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: imageUrl,
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              // ボタン領域
              TextButton(
                  child: const Text("キャンセル"),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    onSendOK();
                    // Navigator.pop(context);
                  }),
            ],
          ),
        ],
      ),
    ),
  );
}

Future<void> ePaperSend({
  required BuildContext context,
}) async {
  Timer? _timer;
  _timer = Timer(const Duration(seconds: 3), () {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  });
  await showDialog(
    // barrierDismissible:false,//dialog以外の部分をタップしても消えないようにする。
    context: context,
    builder: (context) => const Center(
      child: AlertDialog(
        title: Text('E-paperに配信中',
            style: TextStyle(
              fontSize: 20,
            )),
        content: SizedBox(
            width: 30,
            height: 30,
            child: Center(
              child: CircularProgressIndicator(),
            )),
      ),
    ),
  );
}

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
