import 'package:flutter/material.dart';

final class FveloxColorTokens {
  const FveloxColorTokens({
    required this.ink,
    required this.muted,
    required this.cream,
    required this.paper,
    required this.green,
    required this.greenDark,
    required this.lime,
    required this.red,
    required this.white,
    required this.softGreen,
    required this.softRed,
    required this.border,
    required this.borderStrong,
    required this.summaryStart,
    required this.summaryEnd,
    required this.summaryLabel,
    required this.summaryAmount,
    required this.summaryCount,
    required this.shadow,
  });

  static const light = FveloxColorTokens(
    ink: Color(0xFF14201C),
    muted: Color(0xFF78827C),
    cream: Color(0xFFF6F3EC),
    paper: Color(0xFFFFFDF8),
    green: Color(0xFF126B52),
    greenDark: Color(0xFF0B4D3D),
    lime: Color(0xFFD9E88B),
    red: Color(0xFFB65D5B),
    white: Colors.white,
    softGreen: Color(0xFFE7F0DB),
    softRed: Color(0xFFF7E8E5),
    border: Color(0x1A14201C),
    borderStrong: Color(0x1A182B22),
    summaryStart: Color(0xFF1C6F58),
    summaryEnd: Color(0xFF0D4C3D),
    summaryLabel: Color(0xB8EFF4D6),
    summaryAmount: Color(0xFFEFF4D6),
    summaryCount: Color(0xFFF3F7DC),
    shadow: Color(0x1F182B22),
  );

  final Color ink;
  final Color muted;
  final Color cream;
  final Color paper;
  final Color green;
  final Color greenDark;
  final Color lime;
  final Color red;
  final Color white;
  final Color softGreen;
  final Color softRed;
  final Color border;
  final Color borderStrong;
  final Color summaryStart;
  final Color summaryEnd;
  final Color summaryLabel;
  final Color summaryAmount;
  final Color summaryCount;
  final Color shadow;
}
