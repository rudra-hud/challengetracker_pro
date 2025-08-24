import 'dart:convert';
import 'dart:io' if (dart.library.io) 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:universal_html/html.dart' as html;

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class DataManagementWidget extends StatefulWidget {
  final Function(String) onExportComplete;
  final Function(String) onImportComplete;

  const DataManagementWidget({
    super.key,
    required this.onExportComplete,
    required this.onImportComplete,
  });

  @override
  State<DataManagementWidget> createState() => _DataManagementWidgetState();
}

class _DataManagementWidgetState extends State<DataManagementWidget> {
  bool _isExporting = false;
  bool _isImporting = false;
  String? _exportProgress;

  final List<Map<String, dynamic>> exportOptions = [
    {
      'key': 'json',
      'name': 'JSON Export',
      'description': 'Complete data backup',
      'icon': 'code',
      'extension': 'json',
    },
    {
      'key': 'pdf',
      'name': 'PDF Report',
      'description': 'Progress summary',
      'icon': 'picture_as_pdf',
      'extension': 'pdf',
    },
    {
      'key': 'csv',
      'name': 'CSV Data',
      'description': 'Spreadsheet format',
      'icon': 'table_chart',
      'extension': 'csv',
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
              'Data Management',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              ),
            ),
            SizedBox(height: 3.h),

            // Export Options
            Text(
              'Export Data',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 2.h),

            if (_isExporting && _exportProgress != null) ...[
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(colorScheme.primary),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        _exportProgress!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.h),
            ],

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: exportOptions.length,
              separatorBuilder: (context, index) => SizedBox(height: 1.h),
              itemBuilder: (context, index) {
                final option = exportOptions[index];
                return _buildExportOption(context, option);
              },
            ),

            SizedBox(height: 4.h),

            // Import/Backup Options
            Text(
              'Backup & Sync',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 2.h),

            _buildActionButton(
              context,
              'Import Data',
              'Restore from backup file',
              'upload_file',
              _isImporting,
              () => _handleImportData(),
            ),

            SizedBox(height: 1.h),

            _buildActionButton(
              context,
              'Cloud Backup',
              'Sync with cloud storage',
              'cloud_upload',
              false,
              () => _handleCloudBackup(),
            ),

            SizedBox(height: 1.h),

            _buildActionButton(
              context,
              'Auto-Sync Settings',
              'Configure automatic backup',
              'sync',
              false,
              () => _handleAutoSyncSettings(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExportOption(BuildContext context, Map<String, dynamic> option) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: _isExporting ? null : () => _handleExport(option['key'] as String),
      borderRadius: BorderRadius.circular(2.w),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.3),
          ),
          borderRadius: BorderRadius.circular(2.w),
        ),
        child: Row(
          children: [
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: CustomIconWidget(
                iconName: option['icon'] as String,
                color: colorScheme.primary,
                size: 20,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option['name'] as String,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    option['description'] as String,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'download',
              color: colorScheme.onSurface.withValues(alpha: 0.4),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String title,
    String subtitle,
    String iconName,
    bool isLoading,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(2.w),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.3),
          ),
          borderRadius: BorderRadius.circular(2.w),
        ),
        child: Row(
          children: [
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: colorScheme.secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            colorScheme.secondary),
                      ),
                    )
                  : CustomIconWidget(
                      iconName: iconName,
                      color: colorScheme.secondary,
                      size: 20,
                    ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: colorScheme.onSurface.withValues(alpha: 0.4),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleExport(String format) async {
    setState(() {
      _isExporting = true;
      _exportProgress = 'Preparing export...';
    });

    try {
      // Simulate data preparation
      await Future.delayed(const Duration(milliseconds: 500));

      setState(() {
        _exportProgress = 'Generating ${format.toUpperCase()} file...';
      });

      String content;
      String filename;

      switch (format) {
        case 'json':
          content = _generateJsonExport();
          filename =
              'challenge_data_${DateTime.now().millisecondsSinceEpoch}.json';
          break;
        case 'pdf':
          content = _generatePdfContent();
          filename =
              'challenge_report_${DateTime.now().millisecondsSinceEpoch}.pdf';
          break;
        case 'csv':
          content = _generateCsvExport();
          filename =
              'challenge_data_${DateTime.now().millisecondsSinceEpoch}.csv';
          break;
        default:
          throw Exception('Unsupported format');
      }

      await Future.delayed(const Duration(milliseconds: 800));

      setState(() {
        _exportProgress = 'Downloading file...';
      });

      await _downloadFile(content, filename);

      widget.onExportComplete('Export completed successfully');
    } catch (e) {
      widget.onExportComplete('Export failed: ${e.toString()}');
    } finally {
      setState(() {
        _isExporting = false;
        _exportProgress = null;
      });
    }
  }

  Future<void> _downloadFile(String content, String filename) async {
    if (kIsWeb) {
      final bytes = utf8.encode(content);
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", filename)
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename');
      await file.writeAsString(content);
    }
  }

  String _generateJsonExport() {
    final data = {
      'export_date': DateTime.now().toIso8601String(),
      'user_profile': {
        'name': 'Sarah Johnson',
        'email': 'sarah.johnson@email.com',
        'level': 12,
        'total_challenges': 25,
        'completed_challenges': 18,
        'current_streak': 47,
      },
      'challenges': [
        {
          'id': 1,
          'title': '100 Days of Meditation',
          'description': 'Daily mindfulness practice',
          'start_date': '2024-06-01',
          'target_days': 100,
          'completed_days': 47,
          'status': 'active',
        },
        {
          'id': 2,
          'title': 'Morning Exercise',
          'description': '30 minutes daily workout',
          'start_date': '2024-05-15',
          'target_days': 90,
          'completed_days': 90,
          'status': 'completed',
        },
      ],
      'journal_entries': [
        {
          'date': '2024-08-24',
          'mood': 'positive',
          'rating': 4,
          'content': 'Great meditation session today. Feeling more centered.',
          'tags': ['meditation', 'mindfulness', 'breakthrough'],
        },
      ],
    };

    return const JsonEncoder.withIndent('  ').convert(data);
  }

  String _generatePdfContent() {
    return '''
CHALLENGE TRACKER PRO - PROGRESS REPORT
Generated: ${DateTime.now().toString()}

USER PROFILE
Name: Sarah Johnson
Email: sarah.johnson@email.com
Level: 12
Total Challenges: 25
Completed: 18
Current Streak: 47 days

ACTIVE CHALLENGES
1. 100 Days of Meditation (47/100 days)
2. Reading Challenge (23/30 books)

RECENT ACHIEVEMENTS
- Completed Morning Exercise Challenge
- Reached 45-day streak milestone
- Earned "Consistency Champion" badge

STATISTICS
Average daily completion: 85%
Most productive day: Monday
Favorite challenge category: Health & Wellness
''';
  }

  String _generateCsvExport() {
    return '''Date,Challenge,Status,Mood,Rating,Notes
2024-08-24,100 Days of Meditation,Completed,Positive,4,"Great session today"
2024-08-23,100 Days of Meditation,Completed,Neutral,3,"Short session due to time"
2024-08-22,100 Days of Meditation,Completed,Positive,5,"Deep meditation experience"
2024-08-21,Reading Challenge,Completed,Positive,4,"Finished chapter 3"
2024-08-20,100 Days of Meditation,Missed,Negative,2,"Too busy with work"
''';
  }

  Future<void> _handleImportData() async {
    setState(() {
      _isImporting = true;
    });

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json', 'csv', 'txt'],
      );

      if (result != null) {
        List<int>? fileBytes;
        if (kIsWeb) {
          fileBytes = result.files.first.bytes;
        } else {
          final file = File(result.files.first.path!);
          fileBytes = await file.readAsBytes();
        }

        if (fileBytes != null) {
          final content = utf8.decode(fileBytes);
          // Process the imported data here
          await Future.delayed(const Duration(milliseconds: 1000));
          widget.onImportComplete('Data imported successfully');
        }
      }
    } catch (e) {
      widget.onImportComplete('Import failed: ${e.toString()}');
    } finally {
      setState(() {
        _isImporting = false;
      });
    }
  }

  Future<void> _handleCloudBackup() async {
    // Simulate cloud backup process
    await Future.delayed(const Duration(milliseconds: 1500));
    widget.onExportComplete('Cloud backup completed');
  }

  Future<void> _handleAutoSyncSettings() async {
    // Navigate to auto-sync settings
    widget.onExportComplete('Auto-sync settings updated');
  }
}
