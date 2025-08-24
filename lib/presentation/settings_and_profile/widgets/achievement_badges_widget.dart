import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class AchievementBadgesWidget extends StatefulWidget {
  final List<Map<String, dynamic>> badges;

  const AchievementBadgesWidget({
    super.key,
    required this.badges,
  });

  @override
  State<AchievementBadgesWidget> createState() =>
      _AchievementBadgesWidgetState();
}

class _AchievementBadgesWidgetState extends State<AchievementBadgesWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(3.w),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'military_tech',
                    color: colorScheme.primary,
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Achievement Badges',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          '${widget.badges.where((badge) => badge['earned'] as bool).length} of ${widget.badges.length} earned',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: CustomIconWidget(
                      iconName: 'keyboard_arrow_down',
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _isExpanded ? null : 0,
            child: _isExpanded
                ? Padding(
                    padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 4.w),
                    child: Column(
                      children: [
                        Divider(
                          color: colorScheme.outline.withValues(alpha: 0.2),
                          height: 1,
                        ),
                        SizedBox(height: 3.h),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 3.w,
                            mainAxisSpacing: 2.h,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: widget.badges.length,
                          itemBuilder: (context, index) {
                            final badge = widget.badges[index];
                            final isEarned = badge['earned'] as bool;

                            return Column(
                              children: [
                                Container(
                                  width: 15.w,
                                  height: 15.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isEarned
                                        ? colorScheme.primary
                                            .withValues(alpha: 0.1)
                                        : colorScheme.outline
                                            .withValues(alpha: 0.1),
                                    border: Border.all(
                                      color: isEarned
                                          ? colorScheme.primary
                                          : colorScheme.outline
                                              .withValues(alpha: 0.3),
                                      width: 2,
                                    ),
                                  ),
                                  child: CustomIconWidget(
                                    iconName: badge['icon'] as String,
                                    color: isEarned
                                        ? colorScheme.primary
                                        : colorScheme.onSurface
                                            .withValues(alpha: 0.4),
                                    size: 24,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Expanded(
                                  child: Text(
                                    badge['name'] as String,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: isEarned
                                          ? colorScheme.onSurface
                                          : colorScheme.onSurface
                                              .withValues(alpha: 0.5),
                                      fontWeight: isEarned
                                          ? FontWeight.w500
                                          : FontWeight.w400,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
