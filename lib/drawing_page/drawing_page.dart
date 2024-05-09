import 'dart:typed_data';
import 'dart:ui'as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../select-photo-check_page.dart';
import 'drawing_color-pallete.dart';
import 'drawing_drawing-space.dart';

class DrawingPage extends StatefulWidget {
  @override
  _DrawingPageState createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  final GlobalKey canvasKey = GlobalKey();//画像をキャプチャするため

  //前画面に戻る際に描画画面をクリアする
  void _resetDrawing() {
    setState(() {
      ColorPath.paths.clear();
    });
  }
  @override
  Widget build(BuildContext context) {
    // final colorPallete = ColorPallete.of(context);
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    _resetDrawing();
                    Navigator.of(context).pop();
                  }),
              title: Text(
                'ペイント',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.save, color: Colors.white),
                  onPressed: () async {
                    // // 画像をキャプチャしUint8Listに変換
                    // Uint8List imageBytes = await _capturePng();
                    Uint8List imageByte = await _capturePng();
                    List<Uint8List> imageBytes = [imageByte];
                    // 新しいページに画像データを渡す
                     Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            // SelectCheck(imageData:imageBytes),
                        SelectCheck(imageData:imageBytes),
                      ),
                    );
                  },
                ),
              ],
              backgroundColor: Color(0xFF0080FF),
            ),
            body: Container(
                padding: EdgeInsets.fromLTRB(20,20,20,80),
                color: Colors.green,
                child:

                ClipRect(
                child:RepaintBoundary(
                key: canvasKey,
                child: Container(
                  // color: Colors.greenAccent,
                  //   margin: EdgeInsets.fromLTRB(20,20,20,80),
child: Stack(
    alignment: Alignment.bottomCenter,
                    // child:
    children: [
      Container(color: Colors.red,height: 20,),
    ColorPallete(
                        notifier: ColorPalleteNotifier(),
                        child: RepaintBoundary(
                          child:SizedBox(
                            // width:MediaQuery.of(context).size.width, // 画面の幅に合わせる
                            // height:MediaQuery.of(context).size.height, // 画面の高さに合わせる
                            // height:(MediaQuery.of(context).size.height/2) , // 画面の高さに合わせる
                            child:DrawingSpace(),

                          ),
                        )),

    ]),
                ))))));
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





class ColorPath {
  final Path path = Path();
  final Color color;
  final double strokeWidth;

  ColorPath(this.color,this.strokeWidth);

  static List<ColorPath> paths = [];
  // ドローイングの開始点を設定
  void setFirstPoint(Offset point) {
    path.moveTo(point.dx, point.dy);
  }
  // パスに新しい点を追加
  void updatePath(Offset point) {
    path.lineTo(point.dx, point.dy);
  }
}

class ColorPalleteNotifier extends ChangeNotifier {
  List<Color> colors = [
    Colors.black,
    Color(0XFF00FF00),//green
    Color(0xFFFFFFFF),//white
    Color(0XFF0000FF),//blue
    Color(0XFFFF0000),//red
    Color(0XFFFFFF00),//yellow
    Color(0XFFFF8000),//orange
  ];



  int selectedIndexRadio = 0;

  int get selectedIndex => selectedIndexRadio; // 選択された色のインデックスを取得するゲッター
  Color get selectedColor => colors[selectedIndexRadio];// 選択された色を取得するゲッター

  void setSelectedColor(int index) {
    if (index >= 0 && index < colors.length) {
      selectedIndexRadio = index;
      // Provider.of<DrawingSettings>(context).selectedColor;
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

// class drawingSetting extends StatefulWidget {
//   final Function(int) changeRadio;
//   final Function(double) changeThickness;
//   drawingSetting({required this.changeRadio,required this.changeThickness});
//   @override
//   _drawingSettingState createState() => _drawingSettingState();
// }
//
// class _drawingSettingState extends State<drawingSetting> {
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('設定', textAlign: TextAlign.center),
//       content: Container(
//         width: 200,
//         height: 300,
//         child: Column(
//           children: [
//             drawingColor(colorChange:widget.changeRadio),
//             Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
//               Text('ペンの太さ:'),
//               DrawingSize(thicknessChange:widget.changeThickness),
//             ]),
//           ],
//         ),
//       ),
//       actions: <Widget>[
//         Divider(),
//         Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, 'Cancel'),
//             child: const Text('キャンセル'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(
//                   context, 'OK');
//             },
//             child: const Text('決定'),
//           ),
//         ])
//       ],
//     );
//   }
// }

// enum SingingCharacter { lafayette, jefferson }

// class drawingColor extends StatefulWidget {
//
//   final Function(int) colorChange;
//   drawingColor({required this.colorChange});
//   @override
//   _drawingColorState createState() => _drawingColorState();
// }

// class _drawingColorState extends State<drawingColor> {
//
//   int _value = 0;
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: <Widget>[
// Row(
//           children: [
//             Column(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Radio<int>(
//                   value: 0,
//                   groupValue: _value,
//                   onChanged: (int? value) {
//                     setState(() {
//                       if (value != null) {
//                         _value = value;
//                         widget.colorChange(value);
//                       }
//                     });
//                   },
//
//                 ),
//                 // SizedBox(width: 10.0),
//                 Text('黒ペン'),
//                 Radio<int>(
//                   value: 1,
//                   groupValue: _value,
//
//                   onChanged: (int? value) {
//                     setState(() {
//                       if (value != null) {
//                         _value = value;
//                         widget.colorChange(value);
//                       }
//                     });
//                   },
//                 ),
//                 // SizedBox(width: 10.0),
//                 Text('赤ペン'),
//                 Radio<int>(
//                   value: 2,
//                   groupValue: _value,
//                   onChanged: (int? value) {
//                     setState(() {
//                       if (value != null) {
//                         _value = value;
//                         widget.colorChange(value);
//                       }
//                     });
//                   },
//
//                 ),
//                 // SizedBox(width: 10.0),
//                 Text('緑'),
//               ],
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

// //-------------------------------------------
// double penThickness = 5;
//
// // StatelessWidgetをStatefulWidgetに変更する
// class DrawingSize extends StatefulWidget {
//   final Function(double) thicknessChange;
//   DrawingSize({required this.thicknessChange});
//   @override
//   _DrawingSizeState createState() => _DrawingSizeState();
// }
//
// class _DrawingSizeState extends State<DrawingSize> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         width: 100,
//         height: 50,
//         child: Column(
//             children: [
//               DropdownButton<double>(
//                 items: const [
//                   DropdownMenuItem(
//                     value: 5,
//                     child: Text('5'),
//                   ),
//                   DropdownMenuItem(
//                     value: 10,
//                     child: Text('10'),
//                   ),
//                   DropdownMenuItem(
//                     value: 15,
//                     child: Text('15'),
//                   ),
//                   DropdownMenuItem(
//                     value: 20,
//                     child: Text('20'),
//                   ),
//                   DropdownMenuItem(
//                     value: 25,
//                     child: Text('25'),
//                   ),
//                 ],
//                 value: penThickness,
//                 onChanged: (double? value) {
//                   setState(() {
//                     penThickness = value!;
//                     widget.thicknessChange(value);
//                     // Provider.of<PathPainter>(context, listen: false)
//                     //     .setStrokeWidth(double.parse(isSelectedValue));
//                   });
//                 },
//                 isExpanded: true,
//                 style: TextStyle(fontSize: 12, color: Colors.black),
//               ),
//             ])
//     );
//   }
// }
