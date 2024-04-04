import 'package:flutter/material.dart';
// import 'package:flutter_blue/flutter_blue.dart';

class BluetoothScanner extends StatefulWidget {
  @override
  _BluetoothScannerState createState() => _BluetoothScannerState();
}

class _BluetoothScannerState extends State<BluetoothScanner> {
  // final FlutterBlue flutterBlue = FlutterBlue.instance;
  // List<BluetoothDevice> devices = [];

  // @override
  // void initState() {
  //   super.initState();
  //   _startScanning();
  // }

  // void _startScanning() {
  //   flutterBlue.scanResults.listen((results) {
  //     for (ScanResult result in results) {
  //       if (!devices.contains(result.device)) {
  //         setState(() {
  //           devices.add(result.device);
  //         });
  //       }
  //     }
  //   });
  //   flutterBlue.startScan();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Devices'),
      ),
      body: ListView.builder(
        // itemCount: devices.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('devices[index].name'),
            onTap: () {
            },
          );
        },
      ),
    );
  }
}


class DeviceInfo {
  String vernum;

  String UIDnum;
  String resolution;
  String colorsaport;
  String maker;
  String colorparm;

  DeviceInfo({
    this.vernum = '2.5.1',
    this.UIDnum = '005EF97E',
    this.resolution = '160×160(垂直走査)',
    this.colorsaport = 'ブラックホワイトレッド',
    this.maker = 'その他(F0)',
    this.colorparm = '黒(0)白(2)赤(1)',
  });
}

  // // タグ情報の状態管理
  // void updateDeviceInfo(String newVersion, String newUID, String newResolution,
  //     String newColorsaport, String newMaker, String newColorparm) {
  //   setState(() {
  //     deviceInfo.vernum = newVersion;
  //     deviceInfo.UIDnum = newUID;
  //     deviceInfo.resolution = newResolution;
  //     deviceInfo.colorsaport = newColorsaport;
  //     deviceInfo.maker = newMaker;
  //     deviceInfo.colorparm = newColorparm;
  //   });
  // }