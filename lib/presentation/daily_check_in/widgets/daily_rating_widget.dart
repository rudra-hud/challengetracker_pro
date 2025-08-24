import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DailyRatingWidget extends StatefulWidget {
  final double? selectedRating;
  final Function(double) onRatingChanged;

  const DailyRatingWidget({
    super.key,
    this.selectedRating,
    required this.onRatingChanged,
  });

  @override
  State<DailyRatingWidget> createState() => _DailyRatingWidgetState();
}

class _DailyRatingWidgetState extends State<DailyRatingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  double _currentRating = 5.0;

  final Map<int, String> _ratingLabels = {
    1: 'Very Poor',
    2: 'Poor',
    3: 'Below Average',
    4: 'Average',
    5: 'Good',
    6: 'Above Average',
    7: 'Very Good',
    8: 'Great',
    9: 'Excellent',
    10: 'Outstanding',
  };

  final Map<int, Color> _ratingColors = {
    1: Colors.red[700]!,
    2: Colors.red[600]!,
    3: Colors.orange[700]!,
    4: Colors.orange[600]!,
    5: Colors.yellow[700]!,
    6: Colors.yellow[600]!,
    7: Colors.lightGreen[600]!,
    8: Colors.lightGreen[700]!,
    9: Colors.green[600]!,
    10: Colors.green[700]!,
  };

  @override
  void initState() {
    super.initState();
    _currentRating = widget.selectedRating ?? 5.0;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
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

  void _onRatingChanged(double rating) {
    HapticFeedback.selectionClick();
    setState(() {
      _currentRating = rating;
    });
    widget.onRatingChanged(rating);

    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  Color _getRatingColor(double rating) {
    final roundedRating = rating.round();
    return _ratingColors[roundedRating] ??
        AppTheme.lightTheme.colorScheme.primary;
  }

  String _getRatingLabel(double rating) {
    final roundedRating = rating.round();
    return _ratingLabels[roundedRating] ?? 'Good';
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
                iconName: 'star_rate',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Rate Your Day',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Rating Display
          Center(
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Column(
                    children: [
                      Container(
                        width: 20.w,
                        height: 20.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _getRatingColor(_currentRating)
                              .withValues(alpha: 0.1),
                          border: Border.all(
                            color: _getRatingColor(_currentRating),
                            width: 3,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _currentRating.toInt().toString(),
                            style: AppTheme.lightTheme.textTheme.headlineMedium
                                ?.copyWith(
                              color: _getRatingColor(_currentRating),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        _getRatingLabel(_currentRating),
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: _getRatingColor(_currentRating),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 3.h),

          // Slider
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: _getRatingColor(_currentRating),
              inactiveTrackColor:
                  _getRatingColor(_currentRating).withValues(alpha: 0.3),
              thumbColor: _getRatingColor(_currentRating),
              overlayColor:
                  _getRatingColor(_currentRating).withValues(alpha: 0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
              trackHeight: 6,
              valueIndicatorColor: _getRatingColor(_currentRating),
              valueIndicatorTextStyle:
                  AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: Slider(
              value: _currentRating,
              min: 1.0,
              max: 10.0,
              divisions: 9,
              label: '${_currentRating.toInt()}/10',
              onChanged: _onRatingChanged,
            ),
          ),

          // Scale Labels
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      '1',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: Colors.red[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Poor',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '5',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: Colors.yellow[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Average',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '10',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: Colors.green[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Outstanding',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Rating Context
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
            decoration: BoxDecoration(
              color: _getRatingColor(_currentRating).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'info_outline',
                  color: _getRatingColor(_currentRating),
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    _getRatingDescription(_currentRating),
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: _getRatingColor(_currentRating),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getRatingDescription(double rating) {
    if (rating <= 3) {
      return 'Consider what made today challenging and how you can improve tomorrow.';
    } else if (rating <= 6) {
      return 'A decent day with room for growth. What could make tomorrow better?';
    } else if (rating <= 8) {
      return 'Great progress! You\'re building positive momentum.';
    } else {
      return 'Outstanding day! You\'re crushing your goals and building strong habits.';
    }
  }
}
