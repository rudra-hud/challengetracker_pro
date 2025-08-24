import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom BottomNavigationBar widget implementing contextual navigation
/// with Mindful Minimalism design approach for habit tracking apps.
/// Provides seamless navigation between main app sections.
class CustomBottomBar extends StatelessWidget {
  /// Current selected index
  final int currentIndex;

  /// Callback when a tab is tapped
  final ValueChanged<int> onTap;

  /// Bottom bar variant for different contexts
  final CustomBottomBarVariant variant;

  /// Whether to show labels
  final bool showLabels;

  /// Custom background color
  final Color? backgroundColor;

  /// Custom selected item color
  final Color? selectedItemColor;

  /// Custom unselected item color
  final Color? unselectedItemColor;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.variant = CustomBottomBarVariant.standard,
    this.showLabels = true,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Get navigation items based on variant
    final items = _getNavigationItems(variant);

    // Determine colors
    final effectiveBackgroundColor = backgroundColor ?? colorScheme.surface;
    final effectiveSelectedColor = selectedItemColor ?? colorScheme.primary;
    final effectiveUnselectedColor =
        unselectedItemColor ?? (isDark ? Colors.grey[400] : Colors.grey[600]);

    return Container(
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: BottomNavigationBar(
          currentIndex: currentIndex.clamp(0, items.length - 1),
          onTap: (index) => _handleTap(context, index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedItemColor: effectiveSelectedColor,
          unselectedItemColor: effectiveUnselectedColor,
          elevation: 0,
          showSelectedLabels: showLabels,
          showUnselectedLabels: showLabels,
          selectedLabelStyle: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          items: items
              .map((item) => BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Icon(item.icon, size: 24),
                    ),
                    activeIcon: Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Icon(item.activeIcon ?? item.icon, size: 24),
                    ),
                    label: item.label,
                    tooltip: item.tooltip,
                  ))
              .toList(),
        ),
      ),
    );
  }

  /// Handles tab tap with navigation
  void _handleTap(BuildContext context, int index) {
    if (index == currentIndex) return;

    final items = _getNavigationItems(variant);
    if (index >= 0 && index < items.length) {
      final route = items[index].route;
      if (route != null) {
        Navigator.pushNamed(context, route);
      }
    }

    onTap(index);
  }

  /// Gets navigation items based on variant
  List<_NavigationItem> _getNavigationItems(CustomBottomBarVariant variant) {
    switch (variant) {
      case CustomBottomBarVariant.standard:
        return [
          _NavigationItem(
            icon: Icons.dashboard_outlined,
            activeIcon: Icons.dashboard_rounded,
            label: 'Dashboard',
            tooltip: 'Challenge Dashboard',
            route: '/challenge-dashboard',
          ),
          _NavigationItem(
            icon: Icons.check_circle_outline,
            activeIcon: Icons.check_circle_rounded,
            label: 'Check-in',
            tooltip: 'Daily Check-in',
            route: '/daily-check-in',
          ),
          _NavigationItem(
            icon: Icons.add_circle_outline,
            activeIcon: Icons.add_circle_rounded,
            label: 'Create',
            tooltip: 'Challenge Creation',
            route: '/challenge-creation',
          ),
          _NavigationItem(
            icon: Icons.analytics_outlined,
            activeIcon: Icons.analytics_rounded,
            label: 'Analytics',
            tooltip: 'Progress Analytics',
            route: '/progress-analytics',
          ),
          _NavigationItem(
            icon: Icons.person_outline,
            activeIcon: Icons.person_rounded,
            label: 'Profile',
            tooltip: 'Settings and Profile',
            route: '/settings-and-profile',
          ),
        ];

      case CustomBottomBarVariant.minimal:
        return [
          _NavigationItem(
            icon: Icons.home_outlined,
            activeIcon: Icons.home_rounded,
            label: 'Home',
            tooltip: 'Challenge Dashboard',
            route: '/challenge-dashboard',
          ),
          _NavigationItem(
            icon: Icons.timeline_outlined,
            activeIcon: Icons.timeline_rounded,
            label: 'Journal',
            tooltip: 'Journal Timeline',
            route: '/journal-timeline',
          ),
          _NavigationItem(
            icon: Icons.insights_outlined,
            activeIcon: Icons.insights_rounded,
            label: 'Insights',
            tooltip: 'Progress Analytics',
            route: '/progress-analytics',
          ),
          _NavigationItem(
            icon: Icons.settings_outlined,
            activeIcon: Icons.settings_rounded,
            label: 'Settings',
            tooltip: 'Settings and Profile',
            route: '/settings-and-profile',
          ),
        ];

      case CustomBottomBarVariant.focus:
        return [
          _NavigationItem(
            icon: Icons.today_outlined,
            activeIcon: Icons.today_rounded,
            label: 'Today',
            tooltip: 'Daily Check-in',
            route: '/daily-check-in',
          ),
          _NavigationItem(
            icon: Icons.book_outlined,
            activeIcon: Icons.book_rounded,
            label: 'Journal',
            tooltip: 'Journal Timeline',
            route: '/journal-timeline',
          ),
          _NavigationItem(
            icon: Icons.trending_up_outlined,
            activeIcon: Icons.trending_up_rounded,
            label: 'Progress',
            tooltip: 'Progress Analytics',
            route: '/progress-analytics',
          ),
        ];
    }
  }

  /// Factory constructor for standard navigation
  factory CustomBottomBar.standard({
    required int currentIndex,
    required ValueChanged<int> onTap,
    bool showLabels = true,
  }) {
    return CustomBottomBar(
      currentIndex: currentIndex,
      onTap: onTap,
      variant: CustomBottomBarVariant.standard,
      showLabels: showLabels,
    );
  }

  /// Factory constructor for minimal navigation (4 tabs)
  factory CustomBottomBar.minimal({
    required int currentIndex,
    required ValueChanged<int> onTap,
    bool showLabels = true,
  }) {
    return CustomBottomBar(
      currentIndex: currentIndex,
      onTap: onTap,
      variant: CustomBottomBarVariant.minimal,
      showLabels: showLabels,
    );
  }

  /// Factory constructor for focus mode (3 tabs)
  factory CustomBottomBar.focus({
    required int currentIndex,
    required ValueChanged<int> onTap,
    bool showLabels = true,
  }) {
    return CustomBottomBar(
      currentIndex: currentIndex,
      onTap: onTap,
      variant: CustomBottomBarVariant.focus,
      showLabels: showLabels,
    );
  }
}

/// Enum defining different bottom bar variants
enum CustomBottomBarVariant {
  /// Standard 5-tab navigation
  standard,

  /// Minimal 4-tab navigation
  minimal,

  /// Focus 3-tab navigation for distraction-free experience
  focus,
}

/// Internal class for navigation items
class _NavigationItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final String tooltip;
  final String? route;

  const _NavigationItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    required this.tooltip,
    this.route,
  });
}
