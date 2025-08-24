import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom AppBar widget implementing Mindful Minimalism design approach
/// with edge-to-edge content and SafeArea awareness for habit tracking apps.
/// Provides contextual actions and maintains supportive focus visual mood.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The title to display in the app bar
  final String title;

  /// Whether to show the back button (automatically determined if not specified)
  final bool? showBackButton;

  /// Custom leading widget (overrides back button if provided)
  final Widget? leading;

  /// List of action widgets to display on the right side
  final List<Widget>? actions;

  /// Whether to center the title
  final bool centerTitle;

  /// Custom bottom widget (typically used for tabs)
  final PreferredSizeWidget? bottom;

  /// Background color override
  final Color? backgroundColor;

  /// Foreground color override
  final Color? foregroundColor;

  /// Elevation override
  final double? elevation;

  /// App bar variant for different contexts
  final CustomAppBarVariant variant;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton,
    this.leading,
    this.actions,
    this.centerTitle = true,
    this.bottom,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.variant = CustomAppBarVariant.standard,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Determine colors based on variant and theme
    Color effectiveBackgroundColor;
    Color effectiveForegroundColor;
    double effectiveElevation;

    switch (variant) {
      case CustomAppBarVariant.standard:
        effectiveBackgroundColor = backgroundColor ?? colorScheme.surface;
        effectiveForegroundColor = foregroundColor ?? colorScheme.onSurface;
        effectiveElevation = elevation ?? 0;
        break;
      case CustomAppBarVariant.primary:
        effectiveBackgroundColor = backgroundColor ?? colorScheme.primary;
        effectiveForegroundColor = foregroundColor ?? colorScheme.onPrimary;
        effectiveElevation = elevation ?? 2;
        break;
      case CustomAppBarVariant.transparent:
        effectiveBackgroundColor = backgroundColor ?? Colors.transparent;
        effectiveForegroundColor = foregroundColor ?? colorScheme.onSurface;
        effectiveElevation = elevation ?? 0;
        break;
      case CustomAppBarVariant.modal:
        effectiveBackgroundColor = backgroundColor ?? colorScheme.surface;
        effectiveForegroundColor = foregroundColor ?? colorScheme.onSurface;
        effectiveElevation = elevation ?? 1;
        break;
    }

    return AppBar(
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: effectiveForegroundColor,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: effectiveBackgroundColor,
      foregroundColor: effectiveForegroundColor,
      elevation: effectiveElevation,
      surfaceTintColor: Colors.transparent,
      leading: _buildLeading(context, effectiveForegroundColor),
      actions: _buildActions(context, effectiveForegroundColor),
      bottom: bottom,
      automaticallyImplyLeading: false,
      titleSpacing: variant == CustomAppBarVariant.modal ? 0 : null,
    );
  }

  /// Builds the leading widget with contextual navigation
  Widget? _buildLeading(BuildContext context, Color foregroundColor) {
    if (leading != null) return leading;

    final shouldShowBack = showBackButton ?? Navigator.of(context).canPop();
    if (!shouldShowBack) return null;

    return IconButton(
      icon: Icon(
        variant == CustomAppBarVariant.modal
            ? Icons.close_rounded
            : Icons.arrow_back_rounded,
        color: foregroundColor,
      ),
      onPressed: () => Navigator.of(context).pop(),
      tooltip: variant == CustomAppBarVariant.modal ? 'Close' : 'Back',
    );
  }

  /// Builds action widgets with consistent styling
  List<Widget>? _buildActions(BuildContext context, Color foregroundColor) {
    if (actions == null) return null;

    return actions!.map((action) {
      if (action is IconButton) {
        return IconButton(
          icon: action.icon,
          onPressed: action.onPressed,
          tooltip: action.tooltip,
          color: foregroundColor,
        );
      }
      return action;
    }).toList();
  }

  @override
  Size get preferredSize {
    double height = kToolbarHeight;
    if (bottom != null) {
      height += bottom!.preferredSize.height;
    }
    return Size.fromHeight(height);
  }

  /// Factory constructor for dashboard app bar with navigation menu
  factory CustomAppBar.dashboard({
    required String title,
    VoidCallback? onMenuPressed,
    VoidCallback? onNotificationPressed,
    VoidCallback? onProfilePressed,
  }) {
    return CustomAppBar(
      title: title,
      variant: CustomAppBarVariant.standard,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: onMenuPressed ?? () => Scaffold.of(context).openDrawer(),
          tooltip: 'Menu',
        ),
      ),
      actions: [
        if (onNotificationPressed != null)
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: onNotificationPressed,
            tooltip: 'Notifications',
          ),
        if (onProfilePressed != null)
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: onProfilePressed,
            tooltip: 'Profile',
          ),
        const SizedBox(width: 8),
      ],
    );
  }

  /// Factory constructor for modal app bar (bottom sheets, dialogs)
  factory CustomAppBar.modal({
    required String title,
    VoidCallback? onClose,
    List<Widget>? actions,
  }) {
    return CustomAppBar(
      title: title,
      variant: CustomAppBarVariant.modal,
      actions: [
        ...?actions,
        const SizedBox(width: 8),
      ],
    );
  }

  /// Factory constructor for challenge creation app bar
  factory CustomAppBar.challengeCreation({
    VoidCallback? onCancel,
    VoidCallback? onSave,
    bool canSave = false,
  }) {
    return CustomAppBar(
      title: 'New Challenge',
      variant: CustomAppBarVariant.standard,
      leading: Builder(
        builder: (context) => TextButton(
          onPressed: onCancel ?? () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ),
      actions: [
        TextButton(
          onPressed: canSave ? onSave : null,
          child: const Text('Save'),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  /// Factory constructor for analytics app bar with filter options
  factory CustomAppBar.analytics({
    VoidCallback? onFilterPressed,
    VoidCallback? onExportPressed,
  }) {
    return CustomAppBar(
      title: 'Progress Analytics',
      variant: CustomAppBarVariant.standard,
      actions: [
        if (onFilterPressed != null)
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: onFilterPressed,
            tooltip: 'Filter',
          ),
        if (onExportPressed != null)
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: onExportPressed,
            tooltip: 'Share',
          ),
        const SizedBox(width: 8),
      ],
    );
  }
}

/// Enum defining different app bar variants for various contexts
enum CustomAppBarVariant {
  /// Standard app bar for main screens
  standard,

  /// Primary colored app bar for emphasis
  primary,

  /// Transparent app bar for overlay contexts
  transparent,

  /// Modal app bar for bottom sheets and dialogs
  modal,
}
