import 'package:flutter/widgets.dart';

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
  }

  static EdgeInsets statusBarHeight = _mediaQueryData.viewPadding;

  static double setText(double size) {
    return (size / blockSizeVertical) * blockSizeVertical;
  }

  static double setHeight(double size) { 
    return (size / blockSizeVertical) * blockSizeVertical;
  }

  static double setWidth(double size) {
    return (size / blockSizeHorizontal) * blockSizeHorizontal;
  }
}
