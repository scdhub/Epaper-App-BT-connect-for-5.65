import 'package:flutter/material.dart';

class ConnectBTPage extends StatefulWidget {
  @override
  State<ConnectBTPage> createState() => _ConnectBTPageState();
}

class _ConnectBTPageState extends State<ConnectBTPage> {

  List<String> trustDevices = [];

  List<String> detectDevices =[
    'リンゴ','みかん','なし','柿','ブドウ'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('電子ペーパー'),
      ),
      body: Column(
        children: [
          OutlinedButton(
            child: const Text('スキャン停止'),
            style: OutlinedButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () {},
          ),

          Text('登録済みデバイス'),
          Container(
            height: 300,
            color: Colors.grey,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: trustDevices.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 100,
                  margin: EdgeInsets.all(8),
                  color: Colors.green,
                  alignment: Alignment.center,
                  child: Text(trustDevices[index]),

                );
              },
            ),
          ),
          Text('未登録デバイス'), // Swap the order of sections
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
                    alignment: Alignment.center,
                    child: Text(detectDevices[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


////---------------------------------------
  // List<Widget> trustDevices = [];
//
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//         title: Text('電子ペーパー'),
//       ),
//     body: Column(
//       children: [
//       OutlinedButton(
//                   child: const Text('スキャン停止'),
//                   style: OutlinedButton.styleFrom(backgroundColor: Colors.blue),
//                   onPressed: () {},
//                 ),
//         Text('登録済みデバイス',
//           textAlign: TextAlign.left,
//         ),
//         // trustDEvices(),
//         Container(
//           height: 300,
//           color: Colors.grey,
//           child: ListView.builder(
//             scrollDirection: Axis.vertical,
//             itemCount: trustDevices.length,
//             itemBuilder: (context, index) {
//               return Container(
//                 width: 100,
//                 margin: EdgeInsets.all(8),
//                 color: Colors.green,
//                 alignment: Alignment.center,
//                 child:trustDevices[index],
//               );
//             },
//           ),
//         ),
//         Text('未登録デバイス'),
//         Expanded(
//           child: ListView.builder(
//             itemCount: 10, // Change this to the desired number of containers
//             itemBuilder: (context, index) {
//               return GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     trustDevices.add(Text('Container $index'));
//                     trustDevices.removeAt(index);
//                   });
//                 },
//                 child: Container(
//                   height: 50,
//                   color: Colors.blue,
//                   alignment: Alignment.center,
//                   child: Text('Container $index'),
//                 ),
//               );
//             },
//           ),
//         ),
//
//       ],
//     ),
//   );
// }
// }

////---------------------------------
//         Expanded(
//           child: ListView.builder(
//             itemCount: 10, // 十数個のContainerを表示
//             itemBuilder: (context, index) {
//               return GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     // タップしたContainerを追加
//                     trustDevices.add(Container(
//                       width: 100,
//                       height: 50,
//                       color: Colors.blue,
//                       margin: EdgeInsets.all(8),
//                     ));
//                   });
//                 },
//                 child: Container(
//                   width: 100,
//                   height: 50,
//                   color: Colors.grey,
//                   margin: EdgeInsets.all(8),
//                 ),
//               );
//             },
//           ),
//         ),
//         Container(
//           height: 100,
//           color: Colors.yellow,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: trustDevices.length,
//             itemBuilder: (context, index) {
//               return trustDevices[index];
//             },
//           ),
//         ),
//       ],
//     ),
//   );
// }
// }



//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//         title: Text('電子ペーパー'),
//       ),
//       body: Center(
//         child: Container(
//             width: double.infinity,
//             color: Colors.grey,
//             padding: EdgeInsets.all(8.0),
//
//             child:
//     Column(
//               children: [
//                 OutlinedButton(
//                   child: const Text('スキャン停止'),
//                   style: OutlinedButton.styleFrom(backgroundColor: Colors.blue),
//                   onPressed: () {},
//                 ),
//                 Text('登録済みデバイス'),
//                 Expanded(
//                   child:
//                 Container(
//                     width: 300,
//                     height: 300,
//                     color: Colors.white54,
//                     child: SingleChildScrollView(
//                         child: Column(children: [
//                           // Container(width: 200, height: 100, color: Colors.purple,),
//                           // Container(width: 200, height: 100, color: Colors.indigo),
//                           // Container(width: 200, height: 100, color: Colors.green),
//                           // Container(width: 200, height: 100, color: Colors.pink),
//                         ])))),
//                 SizedBox(),
//                 Text('未登録デバイス'),
//                 Container(
//                     width: 300,
//                     height: 300,
//
//                     child: SingleChildScrollView(
//                         child: Column(children: [
//                       Container(width: 200, height: 100, color: Colors.white54,),
//                       Container(width: 200, height: 100, color: Colors.red),
//                       Container(width: 200, height: 100, color: Colors.blue),
//                       Container(width: 200, height: 100, color: Colors.green),
//                       Container(width: 200, height: 100, color: Colors.pink),
//                       Container(width: 200, height: 100, color: Colors.yellow),
//                       Container(width: 200, height: 100, color: Colors.purple),
//                       Container(width: 200, height: 100, color: Colors.indigo),
//                       Container(width: 200, height: 100, color: Colors.white54),
//                       Container(
//                           width: 200, height: 100, color: Colors.greenAccent),
//                     ])))
//               ],
//             ),
//       ),)
//     );
//   }
// }
