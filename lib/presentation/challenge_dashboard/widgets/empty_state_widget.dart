import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback? onCreateChallenge;

  const EmptyStateWidget({
    super.key,
    this.onCreateChallenge,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIllustration(colorScheme),
            SizedBox(height: 4.h),
            _buildTitle(theme),
            SizedBox(height: 2.h),
            _buildDescription(theme),
            SizedBox(height: 4.h),
            _buildCreateButton(theme),
            SizedBox(height: 2.h),
            _buildSuggestions(theme, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration(ColorScheme colorScheme) {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomIconWidget(
            iconName: 'emoji_events',
            color: colorScheme.primary.withValues(alpha: 0.3),
            size: 80,
          ),
          Positioned(
            top: 8.w,
            right: 8.w,
            child: Container(
              padding: EdgeInsets.all(1.w),
              decoration: BoxDecoration(
                color: AppTheme.getWarningColor(true),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'add',
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Text(
      'Start Your First Challenge',
      style: theme.textTheme.headlineSmall?.copyWith(
        fontSize: 22.sp,
        fontWeight: FontWeight.w600,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescription(ThemeData theme) {
    return Text(
      'Transform your goals into daily habits.\nTrack progress, build streaks, and celebrate achievements.',
      style: theme.textTheme.bodyLarge?.copyWith(
        fontSize: 14.sp,
        height: 1.5,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildCreateButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onCreateChallenge,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'add_circle',
              color: theme.colorScheme.onPrimary,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              'Create Your First Challenge',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestions(ThemeData theme, ColorScheme colorScheme) {
    final suggestions = [
      {
        'icon': 'fitness_center',
        'title': '30-Day Fitness',
        'description': 'Daily workout routine'
      },
      {
        'icon': 'menu_book',
        'title': 'Reading Challenge',
        'description': 'Read for 30 minutes daily'
      },
      {
        'icon': 'self_improvement',
        'title': 'Meditation',
        'description': '10 minutes of mindfulness'
      },
    ];

    return Column(
      children: [
        Text(
          'Popular Challenge Ideas',
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        ...suggestions
            .map((suggestion) => Container(
                  margin: EdgeInsets.only(bottom: 1.h),
                  child: InkWell(
                    onTap: onCreateChallenge,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: colorScheme.outline.withValues(alpha: 0.2),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: CustomIconWidget(
                              iconName: suggestion['icon'] as String,
                              color: colorScheme.primary,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  suggestion['title'] as String,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  suggestion['description'] as String,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontSize: 11.sp,
                                    color: colorScheme.onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CustomIconWidget(
                            iconName: 'arrow_forward_ios',
                            color: colorScheme.onSurface.withValues(alpha: 0.4),
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ))
            .toList(),
      ],
    );
  }
}
