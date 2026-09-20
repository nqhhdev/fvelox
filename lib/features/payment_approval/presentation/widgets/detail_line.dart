import 'package:flutter/material.dart';

import 'package:fvelox/core/design_system/fvelox_design_system.dart';

class DetailLine extends StatelessWidget {
  const DetailLine({required this.label, required this.value, super.key});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    final design = FveloxDesignSystem.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: design.colors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: design.typography.detailLabel.copyWith(
              color: design.colors.muted,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: design.typography.detailValue,
            ),
          ),
        ],
      ),
    );
  }
}
