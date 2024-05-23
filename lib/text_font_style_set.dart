import 'package:flutter/cupertino.dart';

class TextFontsStyle extends StatelessWidget {
  final String text;
  final double? size;
  final FontWeight? weight;

   TextFontsStyle({required this.text, this.size, this.weight});

  @override
  Widget build(BuildContext context){
    return Text(
      text,
      style: TextStyle(
          fontFamily: 'NotoSansJP',
        fontSize: size ?? 16,
        fontWeight: weight ?? FontWeight.normal,
      ),
    );
  }
}