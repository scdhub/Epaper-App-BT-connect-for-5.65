import 'package:flutter/material.dart';

import 'drawing_page.dart';

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