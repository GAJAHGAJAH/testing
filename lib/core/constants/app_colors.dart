import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF1565C0);
  static const Color primaryLight = Color(0xFF5E92F3);
  static const Color primaryDark = Color(0xFF003C8F);
  
  // Background Colors
  static const Color background = Colors.white;
  static const Color surface = Colors.white;
  static const Color cardBackground = Color(0xFFF5F5F5);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFF9E9E9E);
  static const Color textWhite = Colors.white;
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);
  
  // Border & Divider Colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFBDBDBD);
  
  // Input Field Colors
  static const Color inputBackground = Color(0xFFF5F5F5);
  static const Color inputBorder = Color(0xFFE0E0E0);
  static const Color inputFocusedBorder = primary;
  
  // Button Colors
  static const Color buttonPrimary = primary;
  static const Color buttonSecondary = Colors.white;
  static const Color buttonDisabled = Color(0xFFBDBDBD);
  
  // Google Button
  static const Color googleButtonBorder = Color(0xFFDADCE0);
  static const Color googleButtonText = Color(0xFF3C4043);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}