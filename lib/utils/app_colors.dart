import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF1F3A5F);
  static const Color primaryDark = Color(0xFF13253D);
  static const Color secondary = Color(0xFF3D8BFF);
  static const Color background = Color(0xFFF7F8FA);
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF1A1F29);
  static const Color textSecondary = Color(0xFF667085);

  static const Color success = Color(0xFF1F9254);
  static const Color warning = Color(0xFFC9962C);
  static const Color danger = Color(0xFFD1443A);
  static const Color info = Color(0xFF1F3A5F);

  static Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return success;
      case 'completed':
        return info;
      case 'rejected':
        return danger;
      case 'pending':
      default:
        return warning;
    }
  }
}