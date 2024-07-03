import 'package:flutter/material.dart';

String isSelectedValue = 'Song';

class TextFonts extends StatefulWidget {
  const TextFonts({super.key});

  @override
  State<TextFonts> createState() => _TextFontsState();
}

class _TextFontsState extends State<TextFonts> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 80,
        height: 80,
        child: Transform.scale(
            // scale: 0.8,
            scale: 1.0,
            child: Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DropdownButton(
                        items: const [
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
                        style:
                            const TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ]))));
  }
}
