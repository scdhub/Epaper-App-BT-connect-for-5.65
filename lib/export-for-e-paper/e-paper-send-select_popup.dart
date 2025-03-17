import 'package:flutter/material.dart';
import '../bt_connect_page/connect_bt_page.dart';
import '../theme.dart';


class EpaperSendSelect extends StatefulWidget {
  const EpaperSendSelect({super.key});

  @override
  State<EpaperSendSelect> createState() => _EpaperSendSelectState();
}

//ダイアログデザイン：theme.dart
class _EpaperSendSelectState extends State<EpaperSendSelect> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // actionsAlignment: MainAxisAlignment.center,
      title: Text('確認',
        style: AppTheme.dialogTitleStyle,),
      content: Text('E-paperに送信しますか？',
        style: AppTheme.dialogContentStyle,),
      actionsAlignment: MainAxisAlignment.center,

      actions: <Widget>[
        ElevatedButton(
          // TextButton(
          style: AppTheme.dialogNoButtonStyle,
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('いいえ'),
          // child: const Text('キャンセル'),
        ),

        ElevatedButton(
          style: AppTheme.dialogYesButtonStyle,
          // TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ConnectBTPage()),
            );
          },
          child: const Text('はい'),
          // child: const Text('OK'),
        ),
      ],
    );
  }
}
