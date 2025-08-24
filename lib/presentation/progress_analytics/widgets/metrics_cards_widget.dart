import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class MetricsCardsWidget extends StatelessWidget {
  final int currentStreak;
  final int totalCompletions;
  final double completionRate;
  final double averageMoodRating;
  final int streakTrend;
  final int completionsTrend;
  final double rateTrend;
  final double moodTrend;

  const MetricsCardsWidget({
    super.key,
    required this.currentStreak,
    required this.totalCompletions,
    required this.completionRate,
    required this.averageMoodRating,
    required this.streakTrend,
    required this.completionsTrend,
    required this.rateTrend,
    required this.moodTrend,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                context,
                'Current Streak',
                '$currentStreak days',
                streakTrend.toDouble(),
                CustomIconWidget(
                  iconName: 'local_fire_department',
                  color: Colors.orange,
                  size: 24,
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: _buildMetricCard(
                context,
                'Total Completions',
                '$totalCompletions',
                completionsTrend.toDouble(),
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 3.w),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                context,
                'Completion Rate',
                '${completionRate.toStringAsFixed(1)}%',
                rateTrend,
                CustomIconWidget(
                  iconName: 'trending_up',
                  color: Colors.green,
                  size: 24,
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: _buildMetricCard(
                context,
                'Avg Mood',
                '${averageMoodRating.toStringAsFixed(1)}/5',
                moodTrend,
                CustomIconWidget(
                  iconName: 'sentiment_satisfied',
                  color: Colors.amber,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    String title,
    String value,
    double trend,
    Widget icon,
  ) {
    final theme = Theme.of(context);
    final isPositiveTrend = trend > 0;
    final isNeutralTrend = trend == 0;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              icon,
              if (!isNeutralTrend)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isPositiveTrend
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName:
                            isPositiveTrend ? 'arrow_upward' : 'arrow_downward',
                        color: isPositiveTrend ? Colors.green : Colors.red,
                        size: 12,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${trend.abs().toStringAsFixed(0)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isPositiveTrend ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}