
import 'package:flutter/material.dart';


extension BuildContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  ColorScheme get colorScheme => theme.colorScheme;
}
extension NullableList on List? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}


extension NullableString on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}