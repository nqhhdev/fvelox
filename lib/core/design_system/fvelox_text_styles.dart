import 'package:flutter/material.dart';

final class FveloxTextStyles {
  const FveloxTextStyles({
    required this.brand,
    required this.hero,
    required this.pageTitle,
    required this.detailTitle,
    required this.sectionTitle,
    required this.sheetTitle,
    required this.heroAmount,
    required this.body,
    required this.bodyMuted,
    required this.caption,
    required this.error,
    required this.button,
    required this.rowTitle,
    required this.rowAmount,
    required this.detailLabel,
    required this.detailValue,
    required this.eyebrow,
    required this.avatar,
    required this.summaryLabel,
    required this.summaryAmount,
    required this.summaryCount,
    required this.badge,
  });

  static const light = FveloxTextStyles(
    brand: TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.w800,
      letterSpacing: -1.7,
    ),
    hero: TextStyle(
      fontSize: 38,
      height: .98,
      fontWeight: FontWeight.w800,
      letterSpacing: -2.2,
    ),
    pageTitle: TextStyle(
      fontSize: 34,
      fontWeight: FontWeight.w800,
      letterSpacing: -1.7,
    ),
    detailTitle: TextStyle(
      fontSize: 32,
      height: 1,
      fontWeight: FontWeight.w800,
      letterSpacing: -1.5,
    ),
    sectionTitle: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
    sheetTitle: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
    heroAmount: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w800,
      letterSpacing: -2,
    ),
    body: TextStyle(fontSize: 13),
    bodyMuted: TextStyle(fontSize: 13),
    caption: TextStyle(fontSize: 12),
    error: TextStyle(fontSize: 12),
    button: TextStyle(fontWeight: FontWeight.w800),
    rowTitle: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
    rowAmount: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
    detailLabel: TextStyle(fontSize: 13),
    detailValue: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
    eyebrow: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w800,
      letterSpacing: 1.5,
    ),
    avatar: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
    summaryLabel: TextStyle(fontSize: 12),
    summaryAmount: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w800,
      letterSpacing: -2,
    ),
    summaryCount: TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
    badge: TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
  );

  final TextStyle brand;
  final TextStyle hero;
  final TextStyle pageTitle;
  final TextStyle detailTitle;
  final TextStyle sectionTitle;
  final TextStyle sheetTitle;
  final TextStyle heroAmount;
  final TextStyle body;
  final TextStyle bodyMuted;
  final TextStyle caption;
  final TextStyle error;
  final TextStyle button;
  final TextStyle rowTitle;
  final TextStyle rowAmount;
  final TextStyle detailLabel;
  final TextStyle detailValue;
  final TextStyle eyebrow;
  final TextStyle avatar;
  final TextStyle summaryLabel;
  final TextStyle summaryAmount;
  final TextStyle summaryCount;
  final TextStyle badge;
}
