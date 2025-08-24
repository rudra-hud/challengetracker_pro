import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RichTextEditorWidget extends StatefulWidget {
  final String? initialText;
  final Function(String) onTextChanged;
  final VoidCallback? onVoiceToText;

  const RichTextEditorWidget({
    super.key,
    this.initialText,
    required this.onTextChanged,
    this.onVoiceToText,
  });

  @override
  State<RichTextEditorWidget> createState() => _RichTextEditorWidgetState();
}

class _RichTextEditorWidgetState extends State<RichTextEditorWidget> {
  late TextEditingController _textController;
  late FocusNode _focusNode;
  bool _showToolbar = false;
  bool _isBold = false;
  bool _isItalic = false;
  bool _isList = false;
  int _selectionStart = 0;
  int _selectionEnd = 0;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialText ?? '');
    _focusNode = FocusNode();

    _textController.addListener(() {
      widget.onTextChanged(_textController.text);
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleTextSelection() {
    final selection = _textController.selection;
    if (selection.baseOffset != selection.extentOffset) {
      setState(() {
        _showToolbar = true;
        _selectionStart = selection.start;
        _selectionEnd = selection.end;
      });
    } else {
      setState(() {
        _showToolbar = false;
      });
    }
  }

  void _applyFormatting(String format) {
    final text = _textController.text;
    final selectedText = text.substring(_selectionStart, _selectionEnd);
    String formattedText = selectedText;

    switch (format) {
      case 'bold':
        formattedText = '**$selectedText**';
        setState(() => _isBold = !_isBold);
        break;
      case 'italic':
        formattedText = '*$selectedText*';
        setState(() => _isItalic = !_isItalic);
        break;
      case 'list':
        final lines = selectedText.split('\n');
        formattedText = lines.map((line) => '• $line').join('\n');
        setState(() => _isList = !_isList);
        break;
    }

    final newText =
        text.replaceRange(_selectionStart, _selectionEnd, formattedText);
    _textController.text = newText;
    _textController.selection = TextSelection.collapsed(
      offset: _selectionStart + formattedText.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          // Toolbar
          if (_showToolbar)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                children: [
                  _buildToolbarButton('bold', 'format_bold', _isBold),
                  SizedBox(width: 2.w),
                  _buildToolbarButton('italic', 'format_italic', _isItalic),
                  SizedBox(width: 2.w),
                  _buildToolbarButton('list', 'format_list_bulleted', _isList),
                  const Spacer(),
                  if (widget.onVoiceToText != null)
                    GestureDetector(
                      onTap: widget.onVoiceToText,
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomIconWidget(
                          iconName: 'mic',
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          size: 18,
                        ),
                      ),
                    ),
                ],
              ),
            ),

          // Text Editor
          Container(
            constraints: BoxConstraints(
              minHeight: 20.h,
              maxHeight: 35.h,
            ),
            padding: EdgeInsets.all(4.w),
            child: TextField(
              controller: _textController,
              focusNode: _focusNode,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText:
                    'How did your challenge go today? Share your thoughts, struggles, and victories...',
                hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              onTap: _handleTextSelection,
              onChanged: (value) {
                _handleTextSelection();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbarButton(String format, String iconName, bool isActive) {
    return GestureDetector(
      onTap: () => _applyFormatting(format),
      child: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: isActive
              ? AppTheme.lightTheme.colorScheme.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: CustomIconWidget(
          iconName: iconName,
          color: isActive
              ? AppTheme.lightTheme.colorScheme.onPrimary
              : AppTheme.lightTheme.colorScheme.onSurface,
          size: 18,
        ),
      ),
    );
  }
}
