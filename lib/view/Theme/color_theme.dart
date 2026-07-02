import 'package:flutter/material.dart';

final lightMode = const ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF1B6B3A),
  onPrimary: Color(0xFFFFFFFF),
  secondary: Color(0xFFD4860A),
  onSecondary: Color(0xFFFFFFFF),
  error: Color(0xFFDC2626),
  onError: Color(0xFFFFFFFF),
  surface: Color(0xFFFFFFFF),
  onSurface: Color(0xFF111827),
  scrim: Color(0xFF9CA3AF),
  tertiary: Color(0xFF16A34A),
  onTertiary: Color(0xFFFFFFFF),
  inversePrimary: Color(0xFF2563EB),
);

final darkMode = const ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF3FB86A),
  onPrimary: Color(0xFFE6EDF3),
  secondary: Color(0xFFF0A832),
  onSecondary: Color(0xFF2A1F08),
  surface: Color(0xFF161B22),
  onSurface: Color(0xFFE6EDF3),
  scrim: Color(0xFF484F58),
  error: Color(0xFFF85149),
  onError: Color(0xFFFFFFFF),
  tertiary: Color(0xFF3FB85A),
  onTertiary: Color(0xFF0F2A1A),
  inversePrimary: Color(0xFF58A6FF),
);
