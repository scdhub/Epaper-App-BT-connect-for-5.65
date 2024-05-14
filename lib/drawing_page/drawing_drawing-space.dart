import 'package:flutter/material.dart';

import 'drawing_canvas-area.dart';
import 'drawing_color-palette.dart';

class DrawingSpace extends StatefulWidget {
  final int selectedRadio;
  DrawingSpace({required this.selectedRadio});
  @override
  _DrawingSpaceState createState() => _DrawingSpaceState();
}

class _DrawingSpaceState extends State<DrawingSpace> {
  // // int selectedRadio = 0;
  double penThickness = 5;
  double _circleWidth = 45;
  // void _updateSelectedRadio(int newSelectedRadio){
  //   setState((){
  //     widget.selectedRadio = newSelectedRadio;
  //     ColorPalette.of(context).setSelectedColor(newSelectedRadio);
  //   });
  // }
  // void _updateThickness(double newThickness){
  //   setState((){
  //     penThickness = newThickness;
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    final colorPalette = ColorPalette.of(context);
    return Container(
      // key: canvasKey,
      // padding: EdgeInsets.all(8),
      color: Colors.grey,
      // margin: EdgeInsets.all(20),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CanvasArea(
              // selectedRadio:widget.selectedRadio,
              changeThickness:penThickness),
          Container(
            color: Colors.orange,
            width:MediaQuery.of(context).size.width,
            height: 60,
            child:
          Padding(
            padding: EdgeInsets.all(8),
            child: Align(
              alignment: Alignment.bottomRight,
              child:
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    for (var i = 0; i < colorPalette.colors.length; i++)
                      GestureDetector(
                        // onTap: selected ? null : () => colorPalette.select(i),
                        onTap: () => colorPalette.setSelectedColor(i),
                        child: Container(
                          width: _circleWidth,
                          height: _circleWidth,
                          transformAlignment: Alignment.center,
                          // transform: selected ? _transform : null,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            // color: ColorHelper.hueToColor(index),
                            color: colorPalette.colors[i],
                            border: Border.all(
                              color:  Colors.black54,
                              width: 6,
                            ),
                          ),
                        ),
                      ),
                  ]),
            ),
          ),
          ),
        ],
      ),
    );
  }
}

// class ColorPaletteSelect extends StatefulWidget {
//   final int selectedRadio;
//   ColorPaletteSelect({required this.selectedRadio});
//   @override
//   _ColorPaletteSelect createState() => _ColorPaletteSelect();
//   // _ColorPaletteSelect createState() => _ColorPaletteSelect(selectedRadio);
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
//                 for(var i = 0; i < colorPalette.colors.length; i++)
//                   GestureDetector(
//                     // onTap: selected ? null : () => colorPallete.select(i),
//                     // onTap: () => colorPalette.setSelectedColor(i),
//                     onTap: () {
//                       // colorPalette.setSelectedColor(i);
//                       setState(() {
//                         colorPalette.setSelectedColor(i);
//                       });
//                       },
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
//     }
// }


/*
*
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
          CanvasArea(selectedRadio:selectedRadio,changeThickness:penThickness),
          Padding(
            padding: EdgeInsets.all(8),
            child: Align(
              alignment: Alignment.bottomRight,
              child:
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    for (var i = 0; i < colorPallete.colors.length; i++)
                      GestureDetector(
                        // onTap: selected ? null : () => colorPallete.select(i),
                        onTap: () => colorPallete.setSelectedColor(i),
                        child: Container(
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
                      ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
* */