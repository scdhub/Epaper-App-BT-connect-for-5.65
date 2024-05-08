import 'dart:typed_data';
import 'dart:ui'as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'select-photo-check_page.dart';

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
                padding: EdgeInsets.all(20),
                color: Colors.green,
                child:ClipRect(
                child:RepaintBoundary(
                key: canvasKey,
                child: Container(
                  // color: Colors.greenAccent,

                    child: ColorPallete(
                        notifier: ColorPalleteNotifier(),
                        child: RepaintBoundary(
                          child:SizedBox(
                            width:MediaQuery.of(context).size.width, // 画面の幅に合わせる
                            height:MediaQuery.of(context).size.height, // 画面の高さに合わせる
                            child: DrawingSpace(),
                          ),
                        ))))))));
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

class canvasArea extends StatefulWidget {
  final int selectedRadio;//DrawingSpace空のデータ渡し
  final double changeThickness;//DrawingSpace空のデータ渡し
  canvasArea({required this.selectedRadio,required this.changeThickness});
  @override
  _canvasAreaState createState() => _canvasAreaState();
}

class _canvasAreaState extends State<canvasArea> {
  late ColorPath _colorPath;
//ドラック開始の処理
  void _onPanStart(DragStartDetails details) {
    //色を変えた時更新
    _colorPath = ColorPath(ColorPallete.of(context).selectedColor, widget.changeThickness);
    _colorPath.setFirstPoint(details.localPosition);
  }
  //ドラック中の処理
  void _onPanUpdate(DragUpdateDetails details) {
    _colorPath.updatePath(details.localPosition);
    setState(() {});
  }
  void _onPanEnd(DragEndDetails details) {
    ColorPath.paths.add(_colorPath);
    setState(() {
      // _colorPath = ColorPath(ColorPallete.of(context).selectedColor, widget.changeThickness);
    });
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // データが変更されたときにパスを更新
    _colorPath = ColorPath(ColorPallete.of(context).selectedColor, widget.changeThickness);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: Stack(
        children: [
          for (final colorPath in ColorPath.paths)
            CustomPaint(
              size: Size.infinite,
              //すでに描いた描画を保持
              painter: PathPainter(colorPath,widget.changeThickness),
            ),
          CustomPaint(
            size: Size.infinite,
            //描画を開始したときに新しく作成
            painter: PathPainter(_colorPath, widget.changeThickness),
          ),
        ],
      ),
    );
  }
}

class PathPainter extends CustomPainter {
  final ColorPath colorPath;
  final double strokeWidth;
  PathPainter(this.colorPath,this.strokeWidth);

  Paint paintBrush(Color color){
    return Paint()
      ..strokeCap = StrokeCap.round//線の端を丸く
      ..isAntiAlias = true//アンチエイリアスを有効
      ..color = colorPath.color//描画色の設定
    // ..strokeWidth = strokeWidth
      ..strokeWidth = colorPath.strokeWidth//線の太さ設定
      ..style = PaintingStyle.stroke;//スタイルを線に設定
  }
  // キャンバスにパスを描画
  @override
  void paint(Canvas canvas, Size size) {
    final currentColor = colorPath.color;
    // canvas.drawPath(colorPath.path, paintBrush);
    canvas.drawPath(colorPath.path, paintBrush(currentColor));
  }

  @override
  bool shouldRepaint(PathPainter old) {

    return true;
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

class ColorPallete extends InheritedNotifier<ColorPalleteNotifier> {
  const ColorPallete({
    Key? key,
    required ColorPalleteNotifier notifier,
    required Widget child,
  }) : super(key: key, notifier: notifier, child: child);

  static ColorPalleteNotifier of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ColorPallete>()!
        .notifier!;
  }
}

class DrawingSpace extends StatefulWidget {
  @override
  _DrawingSpaceState createState() => _DrawingSpaceState();
}

class _DrawingSpaceState extends State<DrawingSpace> {
  int selectedRadio = 0;
  double penThickness = 5;
   double _circleWidth = 45;
  void _updateSelectedRadio(int newSelectedRadio){
    setState((){
      selectedRadio = newSelectedRadio;
      ColorPallete.of(context).setSelectedColor(newSelectedRadio);
    });
  }
  void _updateThickness(double newThickness){
    setState((){
      penThickness = newThickness;
    });
  }
  @override
  Widget build(BuildContext context) {
    final colorPallete = ColorPallete.of(context);
    return Container(
      // key: canvasKey,
      // padding: EdgeInsets.all(8),
      color: Colors.grey,
      // margin: EdgeInsets.all(20),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          canvasArea(selectedRadio:selectedRadio,changeThickness:penThickness),
          Padding(
            padding: EdgeInsets.all(8),
            child: Align(
              alignment: Alignment.bottomRight,
              child:
              // OutlinedButton(
              //   style: OutlinedButton.styleFrom(
              //     minimumSize: Size(50, 50), //サイズ
              //     backgroundColor: Colors.white,
              //     shape: CircleBorder(), //円
              //   ),
              //   child: Icon(Icons.settings),
              //   onPressed: () {
              //     showDialog(
              //       context: context,
              //       builder: (BuildContext context) => drawingSetting(
              //           changeRadio:_updateSelectedRadio,
              //           changeThickness:_updateThickness
              //       ),
              //     );
              //   },
              // ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    for (var i = 0; i < colorPallete.colors.length; i++)
                GestureDetector(
                // onTap: selected ? null : () => colorPallete.select(i),
                  onTap: () => colorPallete.setSelectedColor(i),
      child:
      // TweenAnimationBuilder<double>(
      //   tween: Tween<double>(
      //     begin: 0,
      //     end: ColorHelper.colorToHue(colorPallete.colors[i]),
      //   ),
      //   duration: const Duration(milliseconds: 600),
      //   builder: (context, value, child) {
      //     return
            Container(
            width: _circleWidth,
            height: _circleWidth,
            transformAlignment: Alignment.center,
            // transform: selected ? _transform : null,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
    // color: ColorHelper.hueToColor(index),
    color: colorPallete.colors[i],
              border: Border.all(
                color:  Colors.black54,
                width: 6,
              ),
            ),
          ),
      //   },
      // ),
    ),
              // Container(
              //   width:_circleWidth,
              //   height: _circleWidth,
              //   decoration:BoxDecoration(
              //     shape: BoxShape.circle,
              //     color:ColorHelper.hueToColor(value),
              //     border: Border.all(
              //       // color: selected ? Colors.black54 : Colors.white70,
              //       color:Colors.black54,
              //       width: 6,
              //     ),
              //   ),
              // ),

            ]),
            ),
          ),
        ],
      ),
    );
  }
}

class ColorHelper {
  static Color hueToColor(double hueValue) =>
      HSVColor.fromAHSV(1.0, hueValue, 1.0, 1.0).toColor();

  static double colorToHue(Color color) => HSVColor.fromColor(color).hue;
}

class drawingSetting extends StatefulWidget {
  final Function(int) changeRadio;
  final Function(double) changeThickness;
  drawingSetting({required this.changeRadio,required this.changeThickness});
  @override
  _drawingSettingState createState() => _drawingSettingState();
}

class _drawingSettingState extends State<drawingSetting> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('設定', textAlign: TextAlign.center),
      content: Container(
        width: 200,
        height: 300,
        child: Column(
          children: [
            drawingColor(colorChange:widget.changeRadio),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Text('ペンの太さ:'),
              DrawingSize(thicknessChange:widget.changeThickness),
            ]),
          ],
        ),
      ),
      actions: <Widget>[
        Divider(),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(
                  context, 'OK');
            },
            child: const Text('決定'),
          ),
        ])
      ],
    );
  }
}

// enum SingingCharacter { lafayette, jefferson }

class drawingColor extends StatefulWidget {

  final Function(int) colorChange;
  drawingColor({required this.colorChange});
  @override
  _drawingColorState createState() => _drawingColorState();
}

class _drawingColorState extends State<drawingColor> {

  int _value = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Radio<int>(
                  value: 0,
                  groupValue: _value,
                  onChanged: (int? value) {
                    setState(() {
                      if (value != null) {
                        _value = value;
                        widget.colorChange(value);
                      }
                    });
                  },

                ),
                // SizedBox(width: 10.0),
                Text('黒ペン'),
                Radio<int>(
                  value: 1,
                  groupValue: _value,

                  onChanged: (int? value) {
                    setState(() {
                      if (value != null) {
                        _value = value;
                        widget.colorChange(value);
                      }
                    });
                  },
                ),
                // SizedBox(width: 10.0),
                Text('赤ペン'),
                Radio<int>(
                  value: 2,
                  groupValue: _value,
                  onChanged: (int? value) {
                    setState(() {
                      if (value != null) {
                        _value = value;
                        widget.colorChange(value);
                      }
                    });
                  },

                ),
                // SizedBox(width: 10.0),
                Text('緑'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

//-------------------------------------------
double penThickness = 5;

// StatelessWidgetをStatefulWidgetに変更する
class DrawingSize extends StatefulWidget {
  final Function(double) thicknessChange;
  DrawingSize({required this.thicknessChange});
  @override
  _DrawingSizeState createState() => _DrawingSizeState();
}

class _DrawingSizeState extends State<DrawingSize> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 100,
        height: 50,
        child: Column(
            children: [
              DropdownButton<double>(
                items: const [
                  DropdownMenuItem(
                    value: 5,
                    child: Text('5'),
                  ),
                  DropdownMenuItem(
                    value: 10,
                    child: Text('10'),
                  ),
                  DropdownMenuItem(
                    value: 15,
                    child: Text('15'),
                  ),
                  DropdownMenuItem(
                    value: 20,
                    child: Text('20'),
                  ),
                  DropdownMenuItem(
                    value: 25,
                    child: Text('25'),
                  ),
                ],
                value: penThickness,
                onChanged: (double? value) {
                  setState(() {
                    penThickness = value!;
                    widget.thicknessChange(value);
                    // Provider.of<PathPainter>(context, listen: false)
                    //     .setStrokeWidth(double.parse(isSelectedValue));
                  });
                },
                isExpanded: true,
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
            ])
    );
  }
}
