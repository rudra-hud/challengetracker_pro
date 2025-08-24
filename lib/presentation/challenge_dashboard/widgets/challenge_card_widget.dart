import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ChallengeCardWidget extends StatefulWidget {
  final Map<String, dynamic> challenge;
  final VoidCallback? onCheckIn;
  final VoidCallback? onViewProgress;
  final VoidCallback? onEdit;
  final VoidCallback? onShare;
  final VoidCallback? onArchive;
  final VoidCallback? onDelete;

  const ChallengeCardWidget({
    super.key,
    required this.challenge,
    this.onCheckIn,
    this.onViewProgress,
    this.onEdit,
    this.onShare,
    this.onArchive,
    this.onDelete,
  });

  @override
  State<ChallengeCardWidget> createState() => _ChallengeCardWidgetState();
}

class _ChallengeCardWidgetState extends State<ChallengeCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Start pulsing animation if check-in is pending
    if (!(widget.challenge['isCheckedInToday'] as bool? ?? false)) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final title = widget.challenge['title'] as String? ?? 'Untitled Challenge';
    final currentDay = widget.challenge['currentDay'] as int? ?? 0;
    final totalDays = widget.challenge['totalDays'] as int? ?? 100;
    final completionPercentage =
        widget.challenge['completionPercentage'] as double? ?? 0.0;
    final isCheckedInToday =
        widget.challenge['isCheckedInToday'] as bool? ?? false;
    final category = widget.challenge['category'] as String? ?? 'General';
    final color = Color(widget.challenge['color'] as int? ?? 0xFF2E7D32);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: widget.onViewProgress,
          onLongPress: () => _showContextMenu(context),
          child: Container(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(colorScheme, color, category),
                SizedBox(height: 2.h),
                _buildTitle(theme, title),
                SizedBox(height: 1.h),
                _buildProgressSection(
                    theme, currentDay, totalDays, completionPercentage),
                SizedBox(height: 2.h),
                _buildActionButtons(theme, isCheckedInToday),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
      ColorScheme colorScheme, Color challengeColor, String category) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
          decoration: BoxDecoration(
            color: challengeColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            category,
            style: TextStyle(
              color: challengeColor,
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        PopupMenuButton<String>(
          icon: CustomIconWidget(
            iconName: 'more_vert',
            color: colorScheme.onSurface.withValues(alpha: 0.6),
            size: 20,
          ),
          onSelected: (value) => _handleMenuAction(value),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'edit',
                    color: colorScheme.onSurface,
                    size: 18,
                  ),
                  SizedBox(width: 3.w),
                  const Text('Edit'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'share',
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'share',
                    color: colorScheme.onSurface,
                    size: 18,
                  ),
                  SizedBox(width: 3.w),
                  const Text('Share'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'archive',
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'archive',
                    color: colorScheme.onSurface,
                    size: 18,
                  ),
                  SizedBox(width: 3.w),
                  const Text('Archive'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'delete',
                    color: AppTheme.lightTheme.colorScheme.error,
                    size: 18,
                  ),
                  SizedBox(width: 3.w),
                  const Text('Delete'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTitle(ThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 16.sp,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildProgressSection(ThemeData theme, int currentDay, int totalDays,
      double completionPercentage) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Day $currentDay of $totalDays',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 0.5.h),
              LinearProgressIndicator(
                value: completionPercentage / 100,
                backgroundColor:
                    theme.colorScheme.outline.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color(widget.challenge['color'] as int? ?? 0xFF2E7D32),
                ),
                minHeight: 6,
              ),
            ],
          ),
        ),
        SizedBox(width: 4.w),
        _buildProgressRing(theme, completionPercentage),
      ],
    );
  }

  Widget _buildProgressRing(ThemeData theme, double percentage) {
    final color = Color(widget.challenge['color'] as int? ?? 0xFF2E7D32);

    return SizedBox(
      width: 15.w,
      height: 15.w,
      child: Stack(
        children: [
          CircularProgressIndicator(
            value: percentage / 100,
            strokeWidth: 4,
            backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
          Center(
            child: Text(
              '${percentage.toInt()}%',
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme, bool isCheckedInToday) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: isCheckedInToday
              ? Container(
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.getSuccessColor(
                        theme.brightness == Brightness.light),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'check_circle',
                        color: Colors.white,
                        size: 18,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Completed Today',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              : AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: ElevatedButton(
                        onPressed: widget.onCheckIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.getWarningColor(
                              theme.brightness == Brightness.light),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 1.5.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'add_task',
                              color: Colors.white,
                              size: 18,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              'Check In Today',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: OutlinedButton(
            onPressed: widget.onViewProgress,
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'View Progress',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'edit',
                color: Theme.of(context).colorScheme.onSurface,
                size: 24,
              ),
              title: const Text('Edit Challenge'),
              onTap: () {
                Navigator.pop(context);
                widget.onEdit?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: Theme.of(context).colorScheme.onSurface,
                size: 24,
              ),
              title: const Text('Share Progress'),
              onTap: () {
                Navigator.pop(context);
                widget.onShare?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'archive',
                color: Theme.of(context).colorScheme.onSurface,
                size: 24,
              ),
              title: const Text('Archive Challenge'),
              onTap: () {
                Navigator.pop(context);
                widget.onArchive?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'delete',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 24,
              ),
              title: const Text('Delete Challenge'),
              onTap: () {
                Navigator.pop(context);
                widget.onDelete?.call();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'edit':
        widget.onEdit?.call();
        break;
      case 'share':
        widget.onShare?.call();
        break;
      case 'archive':
        widget.onArchive?.call();
        break;
      case 'delete':
        widget.onDelete?.call();
        break;
    }
  }
}
