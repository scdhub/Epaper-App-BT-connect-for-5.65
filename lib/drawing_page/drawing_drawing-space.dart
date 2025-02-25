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
      child: Column(
        children: [
          //キャンバスエリアの指定
          SizedBox(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.7,
            child: CanvasArea(changeThickness: penThickness),
          ),
        ],
      ),
    );
  }
}

      // width: double.infinity,
      // height: MediaQuery.of(context).size.height * 0.7,

      // child: Stack(
      //   alignment: Alignment.bottomCenter,
      //
      // ),
//     );
//   }
// }
