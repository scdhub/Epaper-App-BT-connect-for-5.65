import 'package:flutter/material.dart';

class DeviceInfo {
  String vernum;

  String UIDnum;
  String resolution;
  String colorsaport;
  String maker;
  String colorparm;

  DeviceInfo({
    this.vernum = '2.5.1',
    this.UIDnum = '005EF97E',
    this.resolution = '160×160(垂直走査)',
    this.colorsaport = 'ブラックホワイトレッド',
    this.maker = 'その他(F0)',
    this.colorparm = '黒(0)白(2)赤(1)',
  });
}

class ImportPage extends StatefulWidget {
  @override
  State<ImportPage> createState() => _ImportPageState();
}

class _ImportPageState extends State<ImportPage> {
  DeviceInfo deviceInfo;

  _ImportPageState() : deviceInfo = DeviceInfo();
  var _selectedIndex = 1;

  void updateDeviceInfo(String newVersion, String newUID, String newResolution,
      String newColorsaport, String newMaker, String newColorparm) {
    setState(() {
      deviceInfo.vernum = newVersion;
      deviceInfo.UIDnum = newUID;
      deviceInfo.resolution = newResolution;
      deviceInfo.colorsaport = newColorsaport;
      deviceInfo.maker = newMaker;
      deviceInfo.colorparm = newColorparm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('E ink 電子ペーパー'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE1E9FF), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                '描画位置を選択',
              ),
              SizedBox(height: 10),
              Container(
                // color:Colors.white,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black12,
                      width: 2,
                    )),
                child: ListView(shrinkWrap: true, children: [
                  RadioListTile(
                      value: 1,
                      groupValue: _selectedIndex,
                      title: Text('画面1'),
                      onChanged: (int? value) {
                        setState(() {
                          _selectedIndex = value!;
                        });
                      }),
                  RadioListTile(
                      value: 2,
                      groupValue: _selectedIndex,
                      title: Text('画面2'),
                      onChanged: (int? value) {
                        setState(() {
                          _selectedIndex = value!;
                        });
                      }),
                ]),
              ),
              Text('デバイス内の写真を選んでE-paperにインポート'),
              Container(
                // color:Colors.white,
                width: double.infinity,
                height: 80,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black12,
                      width: 2,
                    )),
                child:
                    // Column(children:[
                    Padding(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: ElevatedButton(
                    child: Container(
                      width: double.infinity,
                      child:
                          // Row(children: [
                          Center(
                              child: Text('写真を選択',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ))),
                    ),
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      // backgroundColor: isScanning ? Colors.blue : Colors.grey,
                      backgroundColor: Colors.blue,
                      elevation: 10,
                      side: BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                  ),
                ),
              ),
              Text('デバイス内の文書を選んでE-paperにインポート'),
              Container(
                // color:Colors.white,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black12,
                      width: 2,
                    )),
                height: 80,
                child:
                    // Column(children:[
                    Padding(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: ElevatedButton(
                    child: Container(
                      width: double.infinity,
                      child:
                          // Row(children: [
                          Center(
                              child: Text('文書を選択',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ))),
                    ),
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      // backgroundColor: isScanning ? Colors.blue : Colors.grey,
                      backgroundColor: Colors.blue,
                      elevation: 10,
                      side: BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                  ),
                ),
              ),
              Text('設備情報'),
              Container(
                // color:Colors.white,

                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black12,
                      width: 2,
                    )),
                child: Column(children: [
                  Text('設備名称',style: TextStyle(fontSize:20,)),
                  Text('IMEI',style: TextStyle(fontSize:20,)),
                  Text('MACアドレス',style: TextStyle(fontSize:20,)),
                ]),
              ),
              Text('装置企画情報',style: TextStyle(fontSize:20,)),
              Container(
                // color:Colors.white,

                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black12,
                      width: 2,
                    )),
                child: Column(
                    children: [
                  Text('画面サイズ',style: TextStyle(fontSize:20,)),
                  Text('解像度',style: TextStyle(fontSize:20,)),
                  Text('色',style: TextStyle(fontSize:20,)),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
