import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class AdvancedOptionsSection extends StatelessWidget {
  final bool isExpanded;
  final String privacySetting;
  final bool enableNotifications;
  final bool enableStreakProtection;
  final bool enableSocialSharing;
  final VoidCallback onToggleExpanded;
  final Function(String) onPrivacyChanged;
  final Function(bool) onNotificationsChanged;
  final Function(bool) onStreakProtectionChanged;
  final Function(bool) onSocialSharingChanged;

  const AdvancedOptionsSection({
    super.key,
    required this.isExpanded,
    required this.privacySetting,
    required this.enableNotifications,
    required this.enableStreakProtection,
    required this.enableSocialSharing,
    required this.onToggleExpanded,
    required this.onPrivacyChanged,
    required this.onNotificationsChanged,
    required this.onStreakProtectionChanged,
    required this.onSocialSharingChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Advanced Options Header
        GestureDetector(
          onTap: onToggleExpanded,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 2.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Advanced Options',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: CustomIconWidget(
                    iconName: 'keyboard_arrow_down',
                    size: 24,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Expandable Content
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: isExpanded ? null : 0,
          child: isExpanded
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 1.h),

                    // Privacy Settings
                    Text(
                      'Privacy Settings',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 1.h),

                    Row(
                      children: [
                        Expanded(
                          child: _buildPrivacyChip(
                            context,
                            'Private',
                            'Only you can see',
                            privacySetting == 'Private',
                            () => onPrivacyChanged('Private'),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: _buildPrivacyChip(
                            context,
                            'Friends',
                            'Friends can see',
                            privacySetting == 'Friends',
                            () => onPrivacyChanged('Friends'),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: _buildPrivacyChip(
                            context,
                            'Public',
                            'Everyone can see',
                            privacySetting == 'Public',
                            () => onPrivacyChanged('Public'),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 3.h),

                    // Notification Preferences
                    Text(
                      'Notification Preferences',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 1.h),

                    _buildSwitchTile(
                      context,
                      'Enable Notifications',
                      'Receive daily reminders and updates',
                      enableNotifications,
                      onNotificationsChanged,
                      'notifications',
                    ),

                    SizedBox(height: 1.h),

                    _buildSwitchTile(
                      context,
                      'Streak Protection',
                      'Get alerts when your streak is at risk',
                      enableStreakProtection,
                      onStreakProtectionChanged,
                      'local_fire_department',
                    ),

                    SizedBox(height: 1.h),

                    _buildSwitchTile(
                      context,
                      'Social Sharing',
                      'Allow sharing progress on social media',
                      enableSocialSharing,
                      onSocialSharingChanged,
                      'share',
                    ),

                    SizedBox(height: 2.h),

                    // Additional Info
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: colorScheme.secondary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: colorScheme.secondary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'info',
                            size: 20,
                            color: colorScheme.secondary,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              'You can change these settings anytime in your challenge dashboard.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.secondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildPrivacyChip(
    BuildContext context,
    String title,
    String subtitle,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withValues(alpha: 0.1)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.outline,
          ),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? colorScheme.primary.withValues(alpha: 0.8)
                    : colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context,
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
    String iconName,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: iconName,
            size: 20,
            color: value
                ? colorScheme.primary
                : colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
