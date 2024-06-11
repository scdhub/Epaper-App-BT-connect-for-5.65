import 'package:flutter/material.dart';

class TrustDevices_popup extends StatefulWidget {
  final Function onOk;
  final String scanName;

  const TrustDevices_popup({required this.onOk,required this.scanName});

  @override
  _TrustDevices_popupState createState() => _TrustDevices_popupState();
}

class _TrustDevices_popupState extends State<TrustDevices_popup> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(

      title: Text('"${widget.scanName}"を登録しますか'),
      actions: <Widget>[
        Divider(),
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
