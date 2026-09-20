import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:fvelox/core/design_system/fvelox_design_system.dart';

class PinWaveLoading extends StatefulWidget {
  const PinWaveLoading({required this.label, super.key});

  final String label;

  @override
  State<PinWaveLoading> createState() => _PinWaveLoadingState();
}

class _PinWaveLoadingState extends State<PinWaveLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final design = FveloxDesignSystem.of(context);
    return Semantics(
      label: widget.label,
      liveRegion: true,
      child: SizedBox(
        height: 24,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                final phase = (_controller.value + index * 0.16) % 1;
                final wave = (math.sin(phase * math.pi * 2) + 1) / 2;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 7 + wave * 2,
                  height: 7 + wave * 2,
                  decoration: BoxDecoration(
                    color: design.colors.green.withValues(
                      alpha: 0.35 + wave * 0.65,
                    ),
                    shape: BoxShape.circle,
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}
