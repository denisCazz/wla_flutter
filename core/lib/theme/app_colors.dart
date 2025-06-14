import 'dart:ui';
import 'package:flutter/material.dart';

class AppColors {
  // Colori base per il tema scuro moderno
  static const Color primary = Color(0xFF6366F1); // Indigo
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);
  
  static const Color secondary = Color(0xFF8B5CF6); // Purple
  static const Color accent = Color(0xFF06B6D4); // Cyan
  
  // Colori per l'effetto glass
  static const Color glassBackground = Color(0x1AFFFFFF);
  static const Color glassBorder = Color(0x33FFFFFF);
  static const Color glassOverlay = Color(0x0DFFFFFF);
  
  // Gradienti
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary],
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0F0F23),
      Color(0xFF1A1A2E),
      Color(0xFF16213E),
    ],
  );
  
  // Colori di testo
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB4B6C7);
  static const Color textMuted = Color(0xFF6B7280);
  
  // Colori di stato
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);
}
