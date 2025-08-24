import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MoodTrackingWidget extends StatefulWidget {
  final int? selectedMood;
  final Function(int) onMoodSelected;

  const MoodTrackingWidget({
    super.key,
    this.selectedMood,
    required this.onMoodSelected,
  });

  @override
  State<MoodTrackingWidget> createState() => _MoodTrackingWidgetState();
}

class _MoodTrackingWidgetState extends State<MoodTrackingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  final List<Map<String, dynamic>> _moods = [
    {'emoji': '😔', 'label': 'Struggling', 'value': 1},
    {'emoji': '😐', 'label': 'Neutral', 'value': 2},
    {'emoji': '😊', 'label': 'Good', 'value': 3},
    {'emoji': '😄', 'label': 'Great', 'value': 4},
    {'emoji': '🎉', 'label': 'Amazing', 'value': 5},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectMood(int moodValue) {
    HapticFeedback.lightImpact();
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    widget.onMoodSelected(moodValue);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'mood',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'How are you feeling?',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Mood Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _moods.map((mood) {
              final isSelected = widget.selectedMood == mood['value'];
              return GestureDetector(
                onTap: () => _selectMood(mood['value']),
                child: AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: isSelected && widget.selectedMood == mood['value']
                          ? _scaleAnimation.value
                          : 1.0,
                      child: Column(
                        children: [
                          Container(
                            width: 12.w,
                            height: 12.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? AppTheme.lightTheme.colorScheme.primary
                                      .withValues(alpha: 0.1)
                                  : Colors.transparent,
                              border: Border.all(
                                color: isSelected
                                    ? AppTheme.lightTheme.colorScheme.primary
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                mood['emoji'],
                                style: TextStyle(fontSize: 24.sp),
                              ),
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            mood['label'],
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: isSelected
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : AppTheme.lightTheme.colorScheme.onSurface
                                      .withValues(alpha: 0.7),
                              fontWeight: isSelected
                                  ? FontWeight.w500
                                  : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          ),

          if (widget.selectedMood != null) ...[
            SizedBox(height: 2.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text(
                    _moods.firstWhere((mood) =>
                        mood['value'] == widget.selectedMood)['emoji'],
                    style: TextStyle(fontSize: 18.sp),
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'You\'re feeling ${_moods.firstWhere((mood) => mood['value'] == widget.selectedMood)['label'].toLowerCase()} today',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
