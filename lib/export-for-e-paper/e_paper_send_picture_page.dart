import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:iphone_bt_epaper/export-for-e-paper/server_get-image.dart';
import 'package:iphone_bt_epaper/export-for-e-paper/server_image_delete_check_popup.dart';
import 'package:iphone_bt_epaper/export-for-e-paper/sever_data_bind.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'bluetooth_connection_state.dart';

import '../theme.dart';

class SendPictureSelect extends StatefulWidget {
  final BluetoothDevice deviceInfo;
  final String trustName;
  final CacheManager? cacheManager;
  const SendPictureSelect(
      {super.key,
      required this.deviceInfo,
      required this.trustName,
      this.cacheManager});

  @override
  State<StatefulWidget> createState() => _SendPictureSelect();
}

class _SendPictureSelect extends State<SendPictureSelect> {
  List<ImageItem> imageItems = []; // サーバーデータ
  List<ImageItem> _items = []; // 表示使用用画像リスト
  List<ImageItem> _deleteItems = []; // 削除用選択リスト
  List<BluetoothService> services = []; //接続したデバイスのサービス情報を読み取る
  final List<bool> selectedMode = [true, false]; // 画像操作Button用リスト
  String? sortItemLis = 'new'; // 画像順表示名　初期：新しい順
  int selectedModeIndex = 1;
  bool deleteMode = false; // 画面操作状態、削除状態切り替え
  bool selectedItem = false; // 画像選択状態
  bool isLoading = true; // 画像読込状態
  bool isConnected = false; // BLE処理状態
  double? progressPercent = 0.0;  // LinearProgressIndicator(value)
  bool isSending = false; // LinearProgressIndicator()表示状態
  String? resultTitle;  // sdk異常終了時エラーメッセージタイトル
  String? resultContext;  // sdk異常終了時エラーメッセージ内容
  String connectionState = "disconnect";  // BL接続状態
  // メッセージに基づく処理をマッピングするための Map
  late final Map<String, Future<void> Function(Map<String, dynamic>)> _messageHandlers;

  List<ReversedData> reverseData = []; //サーバーデータ：新しい順 // 未使用
  List<DateSort> dateSort = []; //日付並び替え  // 未使用

  static const platform = MethodChannel('com.example.iphone_bt_epaper/channel');

  // SDKcallback_message
  static const BasicMessageChannel<String> _channel =
      BasicMessageChannel<String>(
          'com.example.iphone_bt_epaper/channel', StringCodec());

  @override
  void initState() {
    super.initState();
    initialize();

    // メッセージに基づいて処理をマッピング
    _messageHandlers = {
        "onSetupSDKFailed": _handleSetupSDKFailed,
        "onBLEDeviceConnectComplete": _handleBLEDeviceConnectComplete,
        "onBLEDeviceConnectFailed": _handleBLEDeviceConnectFailed,
        "onBLEDeviceDisconnect": _handleBLEDeviceDisconnect,
        "onBLEDeviceCancelFailed": _handleBLEDeviceCancelFailed,
        "onSendImageToDeviceComplete": _handleSendImageToDeviceComplete,
        "onSendImageToDeviceFailed": _handleSendImageToDeviceFailed,
        "onSendImageToDeviceProgress": _handleSendImageToDeviceProgress,
        "onBLEDeviceConnectCanceled": _handleBLEDeviceConnectCanceled,
    };

    // メッセージを受信するリスナーを設定
    _channel.setMessageHandler((String? message) async {
      debugPrint("receiveMessage: $message");
      await handleReceivedMessage(message);
      return "";
    });
  }

  // メッセージ受信後の処理
  Future<void> handleReceivedMessage(String? message) async {
    if (message != null) {

        // 受信した JSON を `Map<String, dynamic>` に変換
        final Map<String, dynamic> decodedData = jsonDecode(message);
        // メッセージのcallbackNameを取得
        final String? callbackName = decodedData["callbackName"];

        if (callbackName != null) {
          // マッピングされた処理を実行
          final handler = _messageHandlers[callbackName];
          if (handler != null) {
            await handler(decodedData);
          } else {
            debugPrint("Unknown message callbackName: $callbackName");
          }
        } else {
          debugPrint("Error: No 'callbackName' field in message");
        }
    }
  }

  // 各メッセージ受信後処理関数
  Future<void> _handleSetupSDKFailed(Map<String, dynamic> data) async {
    setState(() {
      isConnected = false;
    });
    callSdkMessage(data);
  }
  Future<void> _handleBLEDeviceConnectComplete(Map<String, dynamic> data) async {
    connectionState = "connected";
  }
  Future<void> _handleBLEDeviceConnectFailed(Map<String, dynamic> data) async {
    setState(() {
      isConnected = false;
    });
    callSdkMessage(data);
  }
  Future<void> _handleBLEDeviceDisconnect(Map<String, dynamic> data) async {
    connectionState = "disconnect";
    setState(() {
      isConnected = false;
    });
  }
  Future<void> _handleBLEDeviceCancelFailed(Map<String, dynamic> data) async {
    callSdkMessage(data);
  }
  Future<void> _handleSendImageToDeviceComplete(Map<String, dynamic> data) async {
    progressPercent = 0.0;
    setState(() {
      isSending = false;
    });
  }
  Future<void> _handleSendImageToDeviceFailed(Map<String, dynamic> data) async {
    progressPercent = 0.0;
    setState(() {
      isSending = false;
    });
    callSdkMessage(data);
  }
  Future<void> _handleSendImageToDeviceProgress(Map<String, dynamic> data) async {
    setState(() {
      isSending = true;
      progressPercent = (data['progressPercent'] ?? 0) / 100;
      debugPrint(
          "LinearProgressIndicator progressPercent: $progressPercent");
    });
  }
  Future<void> _handleBLEDeviceConnectCanceled(Map<String, dynamic> data) async {
    connectionState = "disconnect";
    setState(() {
      isConnected = false;
    });
    callSdkMessage(data);
  }
  Future<void> _handleSendImageToDeviceCanceled(Map<String, dynamic> data) async {
    progressPercent = 0.0;
    setState(() {
      isSending = false;
    });
    callSdkMessage(data);
  }

  Future<void> initialize() async {
    // 画像取得
    await getImage(
      context: context,
      imageItems: imageItems,
      reverseData: reverseData, // 未使用
      dateSort: dateSort, // 未使用
    );
    setState(() {
      // 画像順ソート new->old
      imageItems.sort((a, b) => b.lastModified.compareTo(a.lastModified));
      isLoading = false;
      _items = imageItems;
    });
  }

  //サーバー接続
  Future onDiscoverServicesPressed({required String sendImage}) async {
    debugPrint('登録処理');
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

  // BL接続
  void callNativeMethod(url) {
    debugPrint("send image url: ${url}");
    try {
      debugPrint("call Kotlin");
      platform.invokeMethod('callSdk',
          {'deviceName': '${widget.trustName}', 'imageUrl': '${url}'});
    } on PlatformException catch (e) {
      debugPrint("Failed to call native method: '${e.message}'.");
    }
  }

  // 削除時に画像一覧を更新する関数
  Future<void> fetchData(status) async {
    if (mounted) {
      setState(() {
        // 削除成功時、サーバーから再取得しないで初期取得Listから削除->再描画
        // 削除失敗時、削除リストのみ初期化(✓マークリセットの再描画)
        // キャッシュをクリアして画像を削除
        if (status == 200) {
          for (int i = 0; i < _deleteItems.length; i++) {
            _items.removeWhere((v) => v.id == _deleteItems[i].id);

            // 画像キャッシュ削除
            DefaultCacheManager().removeFile(_items[i].url);
            CachedNetworkImage.evictFromCache(_items[i].url);
          }
        }
        _deleteItems.clear();
        _items = List.from(imageItems); //更
      });
      _deleteItems.clear();
      // imageCache.clear();
      // imageCache.clearLiveImages();
      // initialize();  // initialize() を呼び出して、再度画像リストを取得
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('配信用登録画像一覧'),
            actions: [
              Container(
                child: BluetoothConnection(connectionState),  // BL接続状況表示
              )
            ],
          ),
          body: Column(
            children: [
              // AppBar下の固定バー
              Container(
                height: AppBar().preferredSize.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ToggleButtons(
                      color: Colors.blue,
                      fillColor: Colors.blue[300],
                      borderColor: Colors.blue[100],
                      splashColor: Colors.blue[300],
                      selectedBorderColor: Colors.blue[800],
                      selectedColor: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      constraints: BoxConstraints(
                          minHeight: AppBar().preferredSize.height * 0.65,
                          minWidth: MediaQuery.of(context).size.width / 5),
                      isSelected: selectedMode,
                      onPressed: (int index) {
                        setState(() {
                          if (index == 0) {
                            selectedMode[0] = true;
                            selectedMode[1] = false;
                            deleteMode = false;
                          } else {
                            selectedMode[0] = false;
                            selectedMode[1] = true;
                            deleteMode = true;
                          }
                          if (!deleteMode) {
                            _deleteItems.clear();
                          }
                        });
                      },
                      children: const [
                        Row(
                          children: [Icon(Icons.ios_share), Text('  配信')],
                        ),
                        Row(
                          children: [Icon(Icons.delete), Text('  削除')],
                        )
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          '表示順：',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                        DropdownButton(
                          // 画像ソート順選択
                          items: const [
                            DropdownMenuItem(
                              value: 'new',
                              child: Text(
                                '新しい順',
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'old',
                              child: Text(
                                '古い順',
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                            )
                          ],
                          onChanged: (String? value) {
                            setState(() {
                              if (sortItemLis != value) {
                                sortItemLis = value; // 画像順ソートドロップダウンtitle
                                _items = _items.reversed.toList();
                                _deleteItems.clear();
                              }
                            });
                          },
                          value: sortItemLis,
                          underline: Container(
                            height: 1,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Center(
                      child: isLoading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.black),
                              backgroundColor: Colors.white70,
                            ) // ローディング中はインジケーターを表示
                          : Container(
                              child: _items.isEmpty
                                  ? NonServerPictureMess()
                                  : _createGridView())))
            ],
          ),
          persistentFooterButtons: deleteMode
              ? (_deleteItems.isNotEmpty)
                  ? [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _deleteItems = List.from(_items); // すべて選択
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(90, 50), //幅,高
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF29B6F6)),
                        child: const Text('全選択'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _deleteItems.clear(); // すべて解除
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(125, 50),
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF29B6F6)),
                        child: const Text('全選択解除'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          for (var item in _deleteItems) {
                            if (kDebugMode) {
                              print(
                                  'ID: ${item.id}, URL: ${item.url}, Last Modified: ${item.lastModified}');
                            }
                          }
                          await showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => ServerImageDelCheckPopup(
                                selectDelImage: _deleteItems,
                                fetchData: fetchData),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(50, 50),
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF29B6F6)),
                        child: const Text('削除'),
                      ),
                    ]
                  : null
              : null,
        ),
        if (isConnected)
          const Positioned.fill(
              child: ModalBarrier(
            color: Colors.black54,
            dismissible: false, // ユーザー操作をブロック
          )),
        if (isConnected && !isSending)
          const Center(child: CircularProgressIndicator()),
        if (isConnected && isSending)
          Container(
              alignment: Alignment.bottomCenter,
              child: LinearProgressIndicator(
                minHeight: 10.0, // ラインの高さ
                value: progressPercent,
              ))
      ],
    );
  }

  // 画像表示View
  Widget _createGridView() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 3.0, // 縦の空間
        mainAxisSpacing: 4.0, // 横の空間
        crossAxisCount: 3,
      ),
      itemCount: _items.length,
      itemBuilder: (BuildContext context, int index) {
        bool isSelected = false;
        return _createImageTap(index, isSelected);
      },
    );
  }

  // 画像onTap操作
  Widget _createImageTap(index, isSelected) {
    return GestureDetector(
      onTap: deleteMode
          ? () {
              // 画像削除時複数選択処理
              // 画像選択/解除判定　削除リストに追加されているか確認
              isSelected = _deleteItems.any((v) => v.id == _items[index].id);
              // 選択✓マーク表示のためsetState()
              setState(() {
                if (isSelected) {
                  // 選択解除処理
                  // 削除リストから削除
                  _deleteItems.removeWhere((v) => v.id == _items[index].id);
                } else {
                  // 選択処理
                  // 削除リストに追加
                  _deleteItems.add(_items[index]);
                }
              });
            }
          : () {
              // 画像登録処理
              selectImageCheckDialog(
                  context: context,
                  imageUrl: _items[index].url,
                  onSendOK: () {
                    callNativeMethod(_items[index].url);
                  });
            },
      child: _createCheckMark(index, isSelected),
    );
  }

  // 画像表示
  Widget _createCheckMark(index, isSelected) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26, width: 1), // 青色の枠線
      ),
      child: Stack(children: <Widget>[
        CachedNetworkImage(
          key: ValueKey(_items[index].url), //キャッシュを更新するためのキー
          imageUrl: _items[index].url,
          cacheManager: DefaultCacheManager(), //キャッシュマネージャーを統一
          width: 200,
          height: 200,
          errorWidget: (context, url, error) =>
              const Icon(Icons.error), // 画像エラー時のウィジェット
          fit: BoxFit.contain,
        ),
        // ✓マーク表示
        if (isSelected = _deleteItems.any((v) => v.id == _items[index].id))
          Stack(
            children: <Widget>[
              Positioned.fill(
                child: Container(
                  color: const Color(0xFF4FC3F7),
                ),
              ),
              Positioned.fill(
                  child: Padding(
                padding: EdgeInsets.all(isSelected ? 10.0 : 0.0),
                child: CachedNetworkImage(
                  imageUrl: _items[index].url,
                ),
              )),
              Positioned.fill(
                  child: Container(
                      color: Colors.black.withOpacity(0.3),
                      child: const Icon(Icons.check_circle,
                          size: 30, color: Colors.white //.withOpacity(0.8),
                          )))
            ],
          )
      ]),
    );
  }

// class DialogHelper{
  void selectImageCheckDialog(
      {required BuildContext context,
      required String imageUrl,
      required Function onSendOK}) {
    showDialog(
      barrierDismissible: false, //dialog以外の部分をタップしても消えないようにする。
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Align(
            alignment: Alignment.center, // タイトルを中央に寄せる
            child: Text(
              '選択画像を配信しますか？',
              style: AppTheme.dialogContentStyle, // 本文のスタイル
            ),
          ),
          // content: Column(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 250,
                height: 200,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12, width: 2)),
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: imageUrl,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center, // 中央寄せ
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: 100, // ボタンの横幅を統一
                        child: ElevatedButton(
                          style: AppTheme.dialogYesButtonStyle,
                          onPressed: () {
                            onSendOK();
                            setState(() {
                              isConnected = true;
                            });
                            Navigator.pop(context);
                          },
                          child: const Text("はい",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                        child: SizedBox(
                      width: 100,
                      child: ElevatedButton(
                          style: AppTheme.dialogNoButtonStyle,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("いいえ")),
                    ))
                  ]),
            ],
          ),
        );
      },
    );
  }

  void callSdkMessage(Map<String, dynamic> data) {
    resultTitle = data['callbackName'];
    resultContext = data['message'];
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              titleTextStyle: AppTheme.errordialogTitleStyle,
              // エラーダイアログのタイトルスタイル
              contentTextStyle: AppTheme.errorContentStyle,
              // エラーダイアログの本文スタイル
              actionsAlignment: MainAxisAlignment.center,
              title: Text(
                resultTitle ?? "",
                textAlign: TextAlign.center,
              ),
              content: Text(
                resultContext ?? "",
                textAlign: TextAlign.center,
              ),
              actions: <Widget>[
                ElevatedButton(
                  style: AppTheme.errordialogButtonStyle, // エラーダイアログボタンスタイル
                  // TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ]);
        });
  }
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
