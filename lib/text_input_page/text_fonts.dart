import 'package:flutter/material.dart';

String isSelectedValue = 'Song';

class TextFonts extends StatefulWidget {
  @override
  _TextFontsState createState() => _TextFontsState();
}

class _TextFontsState extends State<TextFonts> {
  @override
  Widget build(BuildContext context) {
    return
      Transform.scale(
          scale: 0.8,
          child:Container(

              padding:EdgeInsets.fromLTRB(0, 0, 0, 0),
              child:Container(
                // color:Colors.grey,

                  width: 80,
                  height: 50,
                  child: Column(children: [
                    DropdownButton(

                      items:  [
                        DropdownMenuItem(
                          value: 'Song',
                          child: Text('Song'),
                        ),
                        DropdownMenuItem(
                          value: 'Colorful Chinese',
                          child: Text('Colorful Chinese'),
                        ),
                        DropdownMenuItem(
                          value: 'Simkai',
                          child: Text('Simkai'),
                        ),
                      ],
                      value: isSelectedValue,
                      onChanged: (String? value) {
                        setState(() {
                          isSelectedValue = value!;
                        });
                      },
                      isExpanded: true,
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ]))));
  }
}