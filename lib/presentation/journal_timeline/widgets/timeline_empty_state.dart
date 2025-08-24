import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class TimelineEmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final bool isSearchResult;

  const TimelineEmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    this.actionText,
    this.onActionPressed,
    this.isSearchResult = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: isSearchResult ? 'search_off' : 'book',
                  color: colorScheme.primary,
                  size: 48,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              subtitle,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionText != null && onActionPressed != null) ...[
              SizedBox(height: 4.h),
              ElevatedButton.icon(
                onPressed: onActionPressed,
                icon: CustomIconWidget(
                  iconName: 'add',
                  color: colorScheme.onPrimary,
                  size: 20,
                ),
                label: Text(actionText!),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  factory TimelineEmptyState.noEntries({VoidCallback? onCreateEntry}) {
    return TimelineEmptyState(
      title: 'Start Your Journey',
      subtitle:
          'Begin documenting your challenges and progress. Every great journey starts with a single entry.',
      actionText: 'Create First Entry',
      onActionPressed: onCreateEntry,
    );
  }

  factory TimelineEmptyState.noSearchResults({required String query}) {
    return TimelineEmptyState(
      title: 'No Results Found',
      subtitle:
          'We couldn\'t find any entries matching "$query". Try adjusting your search terms or filters.',
      isSearchResult: true,
    );
  }

  factory TimelineEmptyState.noFilterResults() {
    return TimelineEmptyState(
      title: 'No Matching Entries',
      subtitle:
          'No entries match your current filters. Try adjusting your filter criteria to see more results.',
      isSearchResult: true,
    );
  }
}
