import 'package:flutter/material.dart';

import 'drawing_canvas-area.dart';
class DrawingSpace extends StatefulWidget {
  final int selectedRadio;
  DrawingSpace({required this.selectedRadio});
  @override
  _DrawingSpaceState createState() => _DrawingSpaceState();
}

class _DrawingSpaceState extends State<DrawingSpace> {
  double penThickness = 5;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CanvasArea(
              changeThickness:penThickness),
        ],
      ),
    );
  }
}
