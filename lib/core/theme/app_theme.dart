import 'package:flutter/material.dart';

class AppTheme {
  // Цветовая палитра
  static const Color primaryDark = Color(0xFF0B0B0F);
  static const Color secondaryDark = Color(0xFF141421);
  static const Color neonPurple = Color(0xFF9D4EDD);
  static const Color neonBlue = Color(0xFF3F37C9);
  static const Color neonCyan = Color(0xFF00F5FF);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textGray = Color(0xFFB0B0B0);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: neonPurple,
      scaffoldBackgroundColor: primaryDark,
      colorScheme: const ColorScheme.dark(
        primary: neonPurple,
        secondary: neonBlue,
        surface: secondaryDark,
        onPrimary: textWhite,
        onSecondary: textWhite,
        onSurface: textWhite,
      ),
      textTheme: _buildTextTheme(),
      elevatedButtonTheme: _buildElevatedButtonTheme(),
      appBarTheme: _buildAppBarTheme(),
      cardTheme: _buildCardTheme(),
    );
  }

  static TextTheme _buildTextTheme() {
    return const TextTheme(
      displayLarge: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: textWhite,
        height: 1.2,
        shadows: [
          Shadow(
            offset: Offset(0, 4),
            blurRadius: 8,
            color: neonPurple,
          ),
          Shadow(
            offset: Offset(0, 2),
            blurRadius: 4,
            color: Colors.black54,
          ),
        ],
      ),
      displayMedium: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: textWhite,
        height: 1.2,
        shadows: [
          Shadow(
            offset: Offset(0, 3),
            blurRadius: 6,
            color: neonBlue,
          ),
          Shadow(
            offset: Offset(0, 2),
            blurRadius: 4,
            color: Colors.black54,
          ),
        ],
      ),
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textWhite,
        height: 1.2,
        shadows: [
          Shadow(
            offset: Offset(0, 2),
            blurRadius: 4,
            color: neonCyan,
          ),
          Shadow(
            offset: Offset(0, 2),
            blurRadius: 4,
            color: Colors.black54,
          ),
        ],
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textWhite,
        height: 1.2,
        shadows: [
          Shadow(
            offset: Offset(0, 2),
            blurRadius: 4,
            color: neonPurple,
          ),
          Shadow(
            offset: Offset(0, 1),
            blurRadius: 2,
            color: Colors.black54,
          ),
        ],
      ),
      bodyLarge: TextStyle(
        fontSize: 20,
        color: textWhite,
        height: 1.4,
        shadows: [
          Shadow(
            offset: Offset(0, 1),
            blurRadius: 2,
            color: Colors.black54,
          ),
        ],
      ),
      bodyMedium: TextStyle(
        fontSize: 18,
        color: textGray,
        height: 1.4,
      ),
    );
  }

  static ElevatedButtonThemeData _buildElevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: neonPurple,
        foregroundColor: textWhite,
        minimumSize: const Size(200, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 8,
        shadowColor: neonPurple.withValues(alpha: 0.5),
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              offset: Offset(0, 2),
              blurRadius: 4,
              color: Colors.black54,
            ),
          ],
        ),
      ),
    );
  }

  static AppBarTheme _buildAppBarTheme() {
    return const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textWhite,
        shadows: [
          Shadow(
            offset: Offset(0, 2),
            blurRadius: 4,
            color: neonPurple,
          ),
        ],
      ),
    );
  }

  static CardThemeData _buildCardTheme() {
    return CardThemeData(
      color: secondaryDark,
      elevation: 8,
      shadowColor: neonPurple.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: neonPurple.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
    );
  }
}