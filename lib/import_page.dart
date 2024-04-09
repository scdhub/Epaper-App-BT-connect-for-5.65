import 'package:flutter/material.dart';
import 'package:iphone_bt_epaper/devices_data.dart';
import 'photo-select_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'e-paper_info.dart';

class ImportPage extends StatefulWidget {
  final String trustName;
  final String trustIpAddress;

  ImportPage({
    required this.trustName,
    required this.trustIpAddress,
  });

  @override
  State<ImportPage> createState() => _ImportPageState();
}

class _ImportPageState extends State<ImportPage> {
  var _selectedIndex = 1;
  var processRate = 0.5;
  E_paperInfo e_paperInfo;

  _ImportPageState(): e_paperInfo = E_paperInfo();




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          'E ink 電子ペーパー',
          style: GoogleFonts.sawarabiGothic(),
        ),
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
              Text('描画位置を選択',
                  style: TextStyle(
                    fontSize: 20,
                  )),
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
          Padding(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              child:Text('デバイス内の写真を選んでE-paperにインポート',
                  style: TextStyle(
                    fontSize: 16,
                  ))),
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
                                    fontSize: 16,
                                  ))),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => imageSelect_Album()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      // backgroundColor: isScanning ? Colors.blue : Colors.grey,
                      backgroundColor: Colors.blue,
                      elevation: 10,
                      side: BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Row(children: [
                SizedBox(width: 10),
                // Padding(
                // padding:EdgeInsets.all(5),
                // child:// LinearProgressIndicator(value: processRate),
                Expanded(
                  child: LinearProgressIndicator(
                    value: processRate,
                    color: Colors.greenAccent,
                    minHeight: 20,
                  ),
                ),
                // ),
                SizedBox(width: 10),
// Text('${(processRate * 100).toStringAsFixed(1)}%'),
                Text('${(processRate * 100).toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 20,
                    )),
              ]),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              child:Text('デバイス内の文書を選んでE-paperにインポート',
                  style: TextStyle(
                    fontSize: 16,
                  ))),
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
                                    fontSize: 16,
                                  ))),
                    ),
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      // backgroundColor: isScanning ? Colors.blue : Colors.grey,
                      backgroundColor: Colors.blue,
                      elevation: 10,
                      side: BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              child:Text('設備情報',
                  style: TextStyle(
                    fontSize: 20,
                  ))),
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
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('設備名称',
                            style: TextStyle(
                              fontSize: 20,
                            )),
                        Text(widget.trustName,
                            style: TextStyle(
                              fontSize: 20,
                            )),
                      ]),
                  SizedBox(height:5),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('IMEI',
                            style: TextStyle(
                              fontSize: 20,
                            )),
                        Text('46008000C003070',
                            style: TextStyle(
                              fontSize: 20,
                            )),
                      ]),
                      SizedBox(height:5),

                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('MACアドレス',
                            style: TextStyle(
                              fontSize: 20,
                            )),
                        Text(widget.trustIpAddress,
                            style: TextStyle(
                              fontSize: 20,
                            )),
                      ]),
                ]),
              ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              child:Text('装置企画情報',
                  style: TextStyle(
                    fontSize: 20,
                  ))),
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
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('画面サイズ',
                            style: TextStyle(
                              fontSize: 20,
                            )),
                        Text(e_paperInfo.screenSize,
                            style: TextStyle(
                              fontSize: 20,
                            ))
                      ]),
                  SizedBox(height:5),

                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('解像度',
                            style: TextStyle(
                              fontSize: 20,
                            )),
                        Text(e_paperInfo.resolutions,
                            style: TextStyle(
                              fontSize: 20,
                            ))
                      ]),
                  SizedBox(height:5),

                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('色',
                            style: TextStyle(
                              fontSize: 20,
                            )),
                        Text(e_paperInfo.colors,
                            style: TextStyle(
                              fontSize: 20,
                            ))
                      ]),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
