import 'package:flutter/material.dart';
import 'package:iphone_bt_epaper/bt_connect_for_emulator/pre_devices_data.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../app_body_color.dart';
import 'pre_export_page.dart';

class PreConnectBTPage extends StatefulWidget {
  const PreConnectBTPage({super.key});

  @override
  State<PreConnectBTPage> createState() => _ConnectBTPageState();
}

class _ConnectBTPageState extends State<PreConnectBTPage> {
  //信頼済みデバイスデータ格納List
  List<PreTrustDevice> trustDevices = [];

//スキャンした時のデバイスデータを格納
  List<PreScanDevice> scanDevices = [];

  //信頼済みデバイスアプリ終了しても記憶できるように追加
  //データ書き込み
  _saveStringList(List<PreTrustDevice> value) async {
    //アプリのストレージにアクセスするため。
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //setStringListでSharedPreferencesに文字列のリストを保存
    prefs.setStringList(
      'item',
      value
          .map((device) => '${device.trustName}:${device.trustIpAddress}')
          .toList(),
    );
  }

//データ読み込み
  _restoreValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      //getStringListでSharedPreferencesに文字列のリストを取得
      trustDevices = (prefs.getStringList('item') ?? []).map((item) {
        final parts = item.split(':');
        return PreTrustDevice(
          trustName: parts[0],
          trustIpAddress: parts[1],
        );
      }).toList();
    });
  }

  //信頼済みデバイスからデータ削除
  void _removeCounterValue(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // var deviceToRemove = trustDevices[index];
      trustDevices.removeAt(index); //登録済みデバイスリストから除外する。
      _saveStringList(trustDevices); //現時点の登録済みデバイスリストを入れる
      // SharedPreferencesに保存する。
      prefs.setStringList(
          'item',
          trustDevices
              .map((device) => '${device.trustName}:${device.trustIpAddress}')
              .toList());
    });
  }

  @override
  void initState() {
    //画面描画時、登録済みデバイスを表示する為
    _restoreValues();
    super.initState();
  }

  bool isScanning = false; //スキャン開始、停止

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Navigator.pushAndRemoveUntil(
              //   context,
              //   //サーバーupload画面から遷移した時、upload画面に戻らずtop画面に遷移するようにする。
              //   MaterialPageRoute(builder: (BuildContext context) => MyApp()),
              //   //top画面に遷移した後、戻る←マークが出ないようにする。
              //       (Route<dynamic> route) => false,
              // );
              Navigator.popUntil(
                  context, (Route<dynamic> route) => route.isFirst);
            }),
        title: const Text(
          'E ink E-paper',
        ),
      ),
      body: CustomPaint(
        painter: HexagonPainter(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(50),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isScanning ? Colors.redAccent : Colors.grey,
                  elevation: 10,
                  //境界線の幅を設定。
                  side: const BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                  //ボタンの形状設定。角を丸めた長方形。
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    isScanning = !isScanning;
                    //スキャン開始をしてデバイス情報をデータバインド
                    if (isScanning == true) {
                      // DetectDeviceクラスに仮デバイス情報としてあるdevicesから
                      //ScanDeviceクラスに情報を入れる動作。
                      scanDevices = devices
                          .map((device) => PreScanDevice(
                              scanName: device.detectName,
                              scanIpAddress: device.detectIpAddress))
                          .toList();
                    }
                  });
                },
                child: SizedBox(
                  width: 170,
                  child: Row(children: [
                    isScanning
                        ? Container(
                            color: Colors.blueGrey,
                            width: 10,
                            height: 10,
                          )
                        : const Icon(Icons.restart_alt),
                    const SizedBox(width: 10),
                    Text(isScanning ? 'スキャン停止' : 'スキャン開始',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ))
                  ]),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              color: Colors.white38,
              child: const Text('登録済みデバイス',
                  style: TextStyle(
                    fontSize: 20,
                  )),
            ),
            SizedBox(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.vertical, // 縦方向のスクロール
                itemCount: trustDevices.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 50,
                    margin: const EdgeInsets.all(5),
                    alignment: Alignment.center,
                    // width: double.infinity,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle, //長方形
                      border: Border.all(
                        color: Colors.black12,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(0, 5),
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            width: 50,
                          ),
                          Column(children: [
                            Text(
                              trustDevices[index].trustName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              trustDevices[index].trustIpAddress,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                          ]),
                          IconButton(
                            onPressed: () {
                              // _removeCounterValue(index);
                              // _saveStringList(trustDevices);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  // 選択したデバイス名の情報を配信確認画面に渡す。
                                  builder: (context) => PreExportPage(
                                    trustName: trustDevices[index].trustName,
                                    trustIpAddress:
                                        trustDevices[index].trustIpAddress,
                                    onDelete: () => _removeCounterValue(index),
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.info_outline_rounded),
                          ),
                        ]),
                    // ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              color: Colors.white38,
              child: const Text(
                '未登録デバイス',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            // Swap the order of sections
            // isScanning ?
            scanDevices.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: scanDevices.length,
                      itemBuilder: (context, index) {
                        //登録済みデバイスとスキャンしたデバイスの名前とremoteIdが一致したら表示しない。
                        if (trustDevices.any((device) =>
                            device.trustName == scanDevices[index].scanName &&
                            device.trustIpAddress ==
                                scanDevices[index].scanIpAddress)) {
                          return Container();
                        } else {
                          return GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => TrustDevices_popup(
                                    scanName: scanDevices[index].scanName,
                                    onOk: () {
                                      setState(() {
                                        //OKを押したら、scanデバイスのデータを登録する。
                                        trustDevices.add(PreTrustDevice(
                                            trustName:
                                                scanDevices[index].scanName,
                                            trustIpAddress: scanDevices[index]
                                                .scanIpAddress));
                                        scanDevices.removeAt(index);
                                        _saveStringList(trustDevices);
                                      });
                                    }),
                              );
                            },
                            child: Container(
                                height: 50,
                                // color: Colors.blue,
                                margin: const EdgeInsets.all(5),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white60,
                                  shape: BoxShape.rectangle,
                                  border: Border.all(
                                    color: Colors.black12,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: const [
                                    BoxShadow(
                                      offset: Offset(0, 5),
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                                child: Column(children: [
                                  Text(
                                    scanDevices[index].scanName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    scanDevices[index].scanIpAddress,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                ])),
                          );
                        }
                      },
                    ),
                  )
                : Container(
                    color: Colors.black45,
                    alignment: Alignment.topCenter,
                    width: MediaQuery.of(context).size.width,
                    height: 25,
                    child: const Text(
                      'スキャンを開始して、未登録デバイスを表示してください',
                      style: TextStyle(color: Colors.red, fontSize: 15),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class TrustDevices_popup extends StatefulWidget {
  final Function onOk;
  final String scanName;

  const TrustDevices_popup(
      {super.key, required this.onOk, required this.scanName});

  @override
  State<TrustDevices_popup> createState() => _TrustDevices_popupState();
}

class _TrustDevices_popupState extends State<TrustDevices_popup> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('"${widget.scanName}"を登録しますか'),
      actions: <Widget>[
        const Divider(),
        Container(
          width: 300,
          alignment: Alignment.center,
          child: Row(children: [
            TextButton(
              onPressed: () {
                widget.onOk();
                Navigator.pop(context, 'OK');
              },
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('キャンセル'),
            ),
          ]),
        ),
      ],
    );
  }
}
