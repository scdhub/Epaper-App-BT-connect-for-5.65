import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class TrustDevice {
  final String trustName;
  final String trustIpAddress;
  final BluetoothDevice devicesData;

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
