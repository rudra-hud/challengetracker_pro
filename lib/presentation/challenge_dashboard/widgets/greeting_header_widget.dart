import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GreetingHeaderWidget extends StatelessWidget {
  final String userName;
  final int currentStreak;
  final int longestStreak;
  final DateTime currentDate;

  const GreetingHeaderWidget({
    super.key,
    required this.userName,
    required this.currentStreak,
    required this.longestStreak,
    required this.currentDate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGreeting(theme),
          SizedBox(height: 1.h),
          _buildDateAndStreak(theme, colorScheme),
        ],
      ),
    );
  }

  Widget _buildGreeting(ThemeData theme) {
    final greeting = _getGreeting();

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                userName,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 16.sp,
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        _buildStreakBadge(theme),
      ],
    );
  }

  Widget _buildDateAndStreak(ThemeData theme, ColorScheme colorScheme) {
    final formattedDate = _formatDate(currentDate);

    return Row(
      children: [
        Expanded(
          child: Text(
            formattedDate,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 13.sp,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ),
        if (longestStreak > 0) ...[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: colorScheme.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'emoji_events',
                  color: colorScheme.secondary,
                  size: 14,
                ),
                SizedBox(width: 1.w),
                Text(
                  'Best: $longestStreak days',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStreakBadge(ThemeData theme) {
    if (currentStreak == 0) return const SizedBox.shrink();

    final colorScheme = theme.colorScheme;
    final streakColor = currentStreak >= 7
        ? AppTheme.getSuccessColor(theme.brightness == Brightness.light)
        : currentStreak >= 3
            ? AppTheme.getWarningColor(theme.brightness == Brightness.light)
            : colorScheme.primary;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: streakColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: streakColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: 'local_fire_department',
                color: streakColor,
                size: 20,
              ),
              SizedBox(width: 1.w),
              Text(
                '$currentStreak',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: streakColor,
                ),
              ),
            ],
          ),
          Text(
            currentStreak == 1 ? 'day' : 'days',
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.w500,
              color: streakColor,
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good Morning,';
    } else if (hour < 17) {
      return 'Good Afternoon,';
    } else {
      return 'Good Evening,';
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    final weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    final weekday = weekdays[date.weekday - 1];
    final month = months[date.month - 1];
    final day = date.day;

    return '$weekday, $month $day';
  }
}
