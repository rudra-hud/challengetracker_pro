import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom TabBar widget implementing progressive disclosure design pattern
/// with Mindful Minimalism approach for habit tracking apps.
/// Provides contextual tab navigation with smooth animations.
class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  /// List of tab labels
  final List<String> tabs;

  /// Tab controller for managing tab state
  final TabController? controller;

  /// Callback when a tab is tapped
  final ValueChanged<int>? onTap;

  /// Tab bar variant for different contexts
  final CustomTabBarVariant variant;

  /// Whether tabs are scrollable
  final bool isScrollable;

  /// Custom indicator color
  final Color? indicatorColor;

  /// Custom label color
  final Color? labelColor;

  /// Custom unselected label color
  final Color? unselectedLabelColor;

  /// Custom background color
  final Color? backgroundColor;

  /// Tab alignment for scrollable tabs
  final TabAlignment? tabAlignment;

  const CustomTabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.onTap,
    this.variant = CustomTabBarVariant.standard,
    this.isScrollable = false,
    this.indicatorColor,
    this.labelColor,
    this.unselectedLabelColor,
    this.backgroundColor,
    this.tabAlignment,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Determine colors based on variant and theme
    Color effectiveIndicatorColor;
    Color effectiveLabelColor;
    Color effectiveUnselectedLabelColor;
    Color effectiveBackgroundColor;

    switch (variant) {
      case CustomTabBarVariant.standard:
        effectiveIndicatorColor = indicatorColor ?? colorScheme.primary;
        effectiveLabelColor = labelColor ?? colorScheme.primary;
        effectiveUnselectedLabelColor = unselectedLabelColor ??
            (isDark ? Colors.grey[400]! : Colors.grey[600]!);
        effectiveBackgroundColor = backgroundColor ?? Colors.transparent;
        break;

      case CustomTabBarVariant.surface:
        effectiveIndicatorColor = indicatorColor ?? colorScheme.primary;
        effectiveLabelColor = labelColor ?? colorScheme.onSurface;
        effectiveUnselectedLabelColor = unselectedLabelColor ??
            (isDark ? Colors.grey[400]! : Colors.grey[600]!);
        effectiveBackgroundColor = backgroundColor ?? colorScheme.surface;
        break;

      case CustomTabBarVariant.primary:
        effectiveIndicatorColor = indicatorColor ?? colorScheme.onPrimary;
        effectiveLabelColor = labelColor ?? colorScheme.onPrimary;
        effectiveUnselectedLabelColor = unselectedLabelColor ??
            colorScheme.onPrimary.withValues(alpha: 0.7);
        effectiveBackgroundColor = backgroundColor ?? colorScheme.primary;
        break;

      case CustomTabBarVariant.minimal:
        effectiveIndicatorColor = indicatorColor ?? Colors.transparent;
        effectiveLabelColor = labelColor ?? colorScheme.primary;
        effectiveUnselectedLabelColor = unselectedLabelColor ??
            (isDark ? Colors.grey[400]! : Colors.grey[600]!);
        effectiveBackgroundColor = backgroundColor ?? Colors.transparent;
        break;
    }

    return Container(
      color: effectiveBackgroundColor,
      child: TabBar(
        controller: controller,
        onTap: onTap,
        tabs: tabs.map((tab) => Tab(text: tab)).toList(),
        isScrollable: isScrollable,
        tabAlignment: tabAlignment ??
            (isScrollable ? TabAlignment.start : TabAlignment.fill),
        indicatorColor: effectiveIndicatorColor,
        indicatorWeight: variant == CustomTabBarVariant.minimal ? 0 : 2.0,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: effectiveLabelColor,
        unselectedLabelColor: effectiveUnselectedLabelColor,
        labelStyle: _getLabelStyle(variant, true),
        unselectedLabelStyle: _getLabelStyle(variant, false),
        splashFactory: NoSplash.splashFactory,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        dividerColor: variant == CustomTabBarVariant.surface
            ? colorScheme.outline.withValues(alpha: 0.2)
            : Colors.transparent,
      ),
    );
  }

  /// Gets label style based on variant and selection state
  TextStyle _getLabelStyle(CustomTabBarVariant variant, bool isSelected) {
    switch (variant) {
      case CustomTabBarVariant.standard:
      case CustomTabBarVariant.surface:
      case CustomTabBarVariant.primary:
        return GoogleFonts.inter(
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
          letterSpacing: 0.1,
        );

      case CustomTabBarVariant.minimal:
        return GoogleFonts.inter(
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          letterSpacing: 0,
        );
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kTextTabBarHeight);

  /// Factory constructor for analytics tabs (time periods)
  factory CustomTabBar.analytics({
    TabController? controller,
    ValueChanged<int>? onTap,
  }) {
    return CustomTabBar(
      tabs: const ['Week', 'Month', '3 Months', 'Year'],
      controller: controller,
      onTap: onTap,
      variant: CustomTabBarVariant.standard,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
    );
  }

  /// Factory constructor for challenge dashboard tabs
  factory CustomTabBar.dashboard({
    TabController? controller,
    ValueChanged<int>? onTap,
  }) {
    return CustomTabBar(
      tabs: const ['Active', 'Completed', 'All'],
      controller: controller,
      onTap: onTap,
      variant: CustomTabBarVariant.surface,
      isScrollable: false,
    );
  }

  /// Factory constructor for journal timeline tabs
  factory CustomTabBar.journal({
    TabController? controller,
    ValueChanged<int>? onTap,
  }) {
    return CustomTabBar(
      tabs: const ['Recent', 'Favorites', 'Archived'],
      controller: controller,
      onTap: onTap,
      variant: CustomTabBarVariant.minimal,
      isScrollable: false,
    );
  }

  /// Factory constructor for settings tabs
  factory CustomTabBar.settings({
    TabController? controller,
    ValueChanged<int>? onTap,
  }) {
    return CustomTabBar(
      tabs: const ['General', 'Notifications', 'Privacy', 'About'],
      controller: controller,
      onTap: onTap,
      variant: CustomTabBarVariant.standard,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
    );
  }

  /// Factory constructor for challenge creation tabs
  factory CustomTabBar.challengeCreation({
    TabController? controller,
    ValueChanged<int>? onTap,
  }) {
    return CustomTabBar(
      tabs: const ['Details', 'Schedule', 'Goals', 'Review'],
      controller: controller,
      onTap: onTap,
      variant: CustomTabBarVariant.surface,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
    );
  }

  /// Factory constructor for progress analytics tabs
  factory CustomTabBar.progressAnalytics({
    TabController? controller,
    ValueChanged<int>? onTap,
  }) {
    return CustomTabBar(
      tabs: const ['Overview', 'Trends', 'Insights', 'Compare'],
      controller: controller,
      onTap: onTap,
      variant: CustomTabBarVariant.standard,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
    );
  }
}

/// Enum defining different tab bar variants for various contexts
enum CustomTabBarVariant {
  /// Standard tab bar with primary color indicator
  standard,

  /// Surface tab bar with background and divider
  surface,

  /// Primary colored tab bar for emphasis
  primary,

  /// Minimal tab bar without indicator
  minimal,
}
