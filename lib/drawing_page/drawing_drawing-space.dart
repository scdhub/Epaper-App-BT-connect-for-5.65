import 'package:flutter/material.dart';

import 'drawing_canvas-area.dart';
import 'drawing_color-pallete.dart';

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
          CanvasArea(selectedRadio:selectedRadio,changeThickness:penThickness),
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