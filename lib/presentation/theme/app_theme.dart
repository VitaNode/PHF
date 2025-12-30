/// # App Theme
///
/// ## Description
/// 全局主题配置，遵循 `Constitution#X. UI/UX` 准则。
///
/// ## Principles
/// - **Primary Color**: Teal (#008080)
/// - **Typography**: Monospace (Inconsolata preference)
/// - **Shapes**: 
///   - Cards: 12px circular radius
///   - Buttons/Inputs: 8px circular radius
///
/// ## Usage
/// ```dart
/// MaterialApp(
///   theme: AppTheme.lightTheme,
///   ...
/// );
/// ```
library;

import 'package:flutter/material.dart';

class AppTheme {
  // --- Colors ---
  static const Color primaryTeal = Color(0xFF008080);
  static const Color warningOrange = Color(0xFFFF9900);
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color errorRed = Color(0xFFD32F2F);
  
  static const Color bgWhite = Color(0xFFFFFFFF);
  static const Color bgGrey = Color(0xFFF2F2F7);
  static const Color textBlack = Color(0xFF1C1C1E);
  static const Color textGrey = Color(0xFF8E8E93);

  // Aliases for new UI Kit
  static const Color primary = primaryTeal;
  static const Color primaryLight = Color(0xFF4DB6AC); // Teal 300
  static const Color bgGray = bgGrey;
  static const Color textPrimary = textBlack;
  static const Color textSecondary = Color(0xFF666666);
  static const Color textHint = textGrey;

  // --- Radii ---
  static const double radiusCard = 12.0;
  static const double radiusButton = 8.0;

  // --- Typography ---
  static const String fontPool = 'Inconsolata'; 

  static const TextStyle monoStyle = TextStyle(
    fontFamily: fontPool,
    fontSize: 14,
    color: textBlack,
  ); 

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryTeal,
      scaffoldBackgroundColor: bgWhite,
      
      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: primaryTeal,
        secondary: primaryTeal,
        surface: bgWhite,
        error: errorRed,
        onPrimary: Colors.white,
        onSurface: textBlack,
      ),

      // Typography
      fontFamily: fontPool,
      fontFamilyFallback: const ['Courier New', 'Courier', 'monospace'],
      textTheme: const TextTheme(
        // Headers
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textBlack),
        headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textBlack),
        headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: textBlack),
        
        // Body
        bodyLarge: TextStyle(fontSize: 16, color: textBlack),
        bodyMedium: TextStyle(fontSize: 14, color: textBlack),
        bodySmall: TextStyle(fontSize: 12, color: textGrey),
      ),

      // Card Theme
      cardTheme: const CardThemeData(
        color: bgWhite,
        surfaceTintColor: Colors.transparent, 
        elevation: 0, 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radiusCard)),
          side: BorderSide(color: Color(0xFFE5E5EA), width: 1),
        ),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),

      // Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryTeal,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(radiusButton)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 16, 
            fontWeight: FontWeight.w600,
            fontFamily: fontPool,
          ),
        ),
      ),

      // Input Decoration
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: bgGrey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(radiusButton)),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(radiusButton)),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(radiusButton)),
          borderSide: BorderSide(color: primaryTeal, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      
      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: bgWhite,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textBlack, 
          fontSize: 18, 
          fontWeight: FontWeight.bold,
          fontFamily: fontPool,
        ),
        iconTheme: IconThemeData(color: textBlack),
        elevation: 0,
        shape: Border(bottom: BorderSide(color: Color(0xFFE5E5EA), width: 1)),
      ),
    );
  }
}
