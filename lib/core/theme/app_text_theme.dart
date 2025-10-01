import '../../ui_imports.dart';

class AppTextTheme {
  static String fontFamily = 'DMSans';

  static TextStyle textStyleDMSanse18W700(
          {final Color? color, final double? height}) =>
      TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 18,
          height: height);

  static TextStyle textStyleDMSans18W500(
          {final Color? color, final double? height}) =>
      TextStyle(
          color: color,
          fontWeight: FontWeight.w500,
          fontSize: 18,
          height: height);

  static TextStyle textStyleDMSanse16W700({final Color? color}) =>
      TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 16);

  static TextStyle textStyleDMSans8W400({final Color? color}) =>
      TextStyle(color: color, fontWeight: FontWeight.w400, fontSize: 8);

  static TextStyle textStyleDMSanse32W700({final Color? color}) =>
      TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 32);

  static TextStyle textStyleDMSanse24W700({
    final Color? color,
    final double? height,
  }) =>
      TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 24,
          height: height);

  static TextStyle textStyleDMSanse24W500({
    final Color? color,
    final double? height,
  }) =>
      TextStyle(
          color: color,
          fontWeight: FontWeight.w500,
          fontSize: 24,
          height: height);

  static TextStyle textStyleDMSanse20W700({
    final Color? color,
    final double? height,
  }) =>
      TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 20,
          height: height);

  static TextStyle textStyleDMSanse14W700({final Color? color}) =>
      TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 14);

  static TextStyle textStyleDMSans12W700({final Color? color}) =>
      TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12);

  static TextStyle textStyleDMSanse12W600({final Color? color}) =>
      TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12);

  static TextStyle textStyleDMSanse14W500({final Color? color}) =>
      TextStyle(color: color, fontWeight: FontWeight.w500, fontSize: 14);

  static TextStyle textStyleDMSanse14W400(
          {final Color? color,
          final double? height,
          final double? letterSpacing}) =>
      TextStyle(
          color: color,
          fontWeight: FontWeight.w400,
          fontSize: 14,
          height: height,
          letterSpacing: letterSpacing);

  static TextStyle textStyleDMSanse16W400({final Color? color}) =>
      TextStyle(color: color, fontWeight: FontWeight.w400, fontSize: 16);

  static TextStyle textStyleDMSanse16W500({
    final Color? color,
    final double? height,
  }) =>
      TextStyle(
          color: color,
          fontWeight: FontWeight.w500,
          fontSize: 16,
          height: height);

  static TextStyle textStyleDMSanse10W400({final Color? color}) =>
      TextStyle(color: color, fontWeight: FontWeight.w400, fontSize: 10);

  static TextStyle textStyleDMSanse12W400(
          {final Color? color,
          final TextDecoration? textDecoration,
          Color? decorationColor}) =>
      TextStyle(
          color: color,
          fontWeight: FontWeight.w400,
          fontSize: 12,
          decoration: textDecoration,
          decorationColor: decorationColor ?? AppColors.white);

  static TextStyle textStyleDMSanse12W500({final Color? color}) =>
      TextStyle(color: color, fontWeight: FontWeight.w500, fontSize: 12);

  static TextStyle dynamicStyle(
          Color color, FontWeight fontWeight, double size) =>
      TextStyle(color: color, fontWeight: fontWeight, fontSize: size);
}
