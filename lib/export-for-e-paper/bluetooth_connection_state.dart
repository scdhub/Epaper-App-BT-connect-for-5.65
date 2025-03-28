import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothConnection extends StatefulWidget {
  final String connectionState;

  BluetoothConnection(this.connectionState);

  @override
  State<BluetoothConnection> createState() => _BluetoothConnection();
}

class _BluetoothConnection extends State<BluetoothConnection> {
  late String _connectionState;

  @override
  void initState() {
    super.initState();
    _connectionState = widget.connectionState;
  }

  @override
  void didUpdateWidget(covariant BluetoothConnection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.connectionState != widget.connectionState) {
      setState(() {
        _connectionState = widget.connectionState;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Icon(
      _connectionState == "connected"
          ? Icons.bluetooth_connected
          : Icons.bluetooth_disabled,
      size: 25,
      color: _connectionState  == "connected" ? Color(0xFF29B6F6) : Colors.black38,
    );
  }
}
