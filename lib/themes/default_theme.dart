import "package:flutter/material.dart";

final ThemeData darkTheme = ThemeData(
  colorScheme: darkColorScheme,
  useMaterial3: true,
  textTheme: darkTextTheme,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        backgroundColor: darkColorScheme.primary,
        foregroundColor: darkColorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        textStyle: darkTextTheme.button?.copyWith(fontWeight: FontWeight.w700, fontSize: 16)),
  ),
  scaffoldBackgroundColor: _darkBackgroundColor,
);

const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: _primaryColor,
    onPrimary: Color.fromARGB(255, 53, 54, 58),
    secondary: Color(0xFFD8C4A0),
    onSecondary: Color(0xFF3B2F15),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    background: _darkBackgroundColor,
    onBackground: Color(0xFFE9E1D9),
    surface: _darkSurfaceColor,
    onSurface: Color(0xFFE9E1D9),
    surfaceTint: Color(0x00000000));

final darkTextTheme = Typography.material2021()
    .white
    .copyWith(
      headline6: const TextStyle(fontWeight: FontWeight.w600),
      headline5: const TextStyle(fontWeight: FontWeight.w600),
      subtitle2: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
    )
    .apply(fontFamily: "Satoshi");

const _primaryColor = Color.fromARGB(255, 255, 229, 127);
const _darkBackgroundColor = Color.fromARGB(255, 25, 25, 25);
const _darkSurfaceColor = Color.fromARGB(255, 21, 21, 21);
