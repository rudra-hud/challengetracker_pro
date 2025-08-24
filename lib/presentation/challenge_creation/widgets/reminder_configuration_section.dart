import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ReminderConfigurationSection extends StatelessWidget {
  final TimeOfDay reminderTime;
  final String reminderFrequency;
  final List<String> selectedDays;
  final VoidCallback onTimeSelect;
  final Function(String) onFrequencyChanged;
  final Function(String) onDayToggle;

  const ReminderConfigurationSection({
    super.key,
    required this.reminderTime,
    required this.reminderFrequency,
    required this.selectedDays,
    required this.onTimeSelect,
    required this.onFrequencyChanged,
    required this.onDayToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reminder Settings',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),

        // Reminder Time
        Text(
          'Reminder Time',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),

        GestureDetector(
          onTap: onTimeSelect,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
            decoration: BoxDecoration(
              border: Border.all(color: colorScheme.outline),
              borderRadius: BorderRadius.circular(8),
              color: colorScheme.surface,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'access_time',
                      size: 20,
                      color: colorScheme.primary,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      reminderTime.format(context),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                CustomIconWidget(
                  iconName: 'keyboard_arrow_right',
                  size: 20,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 3.h),

        // Reminder Frequency
        Text(
          'Frequency',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),

        Row(
          children: [
            Expanded(
              child: _buildFrequencyChip(
                context,
                'Daily',
                reminderFrequency == 'Daily',
                () => onFrequencyChanged('Daily'),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: _buildFrequencyChip(
                context,
                'Weekdays',
                reminderFrequency == 'Weekdays',
                () => onFrequencyChanged('Weekdays'),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: _buildFrequencyChip(
                context,
                'Custom',
                reminderFrequency == 'Custom',
                () => onFrequencyChanged('Custom'),
              ),
            ),
          ],
        ),

        // Custom Days Selection
        reminderFrequency == 'Custom'
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),
                  Text(
                    'Select Days',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                        .map((day) => _buildDayChip(
                              context,
                              day,
                              selectedDays.contains(day),
                              () => onDayToggle(day),
                            ))
                        .toList(),
                  ),
                ],
              )
            : const SizedBox.shrink(),

        SizedBox(height: 3.h),

        // Reminder Preview
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'notifications',
                size: 20,
                color: colorScheme.primary,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  _getReminderPreviewText(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFrequencyChip(
    BuildContext context,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.outline,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDayChip(
    BuildContext context,
    String day,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 12.w,
        height: 5.h,
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.outline,
          ),
        ),
        child: Center(
          child: Text(
            day,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  String _getReminderPreviewText() {
    // Cannot access context in this method since it's not part of build method
    // Use a simple time format instead
    String timeText = '${reminderTime.hour.toString().padLeft(2, '0')}:${reminderTime.minute.toString().padLeft(2, '0')}';

    switch (reminderFrequency) {
      case 'Daily':
        return 'Daily reminder at $timeText';
      case 'Weekdays':
        return 'Weekday reminders at $timeText';
      case 'Custom':
        if (selectedDays.isEmpty) {
          return 'Select days for custom reminders';
        }
        return '${selectedDays.join(', ')} at $timeText';
      default:
        return 'Reminder at $timeText';
    }
  }
}