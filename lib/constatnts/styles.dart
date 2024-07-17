import 'dart:math';

import 'package:flutter/material.dart';

class AppStyles {
  static TextStyle getExtraBoldStyle({required double fontSize, required BuildContext context, Color? fontColor}) => TextStyle(
        fontSize: fontSize,
        color: fontColor,
        fontWeight: FontWeight.w800,
      );

  static TextStyle getBoldStyle({required double fontSize, required BuildContext context, Color? fontColor}) => TextStyle(
        fontSize: fontSize,
        color: fontColor,
        fontWeight: FontWeight.w700,
      );

  static TextStyle getLightStyle({required double fontSize, Color? fontColor, required BuildContext context}) => TextStyle(
        fontSize: fontSize,
        color: fontColor,
        fontWeight: FontWeight.w300,
      );

  static TextStyle getMediumStyle({required double fontSize, Color? fontColor, required BuildContext context}) => TextStyle(
        fontSize: fontSize,
        color: fontColor,
        fontWeight: FontWeight.w500,
      );

  static TextStyle getRegularStyle({required double fontSize, Color? fontColor, required BuildContext context}) => TextStyle(
        fontSize: fontSize,
        color: fontColor,
        fontWeight: FontWeight.w400,
      );

  static TextStyle getSemioBoldStyle({required double fontSize, Color? fontColor, required BuildContext context}) => TextStyle(
        fontSize: fontSize,
        color: fontColor,
        fontWeight: FontWeight.w600,
      );

  static Color getButtonColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.hovered)) {
      return Colors.transparent;
    }
    return Colors.green.shade500;
  }

  static Color getTextColor(Set<WidgetStateProperty> states) {
    if (states.contains(WidgetState.hovered)) {
      return Colors.green.shade500;
    }
    return Colors.transparent;
  }

  static ButtonStyle filledButton = ButtonStyle(
    backgroundColor: WidgetStateProperty.all(Colors.green.shade500),
    foregroundColor: WidgetStateProperty.all(Colors.white),
    elevation: WidgetStateProperty.all(5),
    shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
    padding: WidgetStateProperty.all(const EdgeInsets.all(20)),
  );

  static ButtonStyle outlineButton = ButtonStyle(
    shape: WidgetStateProperty.all(RoundedRectangleBorder(side: BorderSide(color: Colors.grey.shade500), borderRadius: BorderRadius.circular(10))),
    padding: WidgetStateProperty.all(const EdgeInsets.all(20)),
    backgroundColor: WidgetStateProperty.all(Colors.transparent),
    foregroundColor: WidgetStateProperty.all(Colors.grey.shade500),
    elevation: WidgetStateProperty.all(5),
  );
}

class ScaleSize {
  static double textScaler(BuildContext context, {double maxTextScaleFactor = 2}) {
    final double width = MediaQuery.of(context).size.width;
    final double val = (width / 500) * maxTextScaleFactor;
    return max(2, min(val, maxTextScaleFactor));
  }
}
