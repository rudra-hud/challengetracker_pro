import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class TimelineSearchBar extends StatefulWidget {
  final String? initialQuery;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onVoiceSearch;
  final VoidCallback? onFilterTap;
  final bool hasActiveFilters;

  const TimelineSearchBar({
    super.key,
    this.initialQuery,
    this.onSearchChanged,
    this.onVoiceSearch,
    this.onFilterTap,
    this.hasActiveFilters = false,
  });

  @override
  State<TimelineSearchBar> createState() => _TimelineSearchBarState();
}

class _TimelineSearchBarState extends State<TimelineSearchBar> {
  late TextEditingController _searchController;
  bool _isSearchActive = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    _isSearchActive = widget.initialQuery?.isNotEmpty == true;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isSearchActive
                      ? colorScheme.primary
                      : colorScheme.outline.withValues(alpha: 0.3),
                  width: _isSearchActive ? 2 : 1,
                ),
                boxShadow: _isSearchActive
                    ? [
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _isSearchActive = value.isNotEmpty;
                  });
                  widget.onSearchChanged?.call(value);
                },
                decoration: InputDecoration(
                  hintText: 'Search journal entries...',
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'search',
                      color: _isSearchActive
                          ? colorScheme.primary
                          : colorScheme.onSurface.withValues(alpha: 0.6),
                      size: 20,
                    ),
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_isSearchActive)
                        IconButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _isSearchActive = false;
                            });
                            widget.onSearchChanged?.call('');
                          },
                          icon: CustomIconWidget(
                            iconName: 'clear',
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                            size: 20,
                          ),
                        ),
                      if (widget.onVoiceSearch != null)
                        IconButton(
                          onPressed: widget.onVoiceSearch,
                          icon: CustomIconWidget(
                            iconName: 'mic',
                            color: colorScheme.primary,
                            size: 20,
                          ),
                          tooltip: 'Voice search',
                        ),
                    ],
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 2.h,
                  ),
                ),
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Container(
            decoration: BoxDecoration(
              color: widget.hasActiveFilters
                  ? colorScheme.primary
                  : colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: widget.hasActiveFilters
                    ? colorScheme.primary
                    : colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            child: IconButton(
              onPressed: widget.onFilterTap,
              icon: CustomIconWidget(
                iconName: 'filter_list',
                color: widget.hasActiveFilters
                    ? colorScheme.onPrimary
                    : colorScheme.onSurface,
                size: 24,
              ),
              tooltip: 'Filter entries',
            ),
          ),
        ],
      ),
    );
  }
}
