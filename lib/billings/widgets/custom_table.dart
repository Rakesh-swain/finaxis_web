import 'package:finaxis_web/billings/billing_theme.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class CustomTableHeader extends StatelessWidget {
  final List<String> columns;
  final List<int> columnFlex;

  const CustomTableHeader({
    required this.columns,
    required this.columnFlex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.darkBg.withOpacity(0.5),
        border: Border(
          bottom: BorderSide(color: AppTheme.borderLight, width: 1),
        ),
      ),
      child: Row(
        children: List.generate(columns.length, (index) {
          return Expanded(
            flex: columnFlex[index],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Text(
                columns[index],
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textTertiary,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}


class CustomTableRow extends StatelessWidget {
  final List<Widget> cells;
  final List<int> columnFlex;

  const CustomTableRow({
    required this.cells,
    required this.columnFlex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: AppTheme.borderLight.withOpacity(0.5), width: 1),
        ),
      ),
      child: Row(
        children: List.generate(cells.length, (index) {
          return Expanded(
            flex: columnFlex[index],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: cells[index],
            ),
          );
        }),
      ),
    );
  }
}


class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge(this.status);

  @override
  Widget build(BuildContext context) {
    final color = ColorConfig.statusColors[status] ?? AppTheme.statusPending;
    final label = ColorConfig.statusLabels[status] ?? status;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}