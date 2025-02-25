import 'dart:developer';

import 'package:flutter/material.dart';

import 'drawing_color-palette.dart';
import 'drawing_page.dart';
import 'drawing_path-painter.dart';

class CanvasArea extends StatefulWidget {
  // final int selectedRadio;//DrawingSpace空のデータ渡し
  final double changeThickness; //DrawingSpace空のデータ渡し
  const CanvasArea(
      {super.key,
      // required this.selectedRadio,
      required this.changeThickness});
  @override
  State<CanvasArea> createState() => _CanvasAreaState();
}

class _CanvasAreaState extends State<CanvasArea> {
  late ColorPath _colorPath;

//ドラック開始の処理
  void _onPanStart(DragStartDetails details) {
    //色を変えた時更新
    _colorPath = ColorPath(
        ColorPalette
            .of(context)
            .selectedColor, widget.changeThickness);
    _colorPath.setFirstPoint(details.localPosition);
  }

  //ドラック中の処理(追加：キャンバス外にペイントしないようにする。
  // 描画エリア外にスワイプしたときに制限できていない→描画外に記載可能（問題）→修正
  void _onPanUpdate(DragUpdateDetails details) {
    final double maxHeight = MediaQuery
        .of(context).size.height * 0.7; // キャンバスの最大高さ、0.65ですると×

    if (details.localPosition.dy < maxHeight) { // カラーパレットより下には描画させない
      _colorPath.updatePath(details.localPosition);
      setState(() {});
    }
  }// _colorPath.updatePath(details.localPosition);
    // setState(() {});

  void _onPanEnd(DragEndDetails details) {
    if (_colorPath.path != null) {
      ColorPath.paths.add(_colorPath);
      setState(() {}); // ★ ここで更新をかける
    }
  }
    // ColorPath.paths.add(_colorPath);
    // setState(() {
      // _colorPath = ColorPath(ColorPallete.of(context).selectedColor, widget.changeThickness);
    // });

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // データが変更されたときにパスを更新
    _colorPath = ColorPath(
        ColorPalette
            .of(context)
            .selectedColor, widget.changeThickness);
  }

  @override
  Widget build(BuildContext context) {
    // return GestureDetector(
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.65, // 高さを65%に設定
      child: GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: Stack(
          children: [
            for (final colorPath in ColorPath.paths)
              CustomPaint(
                size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height * 0.65),
                painter: PathPainter(colorPath, widget.changeThickness),
                // size: Size.infinite,
                // //すでに描いた描画を保持
                // painter: PathPainter(colorPath, widget.changeThickness),
              ),
            CustomPaint(
              size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height * 0.65),
              painter: PathPainter(_colorPath, widget.changeThickness),
              // size: Size.infinite,
              // //描画を開始したときに新しく作成
              // painter: PathPainter(_colorPath, widget.changeThickness),
            ),
          ],
        ),
      ),
    );
  }
}
