import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class TimelineDateHeader extends StatelessWidget {
  final String date;
  final int entryCount;
  final bool isToday;

  const TimelineDateHeader({
    super.key,
    required this.date,
    required this.entryCount,
    this.isToday = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: isToday ? colorScheme.primary : colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isToday
                    ? colorScheme.primary
                    : colorScheme.outline.withValues(alpha: 0.3),
              ),
              boxShadow: isToday
                  ? [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isToday) ...[
                  CustomIconWidget(
                    iconName: 'today',
                    color: colorScheme.onPrimary,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                ],
                Text(
                  date,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color:
                        isToday ? colorScheme.onPrimary : colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 2.w),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: isToday
                        ? colorScheme.onPrimary.withValues(alpha: 0.2)
                        : colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$entryCount',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color:
                          isToday ? colorScheme.onPrimary : colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.outline.withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
