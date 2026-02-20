import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff8c4e28),
      surfaceTint: Color(0xff8c4e28),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffffdbc9),
      onPrimaryContainer: Color(0xff6f3813),
      secondary: Color(0xff8d4e2a),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffffdbca),
      onSecondaryContainer: Color(0xff703715),
      tertiary: Color(0xff656015),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffede68c),
      onTertiaryContainer: Color(0xff4d4800),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfffff8f6),
      onSurface: Color(0xff221a15),
      onSurfaceVariant: Color(0xff52443c),
      outline: Color(0xff85746b),
      outlineVariant: Color(0xffd7c2b8),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff382e29),
      inversePrimary: Color(0xffffb68d),
      primaryFixed: Color(0xffffdbc9),
      onPrimaryFixed: Color(0xff331200),
      primaryFixedDim: Color(0xffffb68d),
      onPrimaryFixedVariant: Color(0xff6f3813),
      secondaryFixed: Color(0xffffdbca),
      onSecondaryFixed: Color(0xff341100),
      secondaryFixedDim: Color(0xffffb690),
      onSecondaryFixedVariant: Color(0xff703715),
      tertiaryFixed: Color(0xffede68c),
      onTertiaryFixed: Color(0xff1e1c00),
      tertiaryFixedDim: Color(0xffd0c973),
      onTertiaryFixedVariant: Color(0xff4d4800),
      surfaceDim: Color(0xffe8d7cf),
      surfaceBright: Color(0xfffff8f6),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff1eb),
      surfaceContainer: Color(0xfffceae3),
      surfaceContainerHigh: Color(0xfff6e5dd),
      surfaceContainerHighest: Color(0xfff0dfd7),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff5a2804),
      surfaceTint: Color(0xff8c4e28),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff9e5d35),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff5b2706),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff9e5c37),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff3b3700),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff746f23),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f6),
      onSurface: Color(0xff170f0b),
      onSurfaceVariant: Color(0xff41332c),
      outline: Color(0xff5e4f48),
      outlineVariant: Color(0xff7a6a61),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff382e29),
      inversePrimary: Color(0xffffb68d),
      primaryFixed: Color(0xff9e5d35),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff804520),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff9e5c37),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff814522),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff746f23),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff5b570a),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd3c3bc),
      surfaceBright: Color(0xfffff8f6),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff1eb),
      surfaceContainer: Color(0xfff6e5dd),
      surfaceContainerHigh: Color(0xffead9d2),
      surfaceContainerHighest: Color(0xffdfcec7),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff4c1f00),
      surfaceTint: Color(0xff8c4e28),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff723a15),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff4e1e00),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff733917),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff302d00),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff4f4b00),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f6),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff362923),
      outlineVariant: Color(0xff55463f),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff382e29),
      inversePrimary: Color(0xffffb68d),
      primaryFixed: Color(0xff723a15),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff562401),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff733917),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff562403),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff4f4b00),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff373400),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc5b6ae),
      surfaceBright: Color(0xfffff8f6),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffffede5),
      surfaceContainer: Color(0xfff0dfd7),
      surfaceContainerHigh: Color(0xffe2d1c9),
      surfaceContainerHighest: Color(0xffd3c3bc),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffb68d),
      surfaceTint: Color(0xffffb68d),
      onPrimary: Color(0xff532200),
      primaryContainer: Color(0xff6f3813),
      onPrimaryContainer: Color(0xffffdbc9),
      secondary: Color(0xffffb690),
      onSecondary: Color(0xff542202),
      secondaryContainer: Color(0xff703715),
      onSecondaryContainer: Color(0xffffdbca),
      tertiary: Color(0xffd0c973),
      onTertiary: Color(0xff353200),
      tertiaryContainer: Color(0xff4d4800),
      onTertiaryContainer: Color(0xffede68c),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff1a120d),
      onSurface: Color(0xfff0dfd7),
      onSurfaceVariant: Color(0xffd7c2b8),
      outline: Color(0xff9f8d84),
      outlineVariant: Color(0xff52443c),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff0dfd7),
      inversePrimary: Color(0xff8c4e28),
      primaryFixed: Color(0xffffdbc9),
      onPrimaryFixed: Color(0xff331200),
      primaryFixedDim: Color(0xffffb68d),
      onPrimaryFixedVariant: Color(0xff6f3813),
      secondaryFixed: Color(0xffffdbca),
      onSecondaryFixed: Color(0xff341100),
      secondaryFixedDim: Color(0xffffb690),
      onSecondaryFixedVariant: Color(0xff703715),
      tertiaryFixed: Color(0xffede68c),
      onTertiaryFixed: Color(0xff1e1c00),
      tertiaryFixedDim: Color(0xffd0c973),
      onTertiaryFixedVariant: Color(0xff4d4800),
      surfaceDim: Color(0xff1a120d),
      surfaceBright: Color(0xff413732),
      surfaceContainerLowest: Color(0xff140d08),
      surfaceContainerLow: Color(0xff221a15),
      surfaceContainer: Color(0xff271e19),
      surfaceContainerHigh: Color(0xff312823),
      surfaceContainerHighest: Color(0xff3d332e),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffd3bd),
      surfaceTint: Color(0xffffb68d),
      onPrimary: Color(0xff421a00),
      primaryContainer: Color(0xffc87f55),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffffd3be),
      onSecondary: Color(0xff441900),
      secondaryContainer: Color(0xffc87f57),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffe7df87),
      onTertiary: Color(0xff292700),
      tertiaryContainer: Color(0xff999343),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff1a120d),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffeed8ce),
      outline: Color(0xffc2aea4),
      outlineVariant: Color(0xff9f8d84),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff0dfd7),
      inversePrimary: Color(0xff713914),
      primaryFixed: Color(0xffffdbc9),
      onPrimaryFixed: Color(0xff220a00),
      primaryFixedDim: Color(0xffffb68d),
      onPrimaryFixedVariant: Color(0xff5a2804),
      secondaryFixed: Color(0xffffdbca),
      onSecondaryFixed: Color(0xff230900),
      secondaryFixedDim: Color(0xffffb690),
      onSecondaryFixedVariant: Color(0xff5b2706),
      tertiaryFixed: Color(0xffede68c),
      onTertiaryFixed: Color(0xff131200),
      tertiaryFixedDim: Color(0xffd0c973),
      onTertiaryFixedVariant: Color(0xff3b3700),
      surfaceDim: Color(0xff1a120d),
      surfaceBright: Color(0xff4d423d),
      surfaceContainerLowest: Color(0xff0c0604),
      surfaceContainerLow: Color(0xff241c17),
      surfaceContainer: Color(0xff2f2621),
      surfaceContainerHigh: Color(0xff3a302b),
      surfaceContainerHighest: Color(0xff463b36),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffece4),
      surfaceTint: Color(0xffffb68d),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffffb184),
      onPrimaryContainer: Color(0xff190600),
      secondary: Color(0xffffece4),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffffb087),
      onSecondaryContainer: Color(0xff1a0600),
      tertiary: Color(0xfffbf398),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffccc670),
      onTertiaryContainer: Color(0xff0d0c00),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff1a120d),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffffece4),
      outlineVariant: Color(0xffd3beb5),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff0dfd7),
      inversePrimary: Color(0xff713914),
      primaryFixed: Color(0xffffdbc9),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffffb68d),
      onPrimaryFixedVariant: Color(0xff220a00),
      secondaryFixed: Color(0xffffdbca),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffffb690),
      onSecondaryFixedVariant: Color(0xff230900),
      tertiaryFixed: Color(0xffede68c),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffd0c973),
      onTertiaryFixedVariant: Color(0xff131200),
      surfaceDim: Color(0xff1a120d),
      surfaceBright: Color(0xff594e48),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff271e19),
      surfaceContainer: Color(0xff382e29),
      surfaceContainerHigh: Color(0xff443934),
      surfaceContainerHighest: Color(0xff50443f),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
  );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
