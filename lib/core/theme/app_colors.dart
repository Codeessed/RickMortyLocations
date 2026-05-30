import 'package:flutter/material.dart';

/// Rick & Morty–inspired color palette.
///
/// These are the single source of truth for every color in the app.
/// Widgets must use [AppColors] or [ThemeData] — never inline hex values.
abstract final class AppColors {
  // ── Primary (Portal Green) ───────────────────────────────────────────
  static const Color portalGreen = Color(0xFF00B74A);
  static const Color portalGreenLight = Color(0xFF69F0AE);
  static const Color portalGreenDark = Color(0xFF00873A);

  // ── Accent (Morty Yellow) ────────────────────────────────────────────
  static const Color mortyYellow = Color(0xFFF5E960);

  // ── Background ───────────────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF1A1A2E);
  static const Color darkSurface = Color(0xFF16213E);
  static const Color darkCard = Color(0xFF0F3460);

  // ── Text ─────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFF0F0F0);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textMuted = Color(0xFF6C6C6C);

  // ── Status (Character status badges) ─────────────────────────────────
  static const Color statusAlive = Color(0xFF55CC44);
  static const Color statusDead = Color(0xFFD63D2E);
  static const Color statusUnknown = Color(0xFF9E9E9E);

  // ── Semantic ─────────────────────────────────────────────────────────
  static const Color error = Color(0xFFCF6679);
  static const Color divider = Color(0xFF2A2A4A);
}
