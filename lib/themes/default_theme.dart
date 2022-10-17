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
        textStyle: darkTextTheme.button?.copyWith(fontWeight: FontWeight.w700, fontSize: 12)),
  ),
  scaffoldBackgroundColor: const Color.fromARGB(255, 12, 12, 12),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color.fromARGB(255, 255, 229, 127),
  onPrimary: Color.fromARGB(255, 53, 54, 58),
  secondary: Color(0xFFD8C4A0),
  onSecondary: Color(0xFF3B2F15),
  error: Color(0xFFFFB4AB),
  onError: Color(0xFF690005),
  background: Color.fromARGB(255, 12, 12, 12),
  onBackground: Color(0xFFE9E1D9),
  surface: Color.fromARGB(255, 21, 21, 21),
  onSurface: Color(0xFFE9E1D9),
);

final darkTextTheme = Typography.material2021()
    .white
    .copyWith(
      headline5: const TextStyle(fontWeight: FontWeight.w600),
      subtitle2: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
    )
    .apply(fontFamily: "Assistant");
