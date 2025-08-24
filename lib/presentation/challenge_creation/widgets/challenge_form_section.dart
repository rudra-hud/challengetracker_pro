import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ChallengeFormSection extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final int selectedDuration;
  final String durationType;
  final DateTime selectedStartDate;
  final VoidCallback onDurationTap;
  final VoidCallback onStartDateTap;
  final Function(String) onTitleChanged;
  final Function(String) onDescriptionChanged;

  const ChallengeFormSection({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.selectedDuration,
    required this.durationType,
    required this.selectedStartDate,
    required this.onDurationTap,
    required this.onStartDateTap,
    required this.onTitleChanged,
    required this.onDescriptionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Challenge Title
        Text(
          'Challenge Title',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),

        TextFormField(
          controller: titleController,
          onChanged: onTitleChanged,
          maxLength: 50,
          decoration: InputDecoration(
            hintText: 'Enter your challenge title',
            counterText: '${titleController.text.length}/50',
            suffixIcon: titleController.text.isNotEmpty
                ? CustomIconWidget(
                    iconName: 'check_circle',
                    size: 20,
                    color: Colors.green,
                  )
                : null,
          ),
          textInputAction: TextInputAction.next,
        ),

        SizedBox(height: 3.h),

        // Challenge Description
        Text(
          'Description',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),

        TextFormField(
          controller: descriptionController,
          onChanged: onDescriptionChanged,
          maxLines: 4,
          maxLength: 200,
          decoration: InputDecoration(
            hintText: 'Describe your challenge goals and motivation...',
            counterText: '${descriptionController.text.length}/200',
            alignLabelWithHint: true,
          ),
          textInputAction: TextInputAction.newline,
        ),

        SizedBox(height: 3.h),

        // Duration and Start Date Row
        Row(
          children: [
            // Duration Selector
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Duration',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  GestureDetector(
                    onTap: onDurationTap,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        border: Border.all(color: colorScheme.outline),
                        borderRadius: BorderRadius.circular(8),
                        color: colorScheme.surface,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$selectedDuration $durationType',
                            style: theme.textTheme.bodyMedium,
                          ),
                          CustomIconWidget(
                            iconName: 'keyboard_arrow_down',
                            size: 20,
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 4.w),

            // Start Date Selector
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Start Date',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  GestureDetector(
                    onTap: onStartDateTap,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        border: Border.all(color: colorScheme.outline),
                        borderRadius: BorderRadius.circular(8),
                        color: colorScheme.surface,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${selectedStartDate.month}/${selectedStartDate.day}/${selectedStartDate.year}',
                            style: theme.textTheme.bodyMedium,
                          ),
                          CustomIconWidget(
                            iconName: 'calendar_today',
                            size: 20,
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
