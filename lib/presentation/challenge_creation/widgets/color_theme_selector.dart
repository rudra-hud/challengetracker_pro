import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ColorThemeSelector extends StatelessWidget {
  final String selectedTheme;
  final Function(String) onThemeChanged;

  const ColorThemeSelector({
    super.key,
    required this.selectedTheme,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final List<Map<String, dynamic>> colorThemes = [
      {
        "name": "Forest",
        "primary": const Color(0xFF2E7D32),
        "secondary": const Color(0xFF4CAF50),
        "accent": const Color(0xFF81C784),
      },
      {
        "name": "Ocean",
        "primary": const Color(0xFF1976D2),
        "secondary": const Color(0xFF2196F3),
        "accent": const Color(0xFF64B5F6),
      },
      {
        "name": "Sunset",
        "primary": const Color(0xFFFF6F00),
        "secondary": const Color(0xFFFF9800),
        "accent": const Color(0xFFFFB74D),
      },
      {
        "name": "Purple",
        "primary": const Color(0xFF5E35B1),
        "secondary": const Color(0xFF7E57C2),
        "accent": const Color(0xFF9575CD),
      },
      {
        "name": "Rose",
        "primary": const Color(0xFFE91E63),
        "secondary": const Color(0xFFF06292),
        "accent": const Color(0xFFF8BBD9),
      },
      {
        "name": "Teal",
        "primary": const Color(0xFF00695C),
        "secondary": const Color(0xFF00897B),
        "accent": const Color(0xFF4DB6AC),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color Theme',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),

        Text(
          'Choose a color theme for your challenge',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        SizedBox(height: 2.h),

        // Color Theme Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 3.w,
            mainAxisSpacing: 2.h,
            childAspectRatio: 1.2,
          ),
          itemCount: colorThemes.length,
          itemBuilder: (context, index) {
            final colorTheme = colorThemes[index];
            final isSelected = selectedTheme == colorTheme["name"];

            return GestureDetector(
              onTap: () => onThemeChanged(colorTheme["name"] as String),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.outline.withValues(alpha: 0.3),
                    width: isSelected ? 3 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  children: [
                    // Color Preview
                    Expanded(
                      flex: 3,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              colorTheme["primary"] as Color,
                              colorTheme["secondary"] as Color,
                              colorTheme["accent"] as Color,
                            ],
                          ),
                        ),
                        child: isSelected
                            ? Center(
                                child: Container(
                                  padding: EdgeInsets.all(1.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    shape: BoxShape.circle,
                                  ),
                                  child: CustomIconWidget(
                                    iconName: 'check',
                                    size: 16,
                                    color: colorTheme["primary"] as Color,
                                  ),
                                ),
                              )
                            : null,
                      ),
                    ),

                    // Theme Name
                    Expanded(
                      flex: 1,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(12),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            colorTheme["name"] as String,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: isSelected
                                  ? colorScheme.primary
                                  : colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        SizedBox(height: 3.h),

        // Selected Theme Preview
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _getSelectedThemeColor("primary"),
                _getSelectedThemeColor("secondary"),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'palette',
                size: 24,
                color: Colors.white,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selected Theme: $selectedTheme',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'This theme will be used throughout your challenge',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getSelectedThemeColor(String type) {
    final colorThemes = {
      "Forest": {
        "primary": const Color(0xFF2E7D32),
        "secondary": const Color(0xFF4CAF50),
      },
      "Ocean": {
        "primary": const Color(0xFF1976D2),
        "secondary": const Color(0xFF2196F3),
      },
      "Sunset": {
        "primary": const Color(0xFFFF6F00),
        "secondary": const Color(0xFFFF9800),
      },
      "Purple": {
        "primary": const Color(0xFF5E35B1),
        "secondary": const Color(0xFF7E57C2),
      },
      "Rose": {
        "primary": const Color(0xFFE91E63),
        "secondary": const Color(0xFFF06292),
      },
      "Teal": {
        "primary": const Color(0xFF00695C),
        "secondary": const Color(0xFF00897B),
      },
    };

    return colorThemes[selectedTheme]?[type] ?? const Color(0xFF2E7D32);
  }
}
