import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class GoalSettingSection extends StatelessWidget {
  final String goalType;
  final int numericGoal;
  final String goalUnit;
  final Function(String) onGoalTypeChanged;
  final Function(int) onNumericGoalChanged;
  final Function(String) onGoalUnitChanged;

  const GoalSettingSection({
    super.key,
    required this.goalType,
    required this.numericGoal,
    required this.goalUnit,
    required this.onGoalTypeChanged,
    required this.onNumericGoalChanged,
    required this.onGoalUnitChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Goal Setting',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),

        // Goal Type Selection
        Text(
          'Goal Type',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),

        Row(
          children: [
            Expanded(
              child: _buildGoalTypeChip(
                context,
                'Daily',
                goalType == 'Daily',
                () => onGoalTypeChanged('Daily'),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: _buildGoalTypeChip(
                context,
                'Weekly',
                goalType == 'Weekly',
                () => onGoalTypeChanged('Weekly'),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: _buildGoalTypeChip(
                context,
                'Total',
                goalType == 'Total',
                () => onGoalTypeChanged('Total'),
              ),
            ),
          ],
        ),

        SizedBox(height: 3.h),

        // Numeric Goal Setting
        goalType != 'Completion'
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Target Amount',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 1.h),

                  Row(
                    children: [
                      // Decrement Button
                      GestureDetector(
                        onTap: () {
                          if (numericGoal > 1) {
                            onNumericGoalChanged(numericGoal - 1);
                          }
                        },
                        child: Container(
                          width: 12.w,
                          height: 6.h,
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: colorScheme.primary),
                          ),
                          child: Center(
                            child: CustomIconWidget(
                              iconName: 'remove',
                              size: 20,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 4.w),

                      // Goal Value Display
                      Expanded(
                        child: Container(
                          height: 6.h,
                          decoration: BoxDecoration(
                            border: Border.all(color: colorScheme.outline),
                            borderRadius: BorderRadius.circular(8),
                            color: colorScheme.surface,
                          ),
                          child: Center(
                            child: Text(
                              numericGoal.toString(),
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 4.w),

                      // Increment Button
                      GestureDetector(
                        onTap: () => onNumericGoalChanged(numericGoal + 1),
                        child: Container(
                          width: 12.w,
                          height: 6.h,
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: colorScheme.primary),
                          ),
                          child: Center(
                            child: CustomIconWidget(
                              iconName: 'add',
                              size: 20,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  // Goal Unit Selection
                  Text(
                    'Unit',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 1.h),

                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children:
                        ['minutes', 'hours', 'pages', 'reps', 'miles', 'custom']
                            .map((unit) => _buildUnitChip(
                                  context,
                                  unit,
                                  goalUnit == unit,
                                  () => onGoalUnitChanged(unit),
                                ))
                            .toList(),
                  ),
                ],
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  Widget _buildGoalTypeChip(
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

  Widget _buildUnitChip(
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
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withValues(alpha: 0.1)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: isSelected ? colorScheme.primary : colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
