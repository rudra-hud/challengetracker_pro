import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickCheckInModal extends StatefulWidget {
  final Map<String, dynamic> challenge;
  final Function(Map<String, dynamic>) onCheckIn;

  const QuickCheckInModal({
    super.key,
    required this.challenge,
    required this.onCheckIn,
  });

  @override
  State<QuickCheckInModal> createState() => _QuickCheckInModalState();
}

class _QuickCheckInModalState extends State<QuickCheckInModal> {
  int selectedMood = 3;
  String notes = '';
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(colorScheme),
          SizedBox(height: 2.h),
          _buildHeader(theme),
          SizedBox(height: 3.h),
          _buildMoodSelector(theme, colorScheme),
          SizedBox(height: 3.h),
          _buildNotesSection(theme, colorScheme),
          SizedBox(height: 3.h),
          _buildActionButtons(theme),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildHandle(ColorScheme colorScheme) {
    return Container(
      width: 12.w,
      height: 0.5.h,
      decoration: BoxDecoration(
        color: colorScheme.outline.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    final title = widget.challenge['title'] as String? ?? 'Challenge';

    return Column(
      children: [
        Text(
          'Quick Check-In',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 14.sp,
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildMoodSelector(ThemeData theme, ColorScheme colorScheme) {
    final moods = [
      {'emoji': '😔', 'label': 'Struggling', 'value': 1},
      {'emoji': '😐', 'label': 'Okay', 'value': 2},
      {'emoji': '😊', 'label': 'Good', 'value': 3},
      {'emoji': '😄', 'label': 'Great', 'value': 4},
      {'emoji': '🔥', 'label': 'Amazing', 'value': 5},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How are you feeling today?',
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: moods.map((mood) {
            final isSelected = selectedMood == mood['value'];

            return GestureDetector(
              onTap: () => setState(() => selectedMood = mood['value'] as int),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 2.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.primary.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.outline.withValues(alpha: 0.2),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      mood['emoji'] as String,
                      style: TextStyle(fontSize: 20.sp),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      mood['label'] as String,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildNotesSection(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick notes (optional)',
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextField(
          controller: _notesController,
          maxLines: 3,
          maxLength: 200,
          decoration: InputDecoration(
            hintText: 'How did today go? Any insights or challenges?',
            hintStyle: TextStyle(
              fontSize: 12.sp,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.all(3.w),
          ),
          onChanged: (value) => notes = value,
        ),
      ],
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 1.8.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: _handleCheckIn,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 1.8.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: theme.colorScheme.onPrimary,
                  size: 18,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Complete Check-In',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _handleCheckIn() {
    final checkInData = {
      'challengeId': widget.challenge['id'],
      'date': DateTime.now().toIso8601String(),
      'mood': selectedMood,
      'notes': _notesController.text.trim(),
      'completed': true,
    };

    widget.onCheckIn(checkInData);
    Navigator.pop(context);

    // Show success feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 2.w),
            const Text('Check-in completed successfully!'),
          ],
        ),
        backgroundColor: AppTheme.getSuccessColor(true),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
