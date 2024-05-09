

import 'package:flutter/material.dart';

import 'drawing_color-pallete.dart';
import 'drawing_page.dart';
import 'drawing_path-painter.dart';

class CanvasArea extends StatefulWidget {
  final int selectedRadio;//DrawingSpace空のデータ渡し
  final double changeThickness;//DrawingSpace空のデータ渡し
  CanvasArea({required this.selectedRadio,required this.changeThickness});
  @override
  _CanvasAreaState createState() => _CanvasAreaState();
}

class _CanvasAreaState extends State<CanvasArea> {
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