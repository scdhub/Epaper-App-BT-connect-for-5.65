import 'package:flutter/material.dart';
import 'import-type-select_popup.dart';

class ImportTypeSelectToPopup extends StatefulWidget {

  @override
  State<ImportTypeSelectToPopup> createState() => _ImportTypeSelectToPopupState();
}

class _ImportTypeSelectToPopupState extends State<ImportTypeSelectToPopup> {
  @override
  Widget build(BuildContext context) {
    return  Container(

      width: 150,
      height: 150,
      child: ElevatedButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.blueGrey,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) =>
                  ImageTypeSelection_popup(),
            );
          },
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.install_mobile_rounded,
                  size: 50.0,
                ),
                Text(
                  'スマホから画像をインポート',
                ),
              ])),
    );
  }}
