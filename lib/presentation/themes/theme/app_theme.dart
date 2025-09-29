import 'package:flutter/material.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import '../../../core/constants/size/size_app.dart';

class AppTheme {
  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'SFProText', // Thêm dòng này để set font mặc định
      // Color Scheme
      colorScheme: const ColorScheme.light(
        brightness: Brightness.light,
        primary: AppColor.lightBlue,
        onPrimary: AppColor.backgroundColor,
        primaryContainer: AppColor.superLightBlue,
        onPrimaryContainer: AppColor.backgroundColor,
        secondary: AppColor.superLightBlue,
        onSecondary: AppColor.defaultColor,
        secondaryContainer: AppColor.lightGrey,
        onSecondaryContainer: AppColor.defaultColor,
        tertiary: AppColor.mediumGrey,
        onTertiary: AppColor.backgroundColor,
        tertiaryContainer: AppColor.superLightGrey,
        onTertiaryContainer: AppColor.defaultColor,
        error: AppColor.errorRed,
        onError: AppColor.backgroundColor,
        errorContainer: AppColor.errorRed,
        onErrorContainer: AppColor.errorRed,
        surface: AppColor.backgroundColor,
        onSurface: AppColor.defaultColor,
        onSurfaceVariant: AppColor.defaultColor,
        outline: AppColor.mediumGrey,
        outlineVariant: AppColor.lightGrey,
        shadow: AppColor.defaultColor,
        scrim: AppColor.defaultColor,
        inverseSurface: AppColor.defaultColor,
        onInverseSurface: AppColor.backgroundColor,
        inversePrimary: AppColor.lightBlue,
        surfaceTint: AppColor.lightBlue,
      ),

      // Scaffold Theme
      scaffoldBackgroundColor: AppColor.backgroundColor,

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColor.backgroundColor,
        foregroundColor: AppColor.defaultColor,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'SFProText',
          fontSize: FontSizeApp.fontSizeMedium,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),

      // Text Theme
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontFamily: 'SFProText',
          fontSize: FontSizeApp.fontSizeTitle,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'SFProText',
          fontSize: FontSizeApp.fontSubTitle,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        // Body Text
        bodyLarge: TextStyle(
          fontFamily: 'SFProText',
          fontSize: FontSizeApp.fontSizeMedium,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'SFProText',
          fontSize: FontSizeApp.fontSizeSubMedium,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        bodySmall: TextStyle(
          fontFamily: 'SFProText',
          fontSize: FontSizeApp.fontSizeSmall,
          fontWeight: FontWeight.w400,
          color: Colors.black, // Đổi về màu đen cho đồng bộ
        ),
        // Labels
        labelLarge: TextStyle(
          fontFamily: 'SFProText',
          fontSize: FontSizeApp.fontSizeMedium,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        labelMedium: TextStyle(
          fontFamily: 'SFProText',
          fontSize: FontSizeApp.fontSizeSubMedium,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        labelSmall: TextStyle(
          fontFamily: 'SFProText',
          fontSize: FontSizeApp.fontSizeInsideButton,
          fontWeight: FontWeight.w400,
          color: AppColor.mediumGrey,
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColor.backgroundColor,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColor.lightBlue),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColor.lightBlue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColor.lightBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red),
        ),
        hintStyle: TextStyle(
          fontFamily: 'SFProText',
          fontSize: FontSizeApp.fontSizeInsideButton,
          color: AppColor.mediumGrey,
        ),
        labelStyle: TextStyle(
          fontFamily: 'SFProText',
          fontSize: FontSizeApp.fontSizeInsideButton,
          color: AppColor.lightBlue,
        ),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.lightBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: TextStyle(
            fontSize: FontSizeApp.fontSizeSmall,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColor.lightBlue,
          textStyle: TextStyle(
            fontSize: FontSizeApp.fontSizeSmall,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Card Theme
      cardTheme: CardTheme(
        color: AppColor.backgroundColor,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Icon Theme
      iconTheme: IconThemeData(
        color: AppColor.mediumGrey,
        size: IconSizeApp.iconSizeMedium,
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColor.lightBlue;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
        side: BorderSide(color: AppColor.lightBlue),
      ),

      // List Tile Theme
      listTileTheme: ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textColor: Colors.black,
        iconColor: AppColor.mediumGrey,
      ),
    );
  }

  // Dark Theme (tuỳ chọn)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColor.lightBlue,
        brightness: Brightness.dark,
      ),
    );
  }
}

// Extension để dễ dàng truy cập theme
extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
}
