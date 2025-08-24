import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SettingsSectionWidget extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> items;
  final Function(String)? onItemTap;

  const SettingsSectionWidget({
    super.key,
    required this.title,
    required this.items,
    this.onItemTap,
  });

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(4.w, 4.w, 4.w, 2.h),
            child: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              ),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => Divider(
              color: colorScheme.outline.withValues(alpha: 0.1),
              height: 1,
              indent: 4.w,
              endIndent: 4.w,
            ),
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildSettingItem(context, item);
            },
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context, Map<String, dynamic> item) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final itemType = item['type'] as String;

    return InkWell(
      onTap: () {
        if (onItemTap != null) {
          onItemTap!(item['key'] as String);
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Row(
          children: [
            if (item['icon'] != null) ...[
              CustomIconWidget(
                iconName: item['icon'] as String,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
                size: 20,
              ),
              SizedBox(width: 3.w),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'] as String,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (item['subtitle'] != null) ...[
                    SizedBox(height: 0.5.h),
                    Text(
                      item['subtitle'] as String,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            _buildTrailingWidget(context, item, itemType),
          ],
        ),
      ),
    );
  }

  Widget _buildTrailingWidget(
      BuildContext context, Map<String, dynamic> item, String itemType) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (itemType) {
      case 'switch':
        return Switch(
          value: item['value'] as bool? ?? false,
          onChanged: (value) {
            if (onItemTap != null) {
              onItemTap!(item['key'] as String);
            }
          },
        );

      case 'disclosure':
        return CustomIconWidget(
          iconName: 'chevron_right',
          color: colorScheme.onSurface.withValues(alpha: 0.4),
          size: 20,
        );

      case 'value':
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item['value'] as String? ?? '',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            SizedBox(width: 2.w),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: colorScheme.onSurface.withValues(alpha: 0.4),
              size: 20,
            ),
          ],
        );

      case 'action':
        return CustomIconWidget(
          iconName: item['actionIcon'] as String? ?? 'chevron_right',
          color: item['key'] == 'delete_account'
              ? colorScheme.error
              : colorScheme.onSurface.withValues(alpha: 0.4),
          size: 20,
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
