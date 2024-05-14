import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:crop/crop.dart';
import 'dart:ui' as ui;

import 'select-photo-check_page.dart';

// import 'importPreview_page.dart';
// import 'trimming_cropSpace.dart';

class TrimmingPage extends StatefulWidget {
  final Uint8List? imageData;

  TrimmingPage({Key? key, required this.imageData}) : super(key: key);

  @override
  State<TrimmingPage> createState() => _TrimmingPageState();
}

class _TrimmingPageState extends State<TrimmingPage> {
  final controller = CropController(aspectRatio: 600 / 448);//切り取る画像の縦横比1:1に設定
  bool isSquare = true;
  void _changeAspectRatio(bool isSquare) {
    setState(() {
      controller.aspectRatio = isSquare ? 600 / 448 : 1.0; // 例として16:9を使用
    });
  }

  void _cropImage() async {
    //デバイスのピクセル比を取得して、画面解像度に合わせて画像を切り取る
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    //指定されたピクセル比で画像を切り取る
    final ui.Image? cropped = await controller.crop(pixelRatio: pixelRatio);
    if (cropped == null) {
      return;
    }
    if (!mounted) {//ウィジェットが画面から消えている状態で、Stateを更新しようとするエラーを防ぐ。
      return;
    }
    final byteData = await cropped.toByteData(format: ui.ImageByteFormat.png);

    // bufferがbyteDataのnullの確認が必要のため、
    if (byteData == null) {
      return;
    }
    final Uint8List cropByte = byteData.buffer.asUint8List();

    var cropBytes = [cropByte];
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) => importPreview_page(
    //           imageBytes: cropBytes)),
    // );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectCheck(imageData: cropBytes),
      ),
    );
  }
  // bool light = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('トリミング画面', style: TextStyle(color: Colors.white)),
          actions: [
            Row(children: [

              Switch(
                  activeColor:Colors.red,
                value: isSquare,
              onChanged: (bool value){
                _changeAspectRatio(value);
                setState(() {
                  isSquare = value;

                });
              },

              ),
            IconButton(
              icon: Icon(Icons.done, color: Colors.white),
              onPressed: _cropImage,
            ),
      ]),
          ],
          backgroundColor: Colors.black45,
        ),
        backgroundColor: Colors.black45,
        body:
    // AspectRatio(
    //       aspectRatio:600/448,
    // child:
    CropSpace(
          imageData: widget.imageData!,
          controller: controller,
        ),
      // ),
      ),
    );
  }
}


Widget buildGridHelper(double aspectRatio) {
  return LayoutBuilder(
    builder: (context, constraints) {
      // アスペクト比に基づいてグリッドの幅と高さを計算
      final double gridWidth = constraints.maxWidth / 3;
      final double gridHeight = (constraints.maxWidth / aspectRatio) / 3;

      return Stack(
        children: <Widget>[
          // 横線
          for (int i = 0; i < 3; i++)
            Positioned(
              left: 0,
              top: gridHeight * i,
              child: Container(
                width: constraints.maxWidth,
                height: 2,
                color: Colors.black,
              ),
            ),
          // 縦線
          for (int i = 0; i < 3; i++)
            Positioned(
              left: gridWidth * i,
              top: 0,
              child: Container(
                width: 2,
                height: constraints.maxHeight,
                color: Colors.black,
              ),
            ),
        ],
      );
    },
  );
}

// Widget buildGridHelper() {
//   return LayoutBuilder(
//     builder: (context, constraints) {
//       final double gridWidth = constraints.maxWidth / 3;
//       final double gridHeight = constraints.maxHeight / 3;
//       // final double gridWidth = constraints.maxWidth / 3;
//       // final double gridHeight = (constraints.maxWidth / aspectRatio) / 3;
//
//       return Stack(
//         children: <Widget>[
//           for (int i = 0; i < 3; i++)
//             Positioned(
//               left: 0,
//               top: gridHeight * i,
//               child: Container(
//                 width: constraints.maxWidth,
//                 height: 2,
//                 color: Colors.black,
//               ),
//             ),
//           for (int i = 0; i < 3; i++)
//             Positioned(
//               left: gridWidth * i,
//               top: 0,
//               child: Container(
//                 width: 2,
//                 height: constraints.maxHeight,
//                 color: Colors.black,
//               ),
//             ),
//         ],
//       );
//     },
//   );
// }

// import 'package:flutter/material.dart';
// import 'package:crop/crop.dart';
// import 'dart:typed_data';
//
// import 'trimming_cropSpace_GridHelper.dart';

class CropSpace extends StatefulWidget {
  final Uint8List imageData;
  final CropController controller;

  CropSpace({required this.imageData, required this.controller});

  @override
  _CropSpaceState createState() => _CropSpaceState();
}

class _CropSpaceState extends State<CropSpace> {
  double _rotation = 0; // 画像の回転角度
  Offset _offset = Offset.zero;
  BoxShape shape = BoxShape.rectangle;//切り取る形状、四角形
  // final double aspectRatio = getAspectRatio();
  double getAspectRatio() {
    return widget.controller.aspectRatio;
  }
  @override
  Widget build(BuildContext context) {
    final double aspectRatio = getAspectRatio();
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child:
            // AspectRatio(
            //       aspectRatio:600/448,
            // child:
            Container(
              color: Colors.black,
              padding: const EdgeInsets.all(8),
              child: Crop(
                onChanged: (decomposition) {
                  if (_rotation != decomposition.rotation) {
                    setState(() {
                      _rotation = ((decomposition.rotation + 180) % 360) - 180;
                      // _offset = decomposition.offset;
                    });
                  }
                },
                controller: widget.controller,
                shape: shape,
                // helper: buildGridHelper(),//切り取り範囲を視覚的に示すための補助線,Grid(3×3)
                helper: buildGridHelper(aspectRatio),
                // child: Transform(
                //   transform: Matrix4.identity()
                //     ..translate(_offset.dx, _offset.dy) // 位置の変更
                //     ..rotateZ(_rotation), // 角度の変更
                child: Image.memory(
                  widget.imageData,
                  fit: BoxFit.cover,
                  // fit: OverflowBox,
                ),
                ),
              ),
            ),
          // ),
          // ),
        ],
      ),
    );
  }
}
