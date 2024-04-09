import 'package:flutter/material.dart';
import 'devices_data.dart';
import 'import_page.dart';
import 'package:google_fonts/google_fonts.dart';

class ConnectBTPage extends StatefulWidget {
  @override
  State<ConnectBTPage> createState() => _ConnectBTPageState();
}

class _ConnectBTPageState extends State<ConnectBTPage> {
  // List<String> trustDevices = [];
  List<TrustDevice> trustDevices = [];

  // 仮データ
  // List<String> detectDevices = [
  //   'リンゴ',
  //   'みかん',
  //   'なし',
  //   '柿',
  //   'ブドウ',
  //   'イチゴ',
  //   'apple',
  //   'orange',
  //   'パイナップル',
  //   'ブルーベリー'
  // ];
  var isScanning = false;
//  データを作成
//   TrustDevice trustDevice;
//   _ConnectBTPageState() : trustDevice = TrustDevice();

  // DetectDevice detectDevice;
  // _ConnectBTPageState() : detectDevice = DetectDevice();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text('E ink 電子ペーパー',
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
                        ? CircularProgressIndicator()
                        : Icon(Icons.restart_alt),
                    SizedBox(width: 10),
                    Text(isScanning ? 'スキャン停止' : 'スキャン開始',
                        style: TextStyle(color: Colors.white,fontSize:20,))
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
                  });
                },
              ),
            ),
            // Text('登録済みデバイス',style: TextStyle(fontSize:20,),textAlign: TextAlign.left),
            // Text('登録済みデバイス',style:GoogleFonts.bungeeSpice( textStyle: TextStyle(fontSize:20,))),
            // Text('登録済みデバイス',style:GoogleFonts.mPlusRounded1c( textStyle: TextStyle(fontSize:20,))),
            Text('登録済みデバイス',style:GoogleFonts.sawarabiGothic( textStyle: TextStyle(fontSize:20,))),

            Container(
              height: 250,

              child:ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: trustDevices.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          // ImportPage(TrustDevice(trustName:devices[index].detectName,trustIpAddress: devices[index].detectIpAddress))),
                      ImportPage(trustName: trustDevices[index].trustName, trustIpAddress: trustDevices[index].trustIpAddress)),
                    );
                  },
                    child:Container(
                    // width: 100,
                    height: 50,
                    margin: EdgeInsets.all(1),
                    // color: Colors.white,
                    alignment: Alignment.center,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape:BoxShape.rectangle,
                        border: Border.all(
                          color: Colors.black12,
                          width: 2,
                        ),
                    borderRadius:BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 5),
                          color: Colors.grey,
                        ),
                      ],
                    ),

                    // child: Text(trustDevices[index]),
                    child:Column(
                      children:[
                      Text(trustDevices[index].trustName,style:TextStyle(fontWeight:FontWeight.bold),),
                        Text(trustDevices[index].trustIpAddress,style:TextStyle(fontWeight:FontWeight.bold,color:Colors.grey),),
                    ]
                    ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Text('未登録デバイス',style: TextStyle(fontSize:20,)), // Swap the order of sections
            Expanded(
              child: ListView.builder(
                // itemCount: detectDevices.length,
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        // trustDevices.add(detectDevices[index]);
                        // detectDevices.removeAt(index);
                        trustDevices.add(TrustDevice(trustName:devices[index].detectName,trustIpAddress: devices[index].detectIpAddress));
                        devices.removeAt(index);

                      });
                    },
                    child: Container(
                      height: 50,
                      // color: Colors.blue,
                      margin: EdgeInsets.all(1),
                      alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.greenAccent,
                            shape:BoxShape.rectangle,
                            border: Border.all(
                              color: Colors.black12,
                              width: 2,
                            ),
                          borderRadius:BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 5),
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      // child: Text(detectDevices[index]),
                      child:Column(
                        children:[
                          Text(devices[index].detectName,style:TextStyle(fontWeight:FontWeight.bold),),
                          Text(devices[index].detectIpAddress,style:TextStyle(fontWeight:FontWeight.bold,color:Colors.grey),),
                        ]
                      )
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
