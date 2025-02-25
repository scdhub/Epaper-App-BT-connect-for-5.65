import 'package:flutter/material.dart';

import '../theme.dart';

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

//メッセージダイアログの編集　BT＆配信関係→登録デバイス確認
class _TrustDevices_popupState extends State<TrustDevices_popup> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),

        title: Column(
          children: [
            Text(
              "確認",
              textAlign: TextAlign.center,
              style: AppTheme.dialogTitleStyle, //theme.dartのスタイルを使用
            ),
            const SizedBox(height: 15,),
            Text(
              widget.scanName.isNotEmpty
                  ? '"デバイス名: ${widget.scanName}" を登録しますか？'
                  : '"IP: ${widget.scanIpAddress}" を登録しますか？',
              // ? '"IP:${widget.scanIpAddress}"を登録しますか？'
              // : '"デバイス名：${widget.scanName}"を登録しますか？',
              textAlign: TextAlign.center,
              style: AppTheme.dialogContentStyle, //theme.dartのスタイルを使用
            ),
          ],
        ),

        //     style: const TextStyle(
        //       fontSize: 18,
        //       fontWeight: FontWeight.bold,
        //       color: Colors.black87,
        //     ),
        //   ),
        // ],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 4),

            // actions: [
            //   const Divider(),
            Wrap(//はい、いいえの間余白
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    style: AppTheme.dialogYesButtonStyle,//theme.dartのスタイルを使用
                    //

                    // ElevatedButton.styleFrom(
                    //   backgroundColor: Colors.green, // 緑（登録）
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(10),
                    //   ),
                    // ),
                    // Container(
                    //   width: 300,
                    //   alignment: Alignment.center,
                    //   child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    //     TextButton(

                    onPressed: () {
                      widget.onOk();
                      Navigator.pop(context, 'OK');
                    },

                    child: const Text('はい',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            // fontSize: 11
                        )
                    ),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    style: AppTheme.dialogNoButtonStyle,//theme.dartのスタイルを使用
                    // ElevatedButton.styleFrom(
                    //   backgroundColor: Colors.redAccent, // 赤（キャンセル）
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(10),
                    //   ),
                    // ),
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('いいえ', style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        //
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16,)
          ],
        ),
      ),
    );
  }
}