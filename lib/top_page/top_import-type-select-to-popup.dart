import 'package:flutter/material.dart';
import '../import_type_select_page/import-type-select_popup.dart';

class ImportTypeSelectToPopup extends StatefulWidget {
  const ImportTypeSelectToPopup({super.key});

  @override
  State<ImportTypeSelectToPopup> createState() =>
      _ImportTypeSelectToPopupState();
}

class _ImportTypeSelectToPopupState extends State<ImportTypeSelectToPopup> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white60,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            offset: Offset(2, 5),
            color: Colors.blueGrey,
          ),
        ],
      ),
      width: 150,
      height: 150,
      child: ElevatedButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            // backgroundColor: Colors.blueGrey,
            backgroundColor: Colors.white,
            side: const BorderSide(
              color: Colors.blueGrey,
              width: 2,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const ImageTypeSelection_popup(),
            );
          },
          child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.install_mobile_rounded,
                  size: 50.0,
                  color: Colors.blueGrey,
                ),
                Text('スマホから\n画像を登録',
                    style: TextStyle(
                      fontFamily: 'NotoSansJP',
                      // fontWeight: FontWeight.w400,//Regular
                      fontWeight: FontWeight.w500, //Midum
                      fontSize: 14,
                    )),
              ])),
    );
  }
}
