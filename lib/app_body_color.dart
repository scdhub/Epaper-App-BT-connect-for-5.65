

import 'dart:math';

import 'package:flutter/material.dart';

//無数の正六角形を描画
class HexagonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // グラデーション設定。
    final Gradient gradient = LinearGradient(
      colors: [Colors.white, Colors.black],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: [0.1,1.0,]
    );

    // 着色定義
    final paint = Paint()
      ..shader = gradient.createShader(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 3,
      ))
      ..style = PaintingStyle.fill;

    // 正六角形のサイズ
    final double radius = 10.0;
    // 正六角形の辺の長さ
    final double sideLength = radius * sqrt(3);
    // 正六角形の高さ
    final double hexHeight = sideLength * sqrt(3) / 2;
    // 正六角形の幅
    final double hexWidth = sideLength * 17 / 10;

    // 画面全体に正六角形を描画する
    for (double y = 0; y < size.height; y += hexHeight * 0.59) {

      double offsetX = y % (hexHeight * 1.17) < hexHeight * 0.59 ? 0 : hexWidth / 2;
      for (double x = 0; x < size.width; x += hexWidth) {
        drawHexagon(canvas, paint, x + offsetX, y, radius);
      }
    }
  }

  // 正六角形を描画するメソッド
  void drawHexagon(Canvas canvas, Paint paint, double centerX, double centerY, double radius) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      // 正六角形の各頂点の角度
      double angle = 2 * pi / 6 * i;
      // 角度から頂点の座標を計算
      final pointX = centerX + radius * cos(angle);
      final pointY = centerY + radius * sin(angle);
      if (i == 0) {
        // 最初の頂点でパスを開始
        path.moveTo(pointX, pointY);
      } else {
        // 次の頂点にラインを描画
        path.lineTo(pointX, pointY);
      }
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}