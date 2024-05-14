import 'package:flutter/material.dart';

import 'drawing_page.dart';

class ColorPallete extends InheritedNotifier<ColorPalleteNotifier> {
  const ColorPallete({
    Key? key,
    required ColorPalleteNotifier notifier,
    required Widget child,
  }) : super(key: key, notifier: notifier, child: child);

  static ColorPalleteNotifier of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ColorPallete>()!
        .notifier!;
  }
}