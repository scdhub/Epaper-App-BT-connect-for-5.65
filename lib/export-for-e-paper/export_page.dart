import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:iphone_bt_epaper/devices_data.dart';
import '../app_body_color.dart';
import '../theme.dart';
import 'e_paper_send_picture_page.dart';
import 'e-paper_info.dart';
import '../theme.dart'; // theme.dartをインポート

class ExportPage extends StatefulWidget {
  final String trustName;
  final String trustIpAddress;
  final VoidCallback onDelete;
  final BluetoothDevice trustDevice;

  const ExportPage({
    super.key,
    required this.trustName,
    required this.trustIpAddress,
    required this.onDelete,
    required this.trustDevice,
  });

  @override
  State<ExportPage> createState() => _ExportPageState();
}

class _ExportPageState extends State<ExportPage> {
  var processRate = 0.5;
  E_paperInfo e_paperInfo;
  //信頼済みデバイスデータ格納List
  List<TrustDevice> trustDevices = [];
//e_paperInfoの初期化。null回避
  _ExportPageState() : e_paperInfo = E_paperInfo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'BTスキャン＆E-paper配信関連',
          // style: TextStyle(fontSize: 17,)
        ),
      ),
      body: CustomPaint(
        painter: HexagonPainter(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white38,
                        child: const Text('接続 E-paper 情報',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            )))),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      border: Border.all(
                        color: Colors.black12,
                        width: 2,
                      )),
                  child: Column(children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('デバイス名',
                              style: TextStyle(
                                fontSize: 20,
                              )),
                          Text(
                              widget.trustName.isEmpty
                                  ? '不明'
                                  : widget.trustName,
                              style: const TextStyle(
                                fontSize: 20,
                              )),
                        ]),
                    const SizedBox(height: 5),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('IP',
                              style: TextStyle(
                                fontSize: 20,
                              )),
                          Text(widget.trustIpAddress,
                              style: const TextStyle(
                                fontSize: 15,
                              )),
                        ]),
                  ]),
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white38,
                        child: const Text('E-paper規格情報',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            )))),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Color(0xFF29B6F6),
                      border: Border.all(
                        color: Colors.black12,
                        width: 2,
                      )),
                  child: Column(children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('画面サイズ',
                              style: TextStyle(
                                fontSize: 20,
                              )),
                          Text(e_paperInfo.screenSize,
                              style: const TextStyle(
                                fontSize: 20,
                              ))
                        ]),
                    const SizedBox(height: 5),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('解像度',
                              style: TextStyle(
                                fontSize: 20,
                              )),
                          Text(e_paperInfo.resolutions,
                              style: const TextStyle(
                                fontSize: 20,
                              ))
                        ]),
                    const SizedBox(height: 5),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('色',
                              style: TextStyle(
                                fontSize: 20,
                              )),
                          Text(e_paperInfo.colors,
                              style: const TextStyle(
                                fontSize: 20,
                              ))
                        ]),
                  ]),
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white38,
                        child: const Text('E-paper配信用画像の表示',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            )))),
                Container(
                  // color:Colors.white,
                  width: MediaQuery.of(context).size.width,
                  height: 80,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      border: Border.all(
                        color: Colors.black12,
                        width: 2,
                      )),
                  child:
                      // Column(children:[
                      Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SendPictureSelect(
                                    deviceInfo: widget.trustDevice,
                                  )),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        // backgroundColor: const Color(0xFF7E57C2),
                        elevation: 10,
                        side: const BorderSide(
                          color: Colors.white,
                          // color: Colors.transparent,　透明？
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),

                        ),
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child:
                            // Row(children: [
                            const Center(
                                child: Text('配信 or 削除',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ))),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white38,
                        child: const Text('このデバイスの登録を解除',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            )))),
                Container(
                  // color:Colors.white,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Color(0xFF29B6F6),
                      border: Border.all(
                        color: Colors.black12,
                        width: 2,
                      )),
                  height: 80,
                  child:
                      // Column(children:[
                      Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          barrierDismissible:
                              false, //dialog以外の部分をタップしても消えないようにする。
                          context: context,
                          builder: (context) =>
                              DeviceUnLockPop(onDelete: widget.onDelete),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const  Color(0xFFAB47BC),
                        elevation: 10,
                        side: const BorderSide(
                          color:  Colors.white,
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child:
                            // Row(children: [
                            const Center(
                                child: Text('解除',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ))),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DeviceUnLockPop extends StatelessWidget {
  final VoidCallback onDelete;

  const DeviceUnLockPop({super.key, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AlertDialog(
          backgroundColor: Colors.white,
          //ダイアログメッセージの形
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          // mainAxisAlignment: MainAxisAlignment.center,
          // children: [
          //   AlertDialog(
          title: Text(
            "確認",
            style: AppTheme.dialogTitleStyle,//theme.dartのスタイルを使用
            textAlign: TextAlign.center,
          ),

          content: Column(
              mainAxisSize: MainAxisSize.min, //サイズ調節
              children: [
                Text('登録を解除しますか？',
                  style: AppTheme.dialogContentStyle,//theme.dartのスタイルを使用
                  textAlign: TextAlign.center,
                ),

                //     style: TextStyle(
                //       fontSize: 20,
                //       // fontWeight: FontWeight.bold,
                //     )),
                // content:
                const SizedBox(height:16),
                Wrap(
                  spacing: 10, // ボタン間の間隔
                  runSpacing: 10, // 折り返した際の間隔
                  alignment: WrapAlignment.center,
                  children: [
                    SizedBox(
                      width: 100, // ボタンの横幅を制限
                      child: ElevatedButton(
                        style:AppTheme.dialogYesButtonStyle,//theme.dartのスタイルを使用
                        // ElevatedButton.styleFrom(
                        //   backgroundColor: const Color(0xFFFFA7A7), // ピンク
                        //   shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(10),
                        //   ),
                        // ),
                        onPressed: () async {
                          onDelete();
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "はい",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        style: AppTheme.dialogNoButtonStyle, //theme.dartのスタイルを使用
                        // ElevatedButton.styleFrom(
                        //   backgroundColor: const Color(0xFFB0C4DE), // ふんわりしたブルー
                        //   shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(10),
                        //   ),
                        // ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "いいえ",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ]
          )
      ),
    );
  }
}