import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothConnection extends StatefulWidget {
  final BluetoothDevice device;
  final String targetDeviceName;  // デバイス名を受け取る

  BluetoothConnection({required this.device, required this.targetDeviceName});

  @override
  State<StatefulWidget> createState() => _BluetoothConnection();
}

class _BluetoothConnection extends State<BluetoothConnection> {
  BluetoothConnectionState _connectionState = BluetoothConnectionState.disconnected;
  bool _isReconnecting = false;
  final int maxRetries = 5; // 最大再接続回数
  final Duration retryDelay = Duration(seconds: 5); // 再試行の間隔
  StreamSubscription<BluetoothConnectionState>? _connectionSubscription;

  @override
  void initState() {
    super.initState();
    _checkDeviceAndConnection();
  }

  void _checkDeviceAndConnection() {
    // スキャンしたデバイスリストの中にターゲットデバイス名があるかを確認
    List<BluetoothDevice> scannedDevices = []; // ここはスキャンしたデバイスのリスト
    bool _deviceFound = scannedDevices.any((device) => device.name == widget.targetDeviceName);

    if (_deviceFound) {
      _connectToDevice();
    } else {
      // デバイスが見つからない場合、切断アイコンを表示し再接続試行
      setState(() {
        _connectionState = BluetoothConnectionState.disconnected;
      });
      _attemptReconnect();
    }

    _connectionSubscription = widget.device.connectionState.listen((state) {
      if (!mounted) return; // ウィジェットがツリーに存在しないなら処理をしない

      setState(() {
        _connectionState = state;
      });
      debugPrint("BluetoothState: $_connectionState");

      // 切断時に再接続を試行
      if (state == BluetoothConnectionState.disconnected && !_isReconnecting) {
        debugPrint("call _attemptReconnect");
        _attemptReconnect();
      }
    });
  }

  Future<void> _connectToDevice() async {
    try {
      await widget.device.connect();
      setState(() {
        _connectionState = BluetoothConnectionState.connected;
      });
    } catch (e) {
      debugPrint("接続失敗: $e");
      setState(() {
        _connectionState = BluetoothConnectionState.disconnected;
      });
      _attemptReconnect();  // 再接続試行
    }
  }

  Future<void> _attemptReconnect() async {
    if (_isReconnecting) return; // 再接続中は重複しないようにする
    _isReconnecting = true;
    int retryCount = 0;

    while (_connectionState == BluetoothConnectionState.disconnected && retryCount < maxRetries) {
      debugPrint("再接続試行中... ($retryCount)");
      try {
        await widget.device.connect();
        debugPrint("再接続成功");
        break;
      } catch (e) {
        debugPrint("再接続失敗: $e");
        if (retryCount >= maxRetries - 1) {
          debugPrint("最大再試行回数に達しました。手動で再接続してください。");
          break;
        }

        retryCount++;
        await Future.delayed(retryDelay); // 再試行間隔を待つ
      }
    }

    if (_connectionState == BluetoothConnectionState.disconnected) {
      debugPrint("再接続に失敗しました。手動で再接続してください。");
    }

    _isReconnecting = false;
  }

  @override
  void dispose() {
    _connectionSubscription?.cancel(); // Stream をキャンセル
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 接続状態に応じたアイコン表示
    return Icon(
      _connectionState == BluetoothConnectionState.connected
          ? Icons.bluetooth_connected
      // : _connectionState == BluetoothConnectionState.connecting  // connecting は非推奨
      // ? Icons.bluetooth_searching
          : Icons.bluetooth_disabled,
      color: _connectionState == BluetoothConnectionState.connected
          ? Color(0xFF29B6F6)
          : Colors.black38,
      size: 30.0,
    );
  }
}
