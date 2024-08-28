import 'package:flutter/material.dart';

class ScrollAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onTap;
  final AppBar appBar;

  const ScrollAppBar({Key? key, required this.onTap, required this.appBar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: appBar);
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}