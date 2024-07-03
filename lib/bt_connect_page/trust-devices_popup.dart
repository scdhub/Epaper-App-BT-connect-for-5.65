import 'package:flutter/material.dart';

class TrustDevices_popup extends StatefulWidget {
  final Function onOk;
  final String scanName;
  final String scanIpAddress;

  const TrustDevices_popup(
      {super.key,
      required this.onOk,
      required this.scanName,
      required this.scanIpAddress});

  @override
  State<TrustDevices_popup> createState() => _TrustDevices_popupState();
}

class _TrustDevices_popupState extends State<TrustDevices_popup> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.scanName.isEmpty
          ? '"IP:${widget.scanIpAddress}"を登録しますか？'
          : '"デバイス名：${widget.scanName}"を登録しますか？'),
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
