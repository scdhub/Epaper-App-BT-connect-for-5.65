import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_body_color.dart';
import '../devices_data.dart';
import '../export-for-e-paper/export_page.dart';
import 'package:google_fonts/google_fonts.dart';

import '../main.dart';
import '../top_page/top_page.dart';
import 'trust-devices_popup.dart';

class ConnectBTPage extends StatefulWidget {
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
          .map((device) => '${device.trustName}::${device.trustIpAddress}::${device.devicesData}')
          .toList(),
    );
  }
// String型からBluetoothDeviceに変換。
// remoteIdからデバイス情報を読み取る
  BluetoothDevice _getDeviceFromAddress(String address) {
    return BluetoothDevice(remoteId: DeviceIdentifier(address),);
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
      trustDevices.removeAt(index);//登録済みデバイスリストから除外する。
      saveStringList(trustDevices);//現時点の登録済みデバイスリストを入れる
      // SharedPreferencesに保存する。
     prefs.setStringList(
          'item',
          trustDevices
              .map((device) => '${device.trustName}::${device.trustIpAddress}::${device.devicesData}')
              .toList());
    });
  }

  @override
  void initState() {
    //画面描画時、登録済みデバイスを表示する為
    _restoreValues();
// Bluetooth 初期化と権限チェック
    initBluetooth();
    // // スキャンした結果を格納していく
    // FlutterBluePlus.scanResults.listen((results) {
    //   // scanResult = results;
    //   if (mounted) {
    //     setState(() {
    //       // スキャンした情報を格納する
    //       scanResult = results;
    //       devicesList = results.map((r) => r.device).toList();
    //       // スキャン結果を反映
    //       scanDevices = devicesList.map((device) =>
    //           ScanDevice(scanName: device.platformName,
    //               scanIpAddress: device.remoteId.toString(),
    //               scanDevicesData: device)
    //       ).toList();
    //     });
    //   }
    // });
    // deviceScanResult();
    super.initState();
  }

  bool isScanning = false; //スキャン開始、停止

  //下記bluetooth有効の確認を入れないと最初のスキャンで、デバイスをスキャンしない。
  void initBluetooth() async {

    // Bluetooth が有効かチェック
    var isOn = await FlutterBluePlus.adapterState.first == BluetoothAdapterState.on;
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
    FlutterBluePlus.startScan(timeout: Duration(seconds: 30));
    // deviceScanResult();
    // スキャンした結果を格納していく
    scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      scanResult = results;
      // スキャンした情報を格納する
      // scanResult = results;
      devicesList = results.map((r) => r.device).toList();
      // スキャン結果を反映
      scanDevices = devicesList.map((device) =>
          ScanDevice(scanName: device.platformName,
              scanIpAddress: device.remoteId.toString(),
              scanDevicesData: device)
      ).toList();
      if (mounted) {
        setState(() {
          // スキャンした情報を格納する
          // scanResult = results;
          devicesList = results.map((r) => r.device).toList();
          // スキャン結果を反映
          scanDevices = devicesList.map((device) =>
              ScanDevice(scanName: device.platformName,
                  scanIpAddress: device.remoteId.toString(),
                  scanDevicesData: device)
          ).toList();
          isScanning = true;
        });
      }
    });
  }
  // void deviceScanResult() {
  //   // スキャンした結果を格納していく
  //   FlutterBluePlus.scanResults.listen((results) {
  //     scanResult = results;
  //     if (mounted) {
  //       setState(() {
  //         // スキャンした情報を格納する
  //         // scanResult = results;
  //         devicesList = results.map((r) => r.device).toList();
  //         // スキャン結果を反映
  //         scanDevices = devicesList.map((device) =>
  //             ScanDevice(scanName: device.platformName,
  //                 scanIpAddress: device.remoteId.toString(),
  //                 scanDevicesData: device)
  //         ).toList();
  //       });
  //     }
  //   });
  // }

  void _addTrustDevice(ScanDevice device) {
    setState(() {
      trustDevices.add(TrustDevice(
        trustName: device.scanName,
        trustIpAddress: device.scanIpAddress.toString(),
        devicesData: device.scanDevicesData,
      ));
      scanDevices.remove(device);
      saveStringList(trustDevices);
      // //OKを押したら、scanデバイスのデータを登録する。
      // widget.trustDevices.add(TrustDevice(
      //     trustName: widget.scanDevices[index].scanName,
      //     trustIpAddress:
      //     widget.scanDevices[index].scanIpAddress.toString(),
      //     devicesData: widget.scanDevices[index].scanDevicesData
      // ));
      // widget.scanDevices.removeAt(index);
      // widget.saveStringList();
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
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Navigator.pushAndRemoveUntil(
              //   context,
              //   //サーバーupload画面から遷移した時、upload画面に戻らずtop画面に遷移するようにする。
              //   MaterialPageRoute(builder: (BuildContext context) => MyApp()),
              //   //top画面に遷移した後、戻る←マークが出ないようにする。
              //   (Route<dynamic> route) => false,
              // );
              Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);

            }),
        title: Text(
          'E ink E-paper',
        ),
      ),
      body: CustomPaint(
        painter: HexagonPainter(),
    child:Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE1E9FF), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(50),
              child: ElevatedButton(
                child: Container(
                  width: 170,
                  child: Row(children: [
                    isScanning
                        ? Container(
                            color: Colors.blueGrey,
                            width: 10,
                            height: 10,
                          )
                        : Icon(Icons.restart_alt),
                    SizedBox(width: 10),
                    Text(isScanning ? 'スキャン停止' : 'スキャン開始',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ))
                  ]),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isScanning ? Colors.redAccent : Colors.grey,
                  elevation: 10,
                  //境界線の幅を設定。
                  side: BorderSide(
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
                    if(isScanning){
                      stopScan();
                    }else{
                      deviceScan();
                    }
                    // isScanning = !isScanning;
                  });

                },
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              color: Colors.white38,
              child:
              Text('登録済みデバイス',
                  style: TextStyle(
                    fontSize: 20,
                  )),
            ),
            Container(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.vertical,// 縦方向のスクロール
                itemCount: trustDevices.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 50,
                    margin: EdgeInsets.all(5),
                    alignment: Alignment.center,
                    // width: double.infinity,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,//長方形
                      border: Border.all(
                        color: Colors.black12,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 5),
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 50,
                          ),
                          Column(children: [
                            Text(
                              trustDevices[index].trustName,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              trustDevices[index].trustIpAddress,
                              style: TextStyle(
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
                                  builder: (context) => ExportPage(
                                    trustName: trustDevices[index].trustName,
                                    trustIpAddress:
                                        trustDevices[index].trustIpAddress,
                                    trustDevice: trustDevices[index].devicesData,
                                    onDelete: () => _removeCounterValue(index),
                                  ),
                                ),
                              );
                            },
                            icon: Icon(Icons.info_outline_rounded),
                          ),
                        ]),
                    // ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              color: Colors.white38,
              child:
              Text('未登録デバイス',
                style: TextStyle(
                  fontSize: 20,
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
      ),
    );
  }
}




class UnregisteredDevice extends StatefulWidget {

  final List<ScanDevice> scanDevices;
  final List<TrustDevice> trustDevices;
  // final Function saveStringList;
  final Function(ScanDevice) addTrustDevice;

  const UnregisteredDevice({required this.trustDevices,required this.scanDevices, required this.addTrustDevice, /*required this.saveStringList*/});

  @override
  _UnregisteredDeviceState createState() => _UnregisteredDeviceState();
}

class _UnregisteredDeviceState extends State<UnregisteredDevice> {
  @override
  Widget build(BuildContext context) {
    return  widget.scanDevices.isNotEmpty
        ? Expanded(
      child:ListView.builder(
        itemCount: widget.scanDevices.length,
        // itemCount: devicesList.length,
        itemBuilder: (context, index) {
          //登録済みデバイスとスキャンしたデバイスの名前とremoteIdが一致したら表示しない。
          if (widget.trustDevices.any((device) =>
          device.trustName == widget.scanDevices[index].scanName &&
              device.trustIpAddress ==
                  widget.scanDevices[index].scanIpAddress)) {
            // if (trustDevices.any((device) =>
            // device.trustName == devicesList[index].platformName &&
            // device.trustIpAddress ==
            //     devicesList[index].remoteId.toString())) {
            return Container();
          } else {
            return GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) =>
                      TrustDevices_popup(
                          scanName: widget.scanDevices[index].scanName,
                          onOk: () {
                            setState(() {
                              // //OKを押したら、scanデバイスのデータを登録する。
                              // widget.trustDevices.add(TrustDevice(
                              //     trustName: widget.scanDevices[index].scanName,
                              //     trustIpAddress:
                              //     widget.scanDevices[index].scanIpAddress.toString(),
                              //     devicesData: widget.scanDevices[index].scanDevicesData
                              // ));
                              // widget.scanDevices.removeAt(index);
                              // widget.saveStringList();
                              widget.addTrustDevice(widget.scanDevices[index]);
                              // Navigator.pop(context, 'OK');
                            });
                          }),
                );
              },
              child: Container(
                  height: 50,
                  // color: Colors.blue,
                  margin: EdgeInsets.all(5),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white60,
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Colors.black12,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 5),
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  child: Column(children: [
                    Text(
                      widget.scanDevices[index].scanName,
                      // devicesList[index].platformName,
                      style:
                      TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.scanDevices[index].scanIpAddress.toString(),
                      // devicesList[index].remoteId.toString(),
                      style: TextStyle(
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
    child:Text(
    'スキャンを開始して、未登録デバイスを表示してください',
    style: TextStyle(color: Colors.red,fontSize: 15),
    ),

    );
  }
}