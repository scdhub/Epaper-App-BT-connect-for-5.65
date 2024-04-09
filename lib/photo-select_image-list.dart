import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:typed_data';

class ImageList extends StatelessWidget{
  final List<AssetEntity> photos;
  ImageList({
    Key? key,
    required this.photos,
  }): super(key:key);

  @override
  Widget build(BuildContext context){
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(//グリッドの列数を固定する
        crossAxisCount: 4,//1行に4つの画像を表示
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return FutureBuilder<Uint8List?>(
          future: photos[index].thumbnailData,
          builder: (_, snapshot) {
            final bytes = snapshot.data;
            if (bytes == null) return CircularProgressIndicator();
            //タップした画像をトリミングページに渡す。
            return GestureDetector(
              onTap:(){


              },
              // onTap: () async{
              //   final byteData = await photos[index].originBytes;
              //   if (byteData != null) {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => trimming_page(imageData: byteData)),
              //     );
              //   }},
              child: Image.memory(bytes, fit: BoxFit.cover),
            );
          },
        );
      },
    );
  }
}