import 'package:flutter/material.dart';

import 'drawing_canvas-area.dart';

class DrawingSpace extends StatefulWidget {
  final int selectedRadio;
  const DrawingSpace({super.key, required this.selectedRadio});
  @override
  State<DrawingSpace> createState() => _DrawingSpaceState();
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
          CanvasArea(changeThickness: penThickness),
        ],
      ),
    );
  }
}
