import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../devices_data.dart';
import '../export-for-e-paper/export_page.dart';
import 'package:google_fonts/google_fonts.dart';

class ConnectBTPage extends StatefulWidget {
  @override
  State<ConnectBTPage> createState() => _ConnectBTPageState();
}

class _ConnectBTPageState extends State<ConnectBTPage> {
  // List<String> trustDevices = [];
  List<TrustDevice> trustDevices = [];//信頼済みデバイスデータ格納List

List<ScanDevice> scanDevices = [];//スキャンした時のデバイスデータを格納

  //信頼済みデバイスアプリ終了しても記憶できるように追加
  //データ書き込み
  _saveStringList(List<TrustDevice> value) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
      'item',
      value
          .map((device) => '${device.trustName}:${device.trustIpAddress}')
          .toList(),
    );

  }
//データ読み込み
  _restoreValues() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      trustDevices = (prefs.getStringList('item') ?? []).map((item) {
        final parts = item.split(':');
        return TrustDevice(
          trustName: parts[0],
          trustIpAddress: parts[1],
        );
      }).toList();
    });
  }

  //信頼済みデバイスからデータ削除
  void _removeCounterValue(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      var deviceToRemove = trustDevices[index];
      trustDevices.removeAt(index);
      _saveStringList(trustDevices);
      // SharedPreferencesから特定のデバイスを削除
      prefs.setStringList('item', trustDevices
          .map((device) => '${device.trustName}:${device.trustIpAddress}')
          .toList());
    });
  }

  @override
  void initState() {
    _restoreValues();
    super.initState();
  }

  bool isScanning = false;//スキャン開始、停止

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.blue,
        backgroundColor: Color(0xFF87ff99),
        centerTitle: true,
        title: Text(
          'E ink 電子ペーパー',
          style: GoogleFonts.sawarabiGothic(),
        ),
      ),
      body: Container(
        // color:Colors.greenAccent,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE1E9FF), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(50),
              child: ElevatedButton(
                child: Container(
                  width: 170,
                  child: Row(children: [
                    isScanning
                        // ? CircularProgressIndicator()
                        ? Container(color: Colors.red,width: 5,height: 5,)
                        : Icon(Icons.restart_alt),
                    SizedBox(width: 10),
                    Text(isScanning ? 'スキャン停止' : 'スキャン開始',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ))
                  ]),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isScanning ? Colors.blue : Colors.grey,
                  elevation: 10,
                  side: BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    isScanning = !isScanning;
                    if(isScanning == true){
                      scanDevices = devices.map((device) =>
                          ScanDevice(scanName: device.detectName, scanIpAddress: device.detectIpAddress)
                      ).toList();
                    }
                  });
                  // if(isScanning == true){
                  //   scanDevices = devices.map((device) =>
                  //       ScanDevice(scanName: device.detectName, scanIpAddress: device.detectIpAddress)
                  //   ).toList();
                  // }
                },
              ),
            ),
            // Text('登録済みデバイス',style: TextStyle(fontSize:20,),textAlign: TextAlign.left),
            // Text('登録済みデバイス',style:GoogleFonts.bungeeSpice( textStyle: TextStyle(fontSize:20,))),
            // Text('登録済みデバイス',style:GoogleFonts.mPlusRounded1c( textStyle: TextStyle(fontSize:20,))),
            Text('登録済みデバイス',
                style: GoogleFonts.sawarabiGothic(
                    textStyle: TextStyle(
                  fontSize: 20,
                ))),

            Container(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: trustDevices.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) =>
                      //           // ImportPage(TrustDevice(trustName:devices[index].detectName,trustIpAddress: devices[index].detectIpAddress))),
                      //           ImportPage(
                      //               trustName: trustDevices[index].trustName,
                      //               trustIpAddress:
                      //                   trustDevices[index].trustIpAddress)),
                      // );
                    },
                    child: Container(
                      // width: 100,
                      height: 50,
                      margin: EdgeInsets.all(1),
                      // color: Colors.white,
                      alignment: Alignment.center,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        border: Border.all(
                          color: Colors.black12,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 5),
                            color: Colors.grey,
                          ),
                        ],
                      ),

                      // child: Text(trustDevices[index]),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
SizedBox(width: 50,),
                      Column(
                          children: [
                        Text(
                          trustDevices[index].trustName,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          trustDevices[index].trustIpAddress,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                      ]),
                        IconButton(
                          onPressed: (){
                            // _removeCounterValue(index);
                            // _saveStringList(trustDevices);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                  // ImportPage(TrustDevice(trustName:devices[index].detectName,trustIpAddress: devices[index].detectIpAddress))),
                                  ExportPage(
                                      trustName: trustDevices[index].trustName,
                                      trustIpAddress:trustDevices[index].trustIpAddress,
                                    onDelete: () => _removeCounterValue(index),
                                  ),
                              ),
                            );
                          },
                          icon:Icon(Icons.info_outline_rounded),
                        ),
                    ]),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Text('未登録デバイス',
                style: TextStyle(
                  fontSize: 20,
                )),
            // Swap the order of sections
            // isScanning ?
            Expanded(
              child:
              scanDevices.isNotEmpty ?
              ListView.builder(
                // itemCount: detectDevices.length,
                // itemCount: devices.length,
                // itemBuilder: (context, index) {
                //   if (trustDevices.any((device) =>
                //       device.trustName == devices[index].detectName &&
                //       device.trustIpAddress ==
                //           devices[index].detectIpAddress)) {

    itemCount: scanDevices.length,
    itemBuilder: (context, index) {
    if (trustDevices.any((device) =>
    device.trustName == scanDevices[index].scanName &&
    device.trustIpAddress ==
        scanDevices[index].scanIpAddress)) {
                    return Container();
                    // return Text('スキャンを開始して、未登録デバイスを表示してください',style: TextStyle(color: Colors.redAccent),);
                  } else {
                    return GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              TrustDevices_popup(
                                onOk:(){
                                  setState(() {
                                    // trustDevices.add(detectDevices[index]);
                                    // detectDevices.removeAt(index);
                                    trustDevices.add(TrustDevice(
                                        trustName: scanDevices[index].scanName,
                                        trustIpAddress: scanDevices[index].scanIpAddress));
                                    scanDevices.removeAt(index);
                                    _saveStringList(trustDevices);
                                  });
                                }
                              ),
                        );
                        // setState(() {
                        //   // trustDevices.add(detectDevices[index]);
                        //   // detectDevices.removeAt(index);
                        //   trustDevices.add(TrustDevice(
                        //       trustName: devices[index].detectName,
                        //       trustIpAddress: devices[index].detectIpAddress));
                        //   devices.removeAt(index);
                        //   _saveStringList('item', trustDevices);
                        // });
                      },
                      child: Container(
                          height: 50,
                          // color: Colors.blue,
                          margin: EdgeInsets.all(1),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.greenAccent,
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: Colors.black12,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 5),
                                color: Colors.grey,
                              ),
                            ],
                          ),
                          // child: Text(detectDevices[index]),

                          child: Column(children: [
                            Text(
                              // devices[index].detectName,
                              scanDevices[index].scanName,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              // devices[index].detectIpAddress,
                              scanDevices[index].scanIpAddress,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                          ])),
                    );
                  }
                },
              )
                    // : Text('デバイスを検出中...',style: TextStyle(color: Colors.blue),),
                  : Text('スキャンを開始して、未登録デバイスを表示してください',style: TextStyle(color: Colors.redAccent),),

            )
            // : Text('スキャンを開始して、未登録デバイスを表示してください',style: TextStyle(color: Colors.redAccent),),
            // Expanded(
            //   child: devices.isEmpty
            //       ? Text('スキャンを開始して、未登録デバイスを表示してください',style: TextStyle(color: Colors.redAccent),)
            //       : ListView.builder(
            //     // 省略
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}


class TrustDevices_popup extends StatefulWidget {
  final Function onOk;
  const TrustDevices_popup({required this.onOk});

  @override
  _TrustDevices_popupState createState() =>
      _TrustDevices_popupState();
}

class _TrustDevices_popupState extends State<TrustDevices_popup> {


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // actionsAlignment: MainAxisAlignment.center,
      // backgroundColor:Colors.lightBlueAccent,
      // title: Text('書き込み完了'),
      // content: Text('E-paperに配信しますか？'),
      title: Text('デバイスを登録しますか'),
      // content: TypeSelectedRadio(
      //   // コールバック関数を渡す
      //   onSelected: (value) {
      //     setState(() {
      //       _selectedIndex = value;
      //     });
      //   },
      // ),
      actions: <Widget>[

        Divider(),
        Container(
          width: 300,
          alignment:Alignment.center,
          child:Row(
    children: [
      TextButton(
        onPressed: (){
          widget.onOk();
    Navigator.pop(context, 'OK');
    } ,
        child: const Text('はい'),
      ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('いいえ'),
          ),
    ]),
        ),

         ],
    );
  }
}

