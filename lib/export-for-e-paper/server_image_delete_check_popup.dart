import 'package:flutter/material.dart';



class ImageTypeSelection_popup extends StatefulWidget {//top_pageから遷移
  const ImageTypeSelection_popup({super.key});

  @override
  _ImageTypeSelection_popupState createState() =>
      _ImageTypeSelection_popupState();
}

class _ImageTypeSelection_popupState extends State<ImageTypeSelection_popup> {
  var _selectedIndex = 1; // ラジオボタンの選択値を親ウィジェットで管理する

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      backgroundColor:Colors.white,
      title:
      // Text('スマホから画像を\nインポート方法選択',
      Text('方法選択',
        textAlign: TextAlign.center,
      ),
      // content: TypeSelectedRadio(
      //   // コールバック関数を渡す
      //   onSelected: (value) {
      //     setState(() {
      //       _selectedIndex = value;
      //     });
      //   },
      // ),
      actions: <Widget>[
        //     content: Container(
        //     width: MediaQuery.of(context).size.width, // 画面幅の90%に設定
        // child: Column(
        // children: [
        //   Text('スマホから画像を\nインポート方法選択',
        //     textAlign: TextAlign.center,
        //   ),
        Column(
            children: [
              Row(

                // mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:[

                    Container(
                      // color: Colors.greenAccent,
                      width: 140,
                      height: 100,
                      // padding: ,
                      child:

                      ElevatedButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.greenAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                        onPressed: () {
                          getImageFromCamera(context);
                        },
                        child:
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // IconButton(
                              //   icon:
                              Icon(
                                Icons.camera_alt_outlined,
                                size: 40.0,),
                              //   onPressed:(){
                              //     getImageFromCamera(context);
                              // },
                              // ),
                              Text(
                                ' 撮影して\n写真を登録',
                              ),
                            ]),
                      ),
                    ),

                    Container(
                      // color: Colors.cyan,
                      width: 140,
                      height: 100,
                      child:

                      ElevatedButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.cyan,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ImageSelect_Album()),
                          );
                        },
                        child:
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // IconButton(
                              //   icon:
                              Icon(
                                Icons.photo_library_outlined,
                                size: 40.0,
                              ),
                              Text(
                                'アルバムから\n　画像選択',
                              ),
                            ]),
                      ),
                    ),
                    // VerticalDivider(/*区切り線の設定*/),
                  ]),
              Container(
                // color: Colors.pinkAccent,
                width: 145,
                height: 100,
                child:
                ElevatedButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.pinkAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => CropImageSelect_Album()),
                    // );
                  },
                  child:
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // IconButton(
                        //   icon:
                        Icon(
                          Icons.cut_outlined,
                          size: 40.0,
                        ),
                        Text(
                          'アルバムから\n1枚トリミング',
                        ),
                      ]),
                ),
              ),
            ]),


        Divider(),
        Container(
          width: 300,
          alignment:Alignment.center,
          child:
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('キャンセル',style: TextStyle(fontSize:20,color:Colors.black),),
          ),
        ),
      ],

    );
  }
}