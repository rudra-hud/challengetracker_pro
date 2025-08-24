import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ThemeCustomizationWidget extends StatefulWidget {
  final String currentTheme;
  final String currentColorScheme;
  final Function(String) onThemeChanged;
  final Function(String) onColorSchemeChanged;

  const ThemeCustomizationWidget({
    super.key,
    required this.currentTheme,
    required this.currentColorScheme,
    required this.onThemeChanged,
    required this.onColorSchemeChanged,
  });

  @override
  State<ThemeCustomizationWidget> createState() =>
      _ThemeCustomizationWidgetState();
}

class _ThemeCustomizationWidgetState extends State<ThemeCustomizationWidget> {
  final List<Map<String, dynamic>> themeOptions = [
    {
      'key': 'light',
      'name': 'Light',
      'icon': 'light_mode',
      'description': 'Clean and bright interface',
    },
    {
      'key': 'dark',
      'name': 'Dark',
      'icon': 'dark_mode',
      'description': 'Easy on the eyes',
    },
    {
      'key': 'system',
      'name': 'System',
      'icon': 'settings_brightness',
      'description': 'Follow device settings',
    },
  ];

  final List<Map<String, dynamic>> colorSchemes = [
    {
      'key': 'default',
      'name': 'Forest Green',
      'primaryColor': Color(0xFF2E7D32),
      'secondaryColor': Color(0xFF5E35B1),
    },
    {
      'key': 'ocean',
      'name': 'Ocean Blue',
      'primaryColor': Color(0xFF1976D2),
      'secondaryColor': Color(0xFF0288D1),
    },
    {
      'key': 'sunset',
      'name': 'Sunset Orange',
      'primaryColor': Color(0xFFFF6F00),
      'secondaryColor': Color(0xFFE65100),
    },
    {
      'key': 'lavender',
      'name': 'Lavender Purple',
      'primaryColor': Color(0xFF7B1FA2),
      'secondaryColor': Color(0xFF8E24AA),
    },
    {
      'key': 'rose',
      'name': 'Rose Pink',
      'primaryColor': Color(0xFFE91E63),
      'secondaryColor': Color(0xFFAD1457),
    },
    {
      'key': 'emerald',
      'name': 'Emerald Teal',
      'primaryColor': Color(0xFF00695C),
      'secondaryColor': Color(0xFF00796B),
    },
  ];

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
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appearance',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              ),
            ),
            SizedBox(height: 3.h),

            // Theme Selection
            Text(
              'Theme Mode',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              children: themeOptions.map((option) {
                final isSelected = widget.currentTheme == option['key'];
                return Expanded(
                  child: GestureDetector(
                    onTap: () => widget.onThemeChanged(option['key'] as String),
                    child: Container(
                      margin: EdgeInsets.only(
                          right: option == themeOptions.last ? 0 : 2.w),
                      padding:
                          EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colorScheme.primary.withValues(alpha: 0.1)
                            : colorScheme.surface,
                        borderRadius: BorderRadius.circular(2.w),
                        border: Border.all(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.outline.withValues(alpha: 0.3),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          CustomIconWidget(
                            iconName: option['icon'] as String,
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.onSurface.withValues(alpha: 0.7),
                            size: 24,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            option['name'] as String,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isSelected
                                  ? colorScheme.primary
                                  : colorScheme.onSurface,
                              fontWeight: isSelected
                                  ? FontWeight.w500
                                  : FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: 4.h),

            // Color Scheme Selection
            Text(
              'Color Scheme',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 2.h),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 3.w,
                mainAxisSpacing: 2.h,
                childAspectRatio: 1.2,
              ),
              itemCount: colorSchemes.length,
              itemBuilder: (context, index) {
                final scheme = colorSchemes[index];
                final isSelected = widget.currentColorScheme == scheme['key'];

                return GestureDetector(
                  onTap: () =>
                      widget.onColorSchemeChanged(scheme['key'] as String),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2.w),
                      border: Border.all(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.outline.withValues(alpha: 0.3),
                        width: isSelected ? 3 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: scheme['primaryColor'] as Color,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(2.w),
                              ),
                            ),
                            child: isSelected
                                ? Center(
                                    child: CustomIconWidget(
                                      iconName: 'check',
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: scheme['secondaryColor'] as Color,
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(2.w),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(1.w),
                          child: Text(
                            scheme['name'] as String,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: isSelected
                                  ? FontWeight.w500
                                  : FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
