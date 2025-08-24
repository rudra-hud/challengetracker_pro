import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TimelineEntryCard extends StatelessWidget {
  final Map<String, dynamic> entry;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const TimelineEntryCard({
    super.key,
    required this.entry,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                SizedBox(height: 2.h),
                _buildContent(context),
                if ((entry['photos'] as List?)?.isNotEmpty == true) ...[
                  SizedBox(height: 2.h),
                  _buildPhotoGrid(context),
                ],
                SizedBox(height: 2.h),
                _buildFooter(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            entry['mood'] as String? ?? '😊',
            style: TextStyle(fontSize: 16.sp),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry['date'] as String? ?? 'Today',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                entry['time'] as String? ?? '12:00 PM',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
          decoration: BoxDecoration(
            color: (entry['isCompleted'] as bool? ?? false)
                ? AppTheme.getSuccessColor(theme.brightness == Brightness.light)
                : AppTheme.getWarningColor(
                    theme.brightness == Brightness.light),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            (entry['isCompleted'] as bool? ?? false) ? 'Completed' : 'Pending',
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final content = entry['content'] as String? ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          content,
          style: theme.textTheme.bodyMedium,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        if (content.length > 150) ...[
          SizedBox(height: 1.h),
          Text(
            'Read more...',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPhotoGrid(BuildContext context) {
    final photos = (entry['photos'] as List?) ?? [];
    if (photos.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 15.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: photos.length > 3 ? 3 : photos.length,
        itemBuilder: (context, index) {
          if (index == 2 && photos.length > 3) {
            return _buildMorePhotosIndicator(context, photos.length - 2);
          }

          return Container(
            width: 20.w,
            margin: EdgeInsets.only(right: 2.w),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CustomImageWidget(
                imageUrl: photos[index] as String,
                width: 20.w,
                height: 15.h,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMorePhotosIndicator(BuildContext context, int remainingCount) {
    final theme = Theme.of(context);

    return Container(
      width: 20.w,
      height: 15.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'add_photo_alternate',
              color: theme.colorScheme.primary,
              size: 24,
            ),
            SizedBox(height: 1.h),
            Text(
              '+$remainingCount',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final tags = (entry['tags'] as List?)?.cast<String>() ?? [];
    final wordCount = entry['wordCount'] as int? ?? 0;

    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: 'text_fields',
                color: colorScheme.primary,
                size: 14,
              ),
              SizedBox(width: 1.w),
              Text(
                '$wordCount words',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: Wrap(
            spacing: 1.w,
            runSpacing: 0.5.h,
            children:
                tags.take(3).map((tag) => _buildTagChip(context, tag)).toList(),
          ),
        ),
        if (tags.length > 3)
          Text(
            '+${tags.length - 3}',
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
      ],
    );
  }

  Widget _buildTagChip(BuildContext context, String tag) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Color coding for different tag types
    Color chipColor;
    if (tag.toLowerCase().contains('struggle')) {
      chipColor =
          AppTheme.getWarningColor(theme.brightness == Brightness.light);
    } else if (tag.toLowerCase().contains('breakthrough')) {
      chipColor =
          AppTheme.getSuccessColor(theme.brightness == Brightness.light);
    } else {
      chipColor = colorScheme.secondary;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: chipColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        tag.startsWith('#') ? tag : '#$tag',
        style: theme.textTheme.labelSmall?.copyWith(
          color: chipColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
