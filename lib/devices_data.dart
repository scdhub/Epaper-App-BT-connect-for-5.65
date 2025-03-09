import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class TrustDevice {
  final String trustName;// 未登録デバイス一覧
  final String trustIpAddress;// 登録済みデバイス一覧
  final BluetoothDevice devicesData;// 未登録デバイスを登録する関数

  TrustDevice(
      {required this.trustName,
      required this.trustIpAddress,
      required this.devicesData});
}

class ScanDevice {
  final String scanName;
  final String scanIpAddress;
  final BluetoothDevice scanDevicesData;

  ScanDevice(
      {required this.scanName,
      required this.scanIpAddress,
      required this.scanDevicesData});
}
