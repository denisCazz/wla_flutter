import 'package:flutter/material.dart';

class SpeedyColors {
  // Colori brand Speedy Pizza
  static const Color primary = Color(0xFFE53E3E); // Red
  static const Color secondary = Color(0xFFFFD700); // Gold/Yellow
  static const Color accent = Color(0xFFFF8C00); // Orange
  static const Color background = Color(0xFF1A1A1A); // Dark background
  static const Color surface = Color(0xFF2D2D2D); // Card surfaces
  static const Color onPrimary = Colors.white;
  static const Color onSecondary = Colors.black;
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB0B0B0);

  // Colori specifici Speedy Pizza
  static const Color speedyRed = Color(0xFFE53E3E);
  static const Color speedyYellow = Color(0xFFFFD700);
  static const Color speedyOrange = Color(0xFFFF8C00);
  static const Color speedyGreen = Color(0xFF10B981);

  // Gradiente brand
  static const LinearGradient speedyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [speedyRed, speedyOrange],
  );

  static const LinearGradient logoGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [speedyYellow, speedyOrange],
  );
}
