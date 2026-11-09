import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// App Colors representing the Original Stock brand palette.
class AppColors {
  AppColors._();

  // Primary brand purple
  static const Color primary = Color(0xFF5B2C83);
  static const Color primaryDark = Color(0xFF3F1D5E);
  static const Color primaryLight = Color(0xFFEFE8F6);
  static const Color primaryLight2 = Color(0xFF8B4FC2);
  static const Color highlightPurple = Color(0xFFD9B8F5);

  // Purple Gradient language
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF8B4FC2), Color(0xFF5B2C83)],
  );

  static const LinearGradient bannerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF3F1D5E), Color(0xFF5B2C83), Color(0xFF7A3FA6)],
  );

  static const LinearGradient softGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFF3ECFA), Color(0xFFFFFFFF)],
    stops: [0.0, 0.4],
  );

  // Secondary logo gold (reserved exclusively for sale / discount badges)
  static const Color gold = Color(0xFFC9A86A);

  // Surfaces and hair lines
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF5F5F7);
  static const Color hairline = Color(0xFFECECEF);

  // Typography
  static const Color text = Color(0xFF111111);
  static const Color textSecondary = Color(0xFF7A7A85);

  // Semantic
  static const Color error = Color(0xFFE5484D);
  static const Color heart = Color(0xFFE5484D);
  static const Color white = Color(0xFFFFFFFF);
}

/// App Radii tokens
class AppRadius {
  AppRadius._();

  static double get card => 20.r;
  static double get image => 20.r;
  static double get banner => 24.r;
  static double get input => 16.r;
  static double get chip => 999.r;
  static double get pill => 999.r;
  static double get circular => 999.r;
}

/// App Spacing tokens
class AppSpacing {
  AppSpacing._();

  /// Clearance spacing for the floating bottom navigation bar
  static double get navClearance => 100.h;
}

/// Typography tokens using Cairo
class AppText {
  AppText._();

  static const String fontFamily = 'Cairo';

  static TextStyle titleLarge({Color color = AppColors.text, double? fontSize}) =>
      TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w700,
        fontSize: fontSize ?? 24.sp,
        color: color,
        letterSpacing: -0.2,
      );

  static TextStyle titleMedium({Color color = AppColors.text, double? fontSize}) =>
      TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w700,
        fontSize: fontSize ?? 18.sp,
        color: color,
        letterSpacing: -0.2,
      );

  static TextStyle titleSmall({Color color = AppColors.text, double? fontSize}) =>
      TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w700,
        fontSize: fontSize ?? 16.sp,
        color: color,
      );

  static TextStyle bodyLarge({Color color = AppColors.text, double? fontSize}) =>
      TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w500,
        fontSize: fontSize ?? 16.sp,
        color: color,
      );

  static TextStyle bodyMedium({Color color = AppColors.text, double? fontSize}) =>
      TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w500,
        fontSize: fontSize ?? 14.sp,
        color: color,
      );

  static TextStyle bodySmall({
    Color color = AppColors.textSecondary,
    double? fontSize,
  }) => TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: fontSize ?? 12.sp,
    color: color,
  );

  static TextStyle caption({
    Color color = AppColors.textSecondary,
    double? fontSize,
  }) => TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: fontSize ?? 11.sp,
    color: color,
  );

  static TextStyle button({Color color = AppColors.white, double? fontSize}) =>
      TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w700,
        fontSize: fontSize ?? 16.sp,
        color: color,
      );
}

/// Application theme definitions
class AppTheme {
  AppTheme._();

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: AppText.fontFamily,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.gold,
        surface: AppColors.background,
        error: AppColors.error,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.text),
        titleTextStyle: TextStyle(
          fontFamily: AppText.fontFamily,
          fontWeight: FontWeight.w700,
          fontSize: 18,
          color: AppColors.text,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.hairline,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        hintStyle: AppText.bodyMedium(color: AppColors.textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(color: AppColors.hairline, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),
    );
  }
}

