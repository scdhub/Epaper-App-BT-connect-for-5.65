import 'package:flutter/material.dart';
import '../import_type_select_page/take-photo_page.dart';

class TopTakeAPicturePage extends StatelessWidget {
  const TopTakeAPicturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 70,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E88E5),
          side: const BorderSide(color: Colors.white, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          getImageFromCamera(context);
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '撮影して登録',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Icon(Icons.camera_alt, size: 30.0),
          ],
        ),
      ),
    );
  }
}
