import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CustomTagInputWidget extends StatefulWidget {
  final List<String> selectedTags;
  final Function(List<String>) onTagsChanged;

  const CustomTagInputWidget({
    super.key,
    required this.selectedTags,
    required this.onTagsChanged,
  });

  @override
  State<CustomTagInputWidget> createState() => _CustomTagInputWidgetState();
}

class _CustomTagInputWidgetState extends State<CustomTagInputWidget> {
  late TextEditingController _textController;
  late FocusNode _focusNode;
  bool _showSuggestions = false;

  final List<String> _predefinedTags = [
    '#breakthrough',
    '#struggle',
    '#motivation',
    '#progress',
    '#challenge',
    '#victory',
    '#learning',
    '#growth',
    '#focus',
    '#discipline',
    '#mindset',
    '#reflection',
    '#gratitude',
    '#energy',
    '#consistency',
  ];

  List<String> _filteredSuggestions = [];

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _focusNode = FocusNode();

    _textController.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final text = _textController.text.toLowerCase();
    if (text.isEmpty) {
      setState(() {
        _filteredSuggestions = [];
        _showSuggestions = false;
      });
      return;
    }

    final suggestions = _predefinedTags
        .where((tag) =>
            tag.toLowerCase().contains(text) &&
            !widget.selectedTags.contains(tag))
        .take(5)
        .toList();

    setState(() {
      _filteredSuggestions = suggestions;
      _showSuggestions = suggestions.isNotEmpty;
    });
  }

  void _onFocusChanged() {
    if (!_focusNode.hasFocus) {
      setState(() {
        _showSuggestions = false;
      });
    }
  }

  void _addTag(String tag) {
    if (tag.isEmpty || widget.selectedTags.contains(tag)) return;

    String formattedTag = tag.startsWith('#') ? tag : '#$tag';
    final updatedTags = List<String>.from(widget.selectedTags)
      ..add(formattedTag);
    widget.onTagsChanged(updatedTags);

    _textController.clear();
    setState(() {
      _showSuggestions = false;
    });
  }

  void _removeTag(String tag) {
    final updatedTags = List<String>.from(widget.selectedTags)..remove(tag);
    widget.onTagsChanged(updatedTags);
  }

  void _onSubmitted(String value) {
    if (value.trim().isNotEmpty) {
      _addTag(value.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'local_offer',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Add Tags',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                '${widget.selectedTags.length}/10',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Selected Tags
          if (widget.selectedTags.isNotEmpty)
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: widget.selectedTags.map((tag) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        tag,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 1.w),
                      GestureDetector(
                        onTap: () => _removeTag(tag),
                        child: CustomIconWidget(
                          iconName: 'close',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

          if (widget.selectedTags.isNotEmpty) SizedBox(height: 2.h),

          // Tag Input
          Stack(
            children: [
              TextField(
                controller: _textController,
                focusNode: _focusNode,
                enabled: widget.selectedTags.length < 10,
                decoration: InputDecoration(
                  hintText: 'Type a tag (e.g., breakthrough, struggle)...',
                  hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.6),
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: Text(
                      '#',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  prefixIconConstraints: BoxConstraints(minWidth: 8.w),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                ),
                style: AppTheme.lightTheme.textTheme.bodyMedium,
                textInputAction: TextInputAction.done,
                onSubmitted: _onSubmitted,
              ),

              // Suggestions Dropdown
              if (_showSuggestions && _filteredSuggestions.isNotEmpty)
                Positioned(
                  top: 7.h,
                  left: 0,
                  right: 0,
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      constraints: BoxConstraints(maxHeight: 20.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.2),
                        ),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: _filteredSuggestions.length,
                        separatorBuilder: (context, index) => Divider(
                          height: 1,
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.1),
                        ),
                        itemBuilder: (context, index) {
                          final suggestion = _filteredSuggestions[index];
                          return ListTile(
                            dense: true,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 4.w),
                            title: Text(
                              suggestion,
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onTap: () => _addTag(suggestion),
                          );
                        },
                      ),
                    ),
                  ),
                ),
            ],
          ),

          SizedBox(height: 2.h),

          // Popular Tags
          Text(
            'Popular Tags',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: _predefinedTags
                .take(6)
                .where((tag) => !widget.selectedTags.contains(tag))
                .map((tag) {
              return GestureDetector(
                onTap:
                    widget.selectedTags.length < 10 ? () => _addTag(tag) : null,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
                  decoration: BoxDecoration(
                    color: widget.selectedTags.length < 10
                        ? AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.1)
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: widget.selectedTags.length < 10
                          ? AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3)
                          : Colors.grey[400]!,
                    ),
                  ),
                  child: Text(
                    tag,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: widget.selectedTags.length < 10
                          ? AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.8)
                          : Colors.grey[600],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
