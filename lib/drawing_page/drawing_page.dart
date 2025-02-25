// import 'dart:typed_data';
// import 'dart:ui'as ui;
//
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
//
// import '../server_upload/select-photo-check_page.dart';
// import 'drawing_color-palette.dart';
// import 'drawing_drawing-space.dart';
//
// class DrawingPage extends StatefulWidget {
//   @override
//   _DrawingPageState createState() => _DrawingPageState();
// }
//
// class _DrawingPageState extends State<DrawingPage> {
//   final GlobalKey canvasKey = GlobalKey();//画像をキャプチャするため
//
//   int selectedRadio = 0;
//   double penThickness = 5;
//   // double _circleWidth = 45;
//   void _updateSelectedRadio(int newSelectedRadio){
//     setState((){
//       selectedRadio = newSelectedRadio;
//       ColorPalette.of(context).setSelectedColor(newSelectedRadio);
//     });
//   }
//   void _updateThickness(double newThickness){
//     setState((){
//       penThickness = newThickness;
//     });
//   }
//   //前画面に戻る際に描画画面をクリアする
//   void _resetDrawing() {
//     setState(() {
//       ColorPath.paths.clear();
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     final colorPalette = ColorPalette.of(context);
//     return Scaffold(
//             appBar: AppBar(
//               centerTitle: true,
//               leading: IconButton(
//                   icon: Icon(Icons.arrow_back),
//                   onPressed: () {
//                     _resetDrawing();
//                     Navigator.of(context).pop();
//                   }),
//               title: Text(
//                 'ぺイント',
//
//                 style: TextStyle(fontSize: 20, ),
//               ),
//               actions: [
//                 IconButton(
//                   icon: Icon(Icons.check_outlined, ),
//                   onPressed: () async {
//                     // // 画像をキャプチャしUint8Listに変換
//                     // Uint8List imageBytes = await _capturePng();
//                     Uint8List imageByte = await _capturePng();
//                     List<Uint8List> imageBytes = [imageByte];
//                     // 新しいページに画像データを渡す
//                      Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) =>
//                             // SelectCheck(imageData:imageBytes),
//                         SelectCheck(imageData:imageBytes),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//               // backgroundColor: Color(0xFFd7e8ff),
//             ),
//             body: Container(
//                 padding: EdgeInsets.fromLTRB(20,20,20,78),
//                 // color: Colors.green,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Color(0xFFE1E9FF), Colors.white],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                 ),
//                 child:
//
//                 ClipRect(
//                   child:Column(
//                 // child:
//                     children:[
//                     RepaintBoundary(
//                 key: canvasKey,
//                 child: Container(
//                   // color: Colors.greenAccent,
//                   //   margin: EdgeInsets.fromLTRB(20,20,20,80),
// child: Stack(
//     alignment: Alignment.bottomCenter,
//     children: [
//       // Container(color: Colors.red,height: 20,),
//     //   Expanded(
//     // child:
//     ColorPalette(
//                         notifier: ColorPaletteNotifier(),
//                         child: RepaintBoundary(
//                           child:SizedBox(
//                             // width:MediaQuery.of(context).size.width, // 画面の幅に合わせる
//                             // height:MediaQuery.of(context).size.height, // 画面の高さに合わせる
//                             height:(MediaQuery.of(context).size.height/1.4) , // 画面の高さに合わせる
//                             child:DrawingSpace(selectedRadio:selectedRadio),
//
//                           ),
//                         )),
//       // ),
//       // ColorPaletteSelect(),
//     ]),
//                 )),
//                       Container(
//                           color: Colors.greenAccent,
//                           width:MediaQuery.of(context).size.width,
//                           height:(MediaQuery.of(context).size.height/12),
//                         child: ColorPalette(
//                           notifier: ColorPaletteNotifier(),
//                           // child: RepaintBoundary(
//                           child:ColorPaletteSelect(selectedRadio:selectedRadio),
//                         ),
//                       ),
//                       // ),
// ])
//                 ))
//         // )
//     );
//   }
//   // 描画画面を画像としてキャプチャする
//   Future<Uint8List> _capturePng() async {
//     RenderRepaintBoundary boundary =
//     canvasKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
//     ui.Image image = await boundary.toImage();
//     ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
//     if (byteData != null) {
//       return byteData.buffer.asUint8List();
//     }
//     throw Exception('画像のキャプチャに失敗しました。');
//   }
// }
//
// class ColorPaletteSelect extends StatefulWidget {
//   final int selectedRadio;
//   ColorPaletteSelect({required this.selectedRadio});
//   @override
//   _ColorPaletteSelect createState() => _ColorPaletteSelect();
// // _ColorPaletteSelect createState() => _ColorPaletteSelect(selectedRadio);
// }
//
// class _ColorPaletteSelect extends State<ColorPaletteSelect> {
//   // int selectedRadio = 0;
//   // double penThickness = 5;
//   double _circleWidth = 45;
//   // int selectedRadio;
//   // _ColorPaletteSelect(this.selectedRadio);
//   //
//   // void _updateSelectedRadio(int newSelectedRadio){
//   //   setState((){
//   //     selectedRadio = newSelectedRadio;
//   //     ColorPalette.of(context).setSelectedColor(newSelectedRadio);
//   //   });
//   // }
//   // void _updateThickness(double newThickness){
//   //   setState((){
//   //     penThickness = newThickness;
//   //   });
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     final colorPalette = ColorPalette.of(context);
//     // ColorPale colorPalette = ColorPalette.of(context);
//     return Container(
//       color: Colors.orange,
//       width: MediaQuery
//           .of(context)
//           .size
//           .width,
//       height: 60,
//       child:
//       Padding(
//         padding: EdgeInsets.all(8),
//         child: Align(
//           alignment: Alignment.bottomRight,
//           child:
//           Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 for (var i = 0; i < colorPalette.colors.length; i++)
//                   GestureDetector(
//                     // onTap: selected ? null : () => colorPalette.select(i),
//                     // onTap: () => colorPalette.setSelectedColor(i),
//                     onTap: (){
//
//                       colorPalette.setSelectedColor(i);
//                       // print("Color changed to: ${colorPalette.colors[i]}");
//
//                       },
//
//                     child: Container(
//                       width: _circleWidth,
//                       height: _circleWidth,
//                       transformAlignment: Alignment.center,
//                       // transform: selected ? _transform : null,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         // color: ColorHelper.hueToColor(index),
//                         color: colorPalette.colors[i],
//                         border: Border.all(
//                           color: Colors.black54,
//                           width: 6,
//                         ),
//                       ),
//                     ),
//                   ),
//               ]),
//         ),
//       ),
//     );
//   }
// }
//
//
//
// class ColorPath {
//   final Path path = Path();
//   final Color color;
//   final double strokeWidth;
//
//   ColorPath(this.color,this.strokeWidth);
//
//   static List<ColorPath> paths = [];
//   // ドローイングの開始点を設定
//   void setFirstPoint(Offset point) {
//     path.moveTo(point.dx, point.dy);
//   }
//   // パスに新しい点を追加
//   void updatePath(Offset point) {
//     path.lineTo(point.dx, point.dy);
//   }
// }
//
// class ColorPaletteNotifier extends ChangeNotifier {
//   List<Color> colors = [
//     Colors.black,
//     Color(0XFF00FF00),//green
//     Color(0xFFFFFFFF),//white
//     Color(0XFF0000FF),//blue
//     Color(0XFFFF0000),//red
//     Color(0XFFFFFF00),//yellow
//     Color(0XFFFF8000),//orange
//   ];
//
//
//
//   int selectedIndexRadio = 0;
//
//   int get selectedIndex => selectedIndexRadio; // 選択された色のインデックスを取得するゲッター
//   Color get selectedColor => colors[selectedIndexRadio];// 選択された色を取得するゲッター
//
//   void setSelectedColor(int index) {
//     if (index >= 0 && index < colors.length) {
//       selectedIndexRadio = index;
//       // Provider.of<DrawingSettings>(context).selectedColor;
//       // print("Color changed to: ${colors[selectedIndexRadio]}"); // デバッグ出力
//       notifyListeners();
//     }
//   }
//   void changeColor(Color newColor) {
//     colors[selectedIndex] = newColor;
//     notifyListeners();
//   }
//   void select(int index) {
//     selectedIndexRadio = index;
//     notifyListeners();
//   }
//
//   void rebuild() {
//     notifyListeners();
//   }
//
//
// }
//
//
// class ColorHelper {
//   static Color hueToColor(double hueValue) =>
//       HSVColor.fromAHSV(1.0, hueValue, 1.0, 1.0).toColor();
//
//   static double colorToHue(Color color) => HSVColor.fromColor(color).hue;
// }
// //------------------------------------------------------------------------------

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../app_body_color.dart';
import '../server_upload/select-photo-check_page.dart';
import 'drawing_color-palette.dart';
import 'drawing_drawing-space.dart';

class DrawingPage extends StatefulWidget {
  const DrawingPage({super.key});

  @override
  State<DrawingPage> createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  final GlobalKey canvasKey = GlobalKey(); //画像をキャプチャするため

  int selectedRadio = 0;
  double penThickness = 5;
  //前画面に戻る際に描画画面をクリアする
  void _resetDrawing() {
    setState(() {
      ColorPath.paths.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              _resetDrawing();
              Navigator.of(context).pop();
            }),
        title: const Text(
          '絵を描いて登録',
          style: TextStyle(
            // fontSize: 17,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_outlined),
            onPressed: () async {
              // // 画像をキャプチャしUint8Listに変換
              Uint8List imageByte = await _capturePng();
              List<Uint8List> imageBytes = [imageByte];
              // 新しいページに画像データを渡す
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SelectCheck(imageData: imageBytes),
                ),
              );
            },
          ),
        ],
      ),

      //カラーパレット→色選択
      body: ColorPalette(
        notifier: ColorPaletteNotifier(),
        child: CustomPaint(
          painter: HexagonPainter(),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 60),
            child: ClipRect(
              child: Column(children: [
                RepaintBoundary(
                  key: canvasKey,
                  child: Expanded(
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size
                          .height * 0.7,//0.75×
                      // height: (MediaQuery.of(context).size.height /
                      //     1.448), // 画面の高さに合わせる
                      // 1.4), // 画面の高さに合わせる
                      child: DrawingSpace(selectedRadio: selectedRadio),
                    ),
                  ),
                ),
                Container(
                  color: Colors.greenAccent,
                  width: MediaQuery
                      .of(context).size.width,
                  height: MediaQuery
                      .of(context).size.height / 18,
                  child: ColorPaletteSelect(selectedRadio: selectedRadio),
                ),
              ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 描画画面を画像としてキャプチャする
  Future<Uint8List> _capturePng() async {
    RenderRepaintBoundary boundary =
        canvasKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData != null) {
      return byteData.buffer.asUint8List();
    }
    throw Exception('画像のキャプチャに失敗しました。');
  }
}

class ColorPaletteSelect extends StatefulWidget {
  final int selectedRadio;
  const ColorPaletteSelect({super.key, required this.selectedRadio});
  @override
  State<ColorPaletteSelect> createState() => _ColorPaletteSelect();
}

class _ColorPaletteSelect extends State<ColorPaletteSelect> {
  final double _circleWidth = 45;

  @override
  Widget build(BuildContext context) {
    final colorPalette = ColorPalette.of(context);
    return Container(
      color: Colors.orange,
      width: MediaQuery.of(context).size.width,
      height: 80,
      child: Padding(
        padding: const EdgeInsets.all(5),//17
        child: Align(
          alignment: Alignment.bottomRight,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,//rowの幅を最小化
              children: [
            for (var i = 0; i < colorPalette.colors.length; i++)
              ColorCircle(index: i, width: _circleWidth)
          ]),
        ),
      ),
    );
  }
}


class ColorPath {
  final Path path = Path();
  late final Color color;
  final double strokeWidth;

  ColorPath(this.color, this.strokeWidth);

  static List<ColorPath> paths = [];
  // ドローイングの開始点を設定
  void setFirstPoint(Offset point) {
    path.moveTo(point.dx, point.dy);
  }

  // パスに新しい点を追加
  void updatePath(Offset point) {
    path.lineTo(point.dx, point.dy);
  }

  void changeColor(Color newColor) {
    color = newColor;
  }
}

class ColorPaletteNotifier extends ChangeNotifier {
  List<Color> colors = [
    const Color(0xff000000), //black
    const Color(0XFF00FF00), //green
    const Color(0xFFFFFFFF), //white
    const Color(0XFF0000FF), //blue
    const Color(0XFFFF0000), //red
    const Color(0XFFFFFF00), //yellow
    const Color(0XFFFF8000), //orange
  ];


  int selectedIndexRadio = 0;

  int get selectedIndex => selectedIndexRadio; // 選択された色のインデックスを取得するゲッター
  Color get selectedColor => colors[selectedIndexRadio]; // 選択された色を取得するゲッター

  void setSelectedColor(int index) {
    if (index >= 0 && index < colors.length) {
      selectedIndexRadio = index;
      notifyListeners();
    }
  }

  void changeColor(Color newColor) {
    colors[selectedIndex] = newColor;
    notifyListeners();
  }

  void select(int index) {
    selectedIndexRadio = index;
    notifyListeners();
  }

  void rebuild() {
    notifyListeners();
  }
}

class ColorHelper {
  static Color hueToColor(double hueValue) =>
      HSVColor.fromAHSV(1.0, hueValue, 1.0, 1.0).toColor();

  static double colorToHue(Color color) => HSVColor.fromColor(color).hue;
}

class ColorCircle extends StatelessWidget {
  final int index;
  final double width;

  const ColorCircle({
    Key? key,
    required this.index,
    required this.width,
  }) : super(key: key);

  static final Matrix4 _transform = Matrix4.identity()..scale(1.4);

  @override
  Widget build(BuildContext context) {
    final colorPallete = ColorPalette.of(context);
    final selected = colorPallete.selectedIndex == index;

    return GestureDetector(
      onTap: selected ? null : () => colorPallete.select(index),
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(
          begin: 0,
          end: ColorHelper.colorToHue(colorPallete.colors[index]),
        ),
        duration: const Duration(milliseconds: 10),
        builder: (context, value, child) {
          return Container(
            width: width*0.85,
            height: width*0.85,
            transformAlignment: Alignment.center,
            transform: selected ? _transform : null,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorPallete.colors[index],
              border: Border.all(
                color: selected ? Colors.black54 : Colors.white70,
                width: 6,
              ),
            ),
          );
        },
      ),
    );
  }
}
