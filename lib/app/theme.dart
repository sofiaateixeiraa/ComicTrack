import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const _red = Color(0xFFE53935);
  static const _bg = Color(0xFF121212);
  static const _surface = Color(0xFF1E1E1E);
  static const _card = Color(0xFF2A2A2A);

  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: _bg,
    colorScheme: const ColorScheme.dark(
      primary: _red,
      surface: _surface,
      onPrimary: Colors.white,
      onSurface: Colors.white,
      error: Colors.redAccent,
      surfaceTint: Colors.transparent,
    ),
    textTheme: GoogleFonts.nunitoTextTheme(ThemeData.dark().textTheme),
    appBarTheme: const AppBarTheme(
      backgroundColor: _bg,
      elevation: 0,
      foregroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: const CardThemeData(
      color: _card,
      elevation: 0,
      margin: EdgeInsets.zero,
      surfaceTintColor: Colors.transparent,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      hintStyle: TextStyle(color: Colors.white38),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _red,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: _card,
      selectedColor: _red,
      labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    extensions: const [
      ComicTrackColors(card: _card, surface: _surface, accent: _red),
    ],
  );
}

/// extensão de tema para cores customizadas.
@immutable
class ComicTrackColors extends ThemeExtension<ComicTrackColors> {
  final Color card;
  final Color surface;
  final Color accent;
  const ComicTrackColors({
    required this.card,
    required this.surface,
    required this.accent,
  });

  @override
  ComicTrackColors copyWith({Color? card, Color? surface, Color? accent}) =>
      ComicTrackColors(
        card: card ?? this.card,
        surface: surface ?? this.surface,
        accent: accent ?? this.accent,
      );

  @override
  ComicTrackColors lerp(ComicTrackColors? other, double t) => this;
}

extension ThemeExtensionX on BuildContext {
  ComicTrackColors get colors => Theme.of(this).extension<ComicTrackColors>()!;
}
