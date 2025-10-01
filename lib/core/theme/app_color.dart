import 'package:flutter/material.dart';

abstract class AppColors {
  static Color bgScaffold = const Color(0xff101010);
  static Color primaryLight = const Color(0xfff2eefd);
  static Color primaryDefault = const Color(0xff9747FF);
  static Color black = const Color(0xff000000);
  static Color darkDefault = const Color(0xff52577A);

  static Color white = const Color(0xffffffff);
  static Color grey = const Color(0xff4C4C4C);

  static Color dark = const Color(0xff222831);
  static Color darkA = const Color(0xff6F7499);
  static Color darkB = const Color(0xff8A8DB1);


  static LinearGradient primaryGradientA = const LinearGradient(
    colors: [Color(0xff9D7AFF), Color(0xff52D5FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient primaryGradientAWithOpacity = const LinearGradient(
    colors: [Color(0x8c9d7aff), Color(0x8b52d5ff)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient primaryGradientB = const LinearGradient(
    colors: [Color(0xff4D84FF), Color(0xffDE8FFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient primaryGradientC = const LinearGradient(
    colors: [Color(0xff5285FF), Color(0xffDE8FFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static Color errorDark = const Color(0xff9c0042);
  static Color errorDark2 = const Color(0xffC30052);
  static Color errorLight = const Color(0xffff84b7);
  static Color errorBg = const Color(0xfffff0f6);
  static Color errorDefault = const Color(0xffed2e7e);
  static Color errorLightB = const Color(0xffFFECEB);

  static Color successDark = const Color(0xff027a48);
  static Color successLight = const Color(0xffecfdf3);
  static Color successDefault = const Color(0xff04c900);
  static Color green = const Color(0xff437233);

  static Color warningDefault = const Color(0xffeabb42);
  static Color warningLight = const Color(0xfffbf1d9);
  static Color warningDark = const Color(0xffbb9635);
  static Color warningBg = const Color(0xfffffbf0);

  static Color infoDark = const Color(0xff112f5b);
  static Color infoDefault = const Color(0xff194689);
  static Color infoLight = const Color(0xffb2c1d8);
  static Color infoBg = const Color(0xffd1dae7);

  static Color transparent = const Color(0x00ffffff);
  static LinearGradient bgGradient = const LinearGradient(
    colors: [Color(0xff5285FF), Color(0xffDE8FFF)],
    begin: Alignment.topLeft,
    end: Alignment.topRight,
  );

}
