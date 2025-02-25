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
        // color: Colors.white60,
        // borderRadius: BorderRadius.circular(20),
        //15
        // boxShadow: const [
        //   BoxShadow(
        //     offset: Offset(2, 5),
        //     color: Colors.blueGrey,
        //   ),
        // ],
      ),
      width: 150,
      height: 150,
      child: ElevatedButton(
          style: TextButton.styleFrom(
            // foregroundColor: Colors.black,
            // backgroundColor: Colors.blueGrey,
            backgroundColor: Color(0xFF9FA8DA),
            side: const BorderSide(
              color: Colors.white,
              width: 4,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
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
                  size: 40.0,
                  // color: Colors.white,
                ),
                SizedBox(height: 7),
                Text('スマホから登録',
                    style: TextStyle(
                      // fontFamily: 'NotoSansJP',
                      // fontWeight: FontWeight.w400,//Regular
                      fontWeight: FontWeight.bold, //Midum
                      fontSize: 14,
                      // color: Colors.white,
                    )),
              ])),
    );
  }
}
