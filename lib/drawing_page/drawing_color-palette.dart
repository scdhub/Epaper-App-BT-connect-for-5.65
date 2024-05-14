import 'package:flutter/material.dart';

import 'drawing_page.dart';

class ColorPalette extends InheritedNotifier<ColorPaletteNotifier> {
  const ColorPalette({
    Key? key,
    required ColorPaletteNotifier notifier,
    required Widget child,
  }) : super(key: key, notifier: notifier, child: child);

  static ColorPaletteNotifier of(BuildContext context) {
    //追加
    // final widget = context.dependOnInheritedWidgetOfExactType<ColorPalette>();
    // assert(widget != null, 'No ColorPalette found in context');
    // return widget!.notifier!;
    //
    return context
        .dependOnInheritedWidgetOfExactType<ColorPalette>()!
        .notifier!;
  }
}