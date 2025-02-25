import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_body_color.dart';
import '../devices_data.dart';
import '../export-for-e-paper/export_page.dart';
// import 'package:google_fonts/google_fonts.dart';

// import '../main.dart';
// import '../top_page/top_page.dart';
// import 'trust-devices_popup.dart';
import 'unregistered_device.dart';

class ConnectBTPage extends StatefulWidget {
  const ConnectBTPage({super.key});

  @override
  State<ConnectBTPage> createState() => _ConnectBTPageState();
}

class _ConnectBTPageState extends State<ConnectBTPage> {
  //信頼済みデバイスデータ格納List
  List<TrustDevice> trustDevices = [];

//スキャンした時のデバイスデータを格納
  List<ScanDevice> scanDevices = [];

//スキャンした時のデバイスデータを格納
  List<ScanResult> scanResult = [];
  // スキャンしたデバイス情報を格納
  List<BluetoothDevice> devicesList = [];

  StreamSubscription<List<ScanResult>>? scanResultsSubscription;

  //信頼済みデバイスアプリ終了しても記憶できるように追加
  //データ書き込み
  saveStringList(List<TrustDevice> value) async {
    //アプリのストレージにアクセスするため。
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //setStringListでSharedPreferencesに文字列のリストを保存
    prefs.setStringList(
      'item',
      value
          .map((device) =>
              '${device.trustName}::${device.trustIpAddress}::${device.devicesData}')
          .toList(),
    );
  }

// String型からBluetoothDeviceに変換。
// remoteIdからデバイス情報を読み取る
  BluetoothDevice _getDeviceFromAddress(String address) {
    return BluetoothDevice(
      remoteId: DeviceIdentifier(address),
    );
  }

//データ読み込み
  _restoreValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      //getStringListでSharedPreferencesに文字列のリストを取得
      trustDevices = (prefs.getStringList('item') ?? []).map((item) {
        final parts = item.split('::');
        // StringからBluetoothDeviceに変換
        //remoteIdを参照させることで読み取る
        BluetoothDevice device = _getDeviceFromAddress(parts[1]);

        return TrustDevice(
          trustName: parts[0],
          trustIpAddress: parts[1],
          devicesData: device,
        );
      }).toList();
    });
  }

  //信頼済みデバイスからデータ削除
  Future<void> _removeCounterValue(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // var deviceToRemove = trustDevices[index];
      trustDevices.removeAt(index); //登録済みデバイスリストから除外する。
      saveStringList(trustDevices); //現時点の登録済みデバイスリストを入れる
      // SharedPreferencesに保存する。
      prefs.setStringList(
          'item',
          trustDevices
              .map((device) =>
                  '${device.trustName}::${device.trustIpAddress}::${device.devicesData}')
              .toList());
    });
  }

  @override
  void initState() {
    super.initState();
    //画面描画時、登録済みデバイスを表示する為
    _restoreValues();
// Bluetooth 初期化と権限チェック
    initBluetooth();
  }

  bool isScanning = false; //スキャン開始、停止

  //下記bluetooth有効の確認を入れないと最初のスキャンで、デバイスをスキャンしない。
  void initBluetooth() async {
    // Bluetooth が有効かチェック
    var isOn =
        await FlutterBluePlus.adapterState.first == BluetoothAdapterState.on;
    if (!isOn) {
      // Bluetooth を有効にするようにユーザーに促す
      await FlutterBluePlus.turnOn();
    }
  }

  void deviceScan() {
    // スキャンを開始する前にリストをクリア
    scanResult.clear();
    devicesList.clear();

    // BLEデバイスをスキャン
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 30));
    // deviceScanResult();
    // スキャンした結果を格納していく
    scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      scanResult = results;
      // スキャンした情報を格納する
      // scanResult = results;
      devicesList = results.map((r) => r.device).toList();
      // スキャン結果を反映
      scanDevices = devicesList
          .map((device) => ScanDevice(
              scanName: device.platformName,
              scanIpAddress: device.remoteId.toString(),
              scanDevicesData: device))
          .toList();
      if (mounted) {
        setState(() {
          // スキャンした情報を格納する
          // scanResult = results;
          devicesList = results.map((r) => r.device).toList();
          // スキャン結果を反映
          scanDevices = devicesList
              .map((device) => ScanDevice(
                  scanName: device.platformName,
                  scanIpAddress: device.remoteId.toString(),
                  scanDevicesData: device))
              .toList();
          isScanning = true;
        });
      }
    });
    //30s経ったら スキャンを停止する
    Future.delayed(const Duration(seconds: 30)).then((_) {
      if (mounted) {
        setState(() {
          isScanning = false;
        });
      }
      FlutterBluePlus.stopScan();
    });
  }

  void _addTrustDevice(ScanDevice device) {
    setState(() {
      trustDevices.add(TrustDevice(
        trustName: device.scanName,
        trustIpAddress: device.scanIpAddress.toString(),
        devicesData: device.scanDevicesData,
      ));
      scanDevices.remove(device);
      saveStringList(trustDevices);
    });
  }

  //スキャンを停止
  void stopScan() {
    FlutterBluePlus.stopScan();
    setState(() {
      isScanning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.popUntil(
                  context, (Route<dynamic> route) => route.isFirst);
            }),
        title: const Text(
          //画面上に表示される
          'BTスキャン＆E-paper配信関連',
            style: TextStyle(
              fontSize: 17,
            ),
          ),
        ),

      body: CustomPaint(
        painter: HexagonPainter(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(50),
              child: ElevatedButton(
                //スキャン開始or停止ボタン
                style: ElevatedButton.styleFrom(
                  backgroundColor: isScanning ? Color(0xFFD81B60):Color(0xFF1565C0),
                  elevation: 10,
                  //境界線の幅を設定。
                  side: const BorderSide(
                    color: Colors.white,
                    width: 2,
                  ),
                  //ボタンの形状設定。角を丸めた長方形。
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    if (isScanning) {
                      stopScan();
                    } else {
                      deviceScan();
                    }
                    // isScanning = !isScanning;
                  });
                },
                child: SizedBox(
                  width: 170,
                  child: Row(children: [
                    isScanning
                        ? const Icon(Icons.stop_circle,color: Colors.white,)
                        : const Icon(Icons.restart_alt,color: Colors.white,),
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
              color: Colors.white30,
              child: const Text('登録済みデバイス',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  )),
            ),
            SizedBox(
              height: 250,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
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
                          Expanded(
                            child: Column(children: [
                              Text(
                                trustDevices[index].trustName.isEmpty
                                    ? 'デバイス名　不明'
                                    : trustDevices[index].trustName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,color: Colors.black),
                              ),
                              Text(
                                trustDevices[index].trustIpAddress,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ]),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  // 選択したデバイス名の情報を配信確認画面に渡す。
                                  builder: (context) => ExportPage(
                                    trustName: trustDevices[index].trustName,
                                    trustIpAddress:
                                        trustDevices[index].trustIpAddress,
                                    trustDevice:
                                        trustDevices[index].devicesData,
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
              color: Colors.white30,
              child: const Text(
                '未登録デバイス',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            UnregisteredDevice(
              scanDevices: scanDevices,
              trustDevices: trustDevices,
              addTrustDevice: _addTrustDevice,
            ),
          ],
        ),
      ),
    );
  }
}
