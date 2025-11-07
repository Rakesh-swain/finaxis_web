import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final double percentage;
  final IconData icon;

  const KpiCard({
    super.key,
    required this.title,
    required this.value,
    required this.percentage,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPositive = percentage >= 0;
    final Color trendColor = isPositive ? AppTheme.ragGreen : AppTheme.ragRed;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: AppTheme.lightAccent, size: 28),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: trendColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 14,
                        color: trendColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${percentage.abs().toStringAsFixed(1)}%',
                        style: TextStyle(
                          color: trendColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'MoM Change',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}
