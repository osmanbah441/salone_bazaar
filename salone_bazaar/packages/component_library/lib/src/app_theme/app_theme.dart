import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class AppTheme {
  const AppTheme({required this.context, this.brightness = Brightness.dark});
  final BuildContext context;
  final Brightness brightness;

  ThemeData theme() {
    final textTheme =
        _createTextTheme(context, "Source Code Pro", "Source Code Pro");

    final colorScheme = _lightScheme;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      inputDecorationTheme: _inputDecorationTheme,
      textTheme: textTheme.apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
      scaffoldBackgroundColor: colorScheme.surface,
      canvasColor: colorScheme.surface,
    );
  }

  ColorScheme get _lightScheme => const ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xff006a6a),
        surfaceTint: Color(0xff006a6a),
        onPrimary: Color(0xffffffff),
        primaryContainer: Color(0xff9cf1f0),
        onPrimaryContainer: Color(0xff002020),
        secondary: Color(0xff4a6363),
        onSecondary: Color(0xffffffff),
        secondaryContainer: Color(0xffcce8e7),
        onSecondaryContainer: Color(0xff051f1f),
        tertiary: Color(0xff4b607c),
        onTertiary: Color(0xffffffff),
        tertiaryContainer: Color(0xffd3e4ff),
        onTertiaryContainer: Color(0xff041c35),
        error: Color(0xffba1a1a),
        onError: Color(0xffffffff),
        errorContainer: Color(0xffffdad6),
        onErrorContainer: Color(0xff410002),
        surface: Color(0xfff4fbfa),
        onSurface: Color(0xff161d1d),
        onSurfaceVariant: Color(0xff3f4948),
        outline: Color(0xff6f7979),
        outlineVariant: Color(0xffbec9c8),
        shadow: Color(0xff000000),
        scrim: Color(0xff000000),
        inverseSurface: Color(0xff2b3231),
        inversePrimary: Color(0xff80d5d4),
        primaryFixed: Color(0xff9cf1f0),
        onPrimaryFixed: Color(0xff002020),
        primaryFixedDim: Color(0xff80d5d4),
        onPrimaryFixedVariant: Color(0xff004f4f),
        secondaryFixed: Color(0xffcce8e7),
        onSecondaryFixed: Color(0xff051f1f),
        secondaryFixedDim: Color(0xffb0cccb),
        onSecondaryFixedVariant: Color(0xff324b4b),
        tertiaryFixed: Color(0xffd3e4ff),
        onTertiaryFixed: Color(0xff041c35),
        tertiaryFixedDim: Color(0xffb3c8e8),
        onTertiaryFixedVariant: Color(0xff334863),
        surfaceDim: Color(0xffd5dbda),
        surfaceBright: Color(0xfff4fbfa),
        surfaceContainerLowest: Color(0xffffffff),
        surfaceContainerLow: Color(0xffeff5f4),
        surfaceContainer: Color(0xffe9efee),
        surfaceContainerHigh: Color(0xffe3e9e9),
        surfaceContainerHighest: Color(0xffdde4e3),
      );

  TextTheme _createTextTheme(
      BuildContext context, String bodyFontString, String displayFontString) {
    TextTheme baseTextTheme = Theme.of(context).textTheme;
    TextTheme bodyTextTheme =
        GoogleFonts.getTextTheme(bodyFontString, baseTextTheme);
    TextTheme displayTextTheme =
        GoogleFonts.getTextTheme(displayFontString, baseTextTheme);
    TextTheme textTheme = displayTextTheme.copyWith(
      bodyLarge: bodyTextTheme.bodyLarge,
      bodyMedium: bodyTextTheme.bodyMedium,
      bodySmall: bodyTextTheme.bodySmall,
      labelLarge: bodyTextTheme.labelLarge,
      labelMedium: bodyTextTheme.labelMedium,
      labelSmall: bodyTextTheme.labelSmall,
    );
    return textTheme;
  }

  InputDecorationTheme get _inputDecorationTheme {
    // Border side for normal states
    const borderSide = BorderSide();

    // Border side for error states
    const errorBorderSide = BorderSide(
      color: Colors.red,
      width: 2.0,
    );

    return InputDecorationTheme(
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: borderSide,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: borderSide,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.black54,
          width: 2.0,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: errorBorderSide,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: errorBorderSide,
      ),
    );
  }
}
