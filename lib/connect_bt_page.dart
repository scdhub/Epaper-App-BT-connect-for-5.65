import 'package:flutter/material.dart';

class ConnectBTPage extends StatefulWidget {
  @override
  State<ConnectBTPage> createState() => _ConnectBTPageState();
}

class _ConnectBTPageState extends State<ConnectBTPage> {
  List<String> trustDevices = [];

  List<String> detectDevices = [
    'リンゴ',
    'みかん',
    'なし',
    '柿',
    'ブドウ',
    'イチゴ',
    'apple',
    'orange',
    'パイナップル',
    'ブルーベリー'
  ];
  var isScanning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text('電子ペーパー'),
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
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    isScanning = !isScanning;
                  });
                },
              ),
            ),
            Text('登録済みデバイス',style: TextStyle(fontSize:20,)),
            Container(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: trustDevices.length,
                itemBuilder: (context, index) {
                  return Container(
                    // width: 100,
                    height: 50,
                    margin: EdgeInsets.all(1),
                    // color: Colors.white,
                    alignment: Alignment.center,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black12,
                          width: 2,
                        )),
                    child: Text(trustDevices[index]),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Text('未登録デバイス',style: TextStyle(fontSize:20,)), // Swap the order of sections
            Expanded(
              child: ListView.builder(
                itemCount: detectDevices.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        trustDevices.add(detectDevices[index]);
                        detectDevices.removeAt(index);
                      });
                    },
                    child: Container(
                      height: 50,
                      color: Colors.blue,
                      margin: EdgeInsets.all(1),
                      alignment: Alignment.center,
                      child: Text(detectDevices[index]),
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
