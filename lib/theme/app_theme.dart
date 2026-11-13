import 'package:flutter/material.dart';

/// Tema Institucional SENATI - AULA PUNTOS
/// Paleta corporativa con bordes armónicos, elevaciones limpias y estilos tipográficos.
class AppTheme {
  // Paleta Institucional SENATI
  static const Color senatiNavy = Color(0xFF002B49);
  static const Color senatiBlue = Color(0xFF003876);
  static const Color senatiBlueDark = Color(0xFF001F35);
  static const Color senatiBlueLight = Color(0xFF0D4F9B);
  static const Color senatiAccent = Color(0xFF0284C7);
  static const Color senatiAccentLight = Color(0xFFE0F2FE);

  // Estados de Asistencia (Regla de negocio 7)
  static const Color statusPresente = Color(0xFF16A34A);
  static const Color statusPresenteBg = Color(0xFFDCFCE7);
  static const Color statusTardanza = Color(0xFFD97706);
  static const Color statusTardanzaBg = Color(0xFFFEF3C7);
  static const Color statusFalta = Color(0xFFDC2626);
  static const Color statusFaltaBg = Color(0xFFFEE2E2);
  static const Color statusJustificado = Color(0xFF2563EB);
  static const Color statusJustificadoBg = Color(0xFFDBEAFE);

  // Botones Rápidos de Puntos
  static const Color pts1 = Color(0xFF0284C7);
  static const Color pts2 = Color(0xFF002B49);
  static const Color pts3 = Color(0xFFEA580C);

  // Fondos y Neutros
  static const Color bgScreen = Color(0xFFF8FAFC);
  static const Color bgCard = Colors.white;
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color borderInteractive = Color(0xFFCBD5E1);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: bgScreen,
      primaryColor: senatiBlue,
      colorScheme: ColorScheme.fromSeed(
        seedColor: senatiBlue,
        primary: senatiBlue,
        secondary: senatiAccent,
        surface: bgCard,
      ),
      fontFamily: 'Inter',
      appBarTheme: const AppBarTheme(
        backgroundColor: senatiNavy,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 16.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        color: bgCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: borderColor, width: 1),
        ),
        margin: const EdgeInsets.only(bottom: 12),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: borderInteractive, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: borderInteractive, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: senatiBlue, width: 2),
        ),
        labelStyle: const TextStyle(fontSize: 13, color: textSecondary, fontWeight: FontWeight.w600),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: senatiNavy,
          foregroundColor: Colors.white,
          elevation: 1,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: senatiBlue,
        unselectedItemColor: textMuted,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}

