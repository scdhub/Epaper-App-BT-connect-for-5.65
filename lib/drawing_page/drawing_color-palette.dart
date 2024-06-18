import 'package:flutter/material.dart';

import 'drawing_page.dart';

class ColorPalette extends InheritedNotifier<ColorPaletteNotifier> {
  const ColorPalette({
    Key? key,
    required ColorPaletteNotifier notifier,
    required Widget child,
  }) : super(key: key, notifier: notifier, child: child);

  static ColorPaletteNotifier of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ColorPalette>()!
        .notifier!;
  }
}