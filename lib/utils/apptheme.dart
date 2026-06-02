import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ------------------------------------------------------------
/// APP COLORS
/// ------------------------------------------------------------
/// Centralized color palette used across the application.
class AppColor {
  AppColor._(); // Prevent instantiation

  /// Primary Colors
  static const Color darkBlue = Color(0xFF19305C);
  static const Color green = Color(0xFF19BAAC);

  /// Neutral Colors
  static const Color white = Color(0xFFFEFEFE);
  static const Color grey = Color(0xFF96989A);
  static const Color lightGrey = Color(0xFFF3F3F3);
  static const Color black = Colors.black87;

  /// Additional UI Colors
  static const Color red = Color(0xFFEA5B5B);
  static const Color lightNavColor = Color(0xFF7383A5);
  static const Color welcomeBgColor = Color(0xFFF0F6F8);

  /// Snackbar Colors
  static const Color snackGreen = Color(0xFF4CB15C);
  static const Color snackBgGreen = Color(0xFFE2F2E5);

  static const Color snackRed = Color(0xFFFF686B);
  static const Color snackBgRed = Color(0xFFFFE7E7);

  /// --- NEW AXON AI THEME COLORS ---
  static const Color axonBg = Color(0xFF09090E); // Deep space dark background
  static const Color axonPurple = Color(0xFF7B61FF); // Neon purple accent
  static const Color axonBlue = Color(0xFF38BDF8); // Neon cyan/blue accent
  static const Color axonCardBg = Color(0xFF13131F); // Dark translucent card base
  static const Color axonTextLight = Color(0xFFE2E8F0); // Off-white for readable dark mode text
}

/// ------------------------------------------------------------
/// APP THEME
/// ------------------------------------------------------------
/// Global theme configuration for the entire application.
class AppTheme {
  AppTheme._(); // Prevent instantiation

  /// Main ThemeData
  static final ThemeData themeData = ThemeData(
    useMaterial3: true,
    textTheme: GoogleFonts.kanitTextTheme(),
    splashColor: Colors.white60,
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColor.green,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.green,
        foregroundColor: AppColor.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColor.green,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  /// Default Border (Unfocused)
  static const OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: BorderSide(color: AppColor.green, width: 1.2),
  );

  /// Focused Border
  static const OutlineInputBorder focusedOutlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: BorderSide(color: AppColor.darkBlue, width: 1.5),
  );

  /// Error Border
  static const OutlineInputBorder errorOutlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: BorderSide(color: AppColor.red, width: 1.2),
  );

  /// Global Main Background
  static final LinearGradient globalBackgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.alphaBlend(AppColor.green.withValues(alpha: 0.6), AppColor.white),
      AppColor.welcomeBgColor,
      AppColor.white,
    ],
    stops: const [0.0, 0.6, 1.0],
  );

  /// --- NEW AXON AI GRADIENT ---
  static final RadialGradient axonGlowGradient = RadialGradient(
    center: Alignment.topLeft,
    radius: 1.5,
    colors: [
      AppColor.axonPurple.withValues(alpha: 0.15),
      AppColor.axonBg,
    ],
    stops: const [0.0, 1.0],
  );
}