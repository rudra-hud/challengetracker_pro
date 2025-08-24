import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class TimelineFilterSheet extends StatefulWidget {
  final Map<String, dynamic>? currentFilters;
  final ValueChanged<Map<String, dynamic>>? onFiltersChanged;

  const TimelineFilterSheet({
    super.key,
    this.currentFilters,
    this.onFiltersChanged,
  });

  @override
  State<TimelineFilterSheet> createState() => _TimelineFilterSheetState();
}

class _TimelineFilterSheetState extends State<TimelineFilterSheet> {
  late Map<String, dynamic> _filters;
  DateTimeRange? _dateRange;
  List<String> _selectedMoods = [];
  List<String> _selectedTags = [];
  bool _completedOnly = false;
  bool _withPhotosOnly = false;

  final List<String> _availableMoods = [
    '😊',
    '😢',
    '😡',
    '😴',
    '🤔',
    '😍',
    '😰',
    '🤗',
    '😎',
    '🤯'
  ];

  final List<String> _availableTags = [
    'breakthrough',
    'struggle',
    'milestone',
    'reflection',
    'gratitude',
    'challenge',
    'success',
    'learning',
    'growth',
    'motivation'
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters ?? {});
    _initializeFilters();
  }

  void _initializeFilters() {
    _dateRange = _filters['dateRange'] as DateTimeRange?;
    _selectedMoods = List<String>.from(_filters['moods'] ?? []);
    _selectedTags = List<String>.from(_filters['tags'] ?? []);
    _completedOnly = _filters['completedOnly'] as bool? ?? false;
    _withPhotosOnly = _filters['withPhotosOnly'] as bool? ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateRangeSection(context),
                  SizedBox(height: 3.h),
                  _buildMoodSection(context),
                  SizedBox(height: 3.h),
                  _buildTagSection(context),
                  SizedBox(height: 3.h),
                  _buildOptionsSection(context),
                  SizedBox(height: 3.h),
                ],
              ),
            ),
          ),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Filter Entries',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: _clearAllFilters,
            child: Text(
              'Clear All',
              style: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRangeSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date Range',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        InkWell(
          onTap: _selectDateRange,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.3),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'date_range',
                  color: colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    _dateRange != null
                        ? '${_formatDate(_dateRange!.start)} - ${_formatDate(_dateRange!.end)}'
                        : 'Select date range',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: _dateRange != null
                          ? colorScheme.onSurface
                          : colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ),
                CustomIconWidget(
                  iconName: 'chevron_right',
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMoodSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mood',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _availableMoods
              .map((mood) => _buildMoodChip(context, mood))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildMoodChip(BuildContext context, String mood) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = _selectedMoods.contains(mood);

    return FilterChip(
      label: Text(mood, style: TextStyle(fontSize: 16.sp)),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (selected) {
            _selectedMoods.add(mood);
          } else {
            _selectedMoods.remove(mood);
          }
        });
      },
      selectedColor: colorScheme.primary.withValues(alpha: 0.2),
      checkmarkColor: colorScheme.primary,
      side: BorderSide(
        color: isSelected
            ? colorScheme.primary
            : colorScheme.outline.withValues(alpha: 0.3),
      ),
    );
  }

  Widget _buildTagSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tags',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children:
              _availableTags.map((tag) => _buildTagChip(context, tag)).toList(),
        ),
      ],
    );
  }

  Widget _buildTagChip(BuildContext context, String tag) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = _selectedTags.contains(tag);

    return FilterChip(
      label: Text('#$tag'),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (selected) {
            _selectedTags.add(tag);
          } else {
            _selectedTags.remove(tag);
          }
        });
      },
      selectedColor: colorScheme.secondary.withValues(alpha: 0.2),
      checkmarkColor: colorScheme.secondary,
      side: BorderSide(
        color: isSelected
            ? colorScheme.secondary
            : colorScheme.outline.withValues(alpha: 0.3),
      ),
    );
  }

  Widget _buildOptionsSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Options',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        SwitchListTile(
          title: Text('Completed entries only'),
          subtitle: Text('Show only completed challenge entries'),
          value: _completedOnly,
          onChanged: (value) {
            setState(() {
              _completedOnly = value;
            });
          },
          contentPadding: EdgeInsets.zero,
        ),
        SwitchListTile(
          title: Text('Entries with photos only'),
          subtitle: Text('Show only entries that contain photos'),
          value: _withPhotosOnly,
          onChanged: (value) {
            setState(() {
              _withPhotosOnly = value;
            });
          },
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: ElevatedButton(
              onPressed: _applyFilters,
              child: Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }

  void _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDateRange: _dateRange,
    );

    if (picked != null) {
      setState(() {
        _dateRange = picked;
      });
    }
  }

  void _clearAllFilters() {
    setState(() {
      _dateRange = null;
      _selectedMoods.clear();
      _selectedTags.clear();
      _completedOnly = false;
      _withPhotosOnly = false;
    });
  }

  void _applyFilters() {
    final filters = <String, dynamic>{
      if (_dateRange != null) 'dateRange': _dateRange,
      if (_selectedMoods.isNotEmpty) 'moods': _selectedMoods,
      if (_selectedTags.isNotEmpty) 'tags': _selectedTags,
      if (_completedOnly) 'completedOnly': _completedOnly,
      if (_withPhotosOnly) 'withPhotosOnly': _withPhotosOnly,
    };

    widget.onFiltersChanged?.call(filters);
    Navigator.pop(context);
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}
