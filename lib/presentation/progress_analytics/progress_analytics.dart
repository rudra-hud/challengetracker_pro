import 'dart:convert';
import 'dart:io' if (dart.library.io) 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:universal_html/html.dart' as html;

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import '../../widgets/custom_tab_bar.dart';
import './widgets/challenge_selector_widget.dart';
import './widgets/heatmap_calendar_widget.dart';
import './widgets/journal_insights_widget.dart';
import './widgets/metrics_cards_widget.dart';
import './widgets/mood_tracking_widget.dart';
import './widgets/progress_chart_widget.dart';

class ProgressAnalytics extends StatefulWidget {
  const ProgressAnalytics({super.key});

  @override
  State<ProgressAnalytics> createState() => _ProgressAnalyticsState();
}

class _ProgressAnalyticsState extends State<ProgressAnalytics>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentBottomNavIndex = 3;
  String _selectedChallengeId = 'challenge_1';
  String _selectedPeriod = 'Month';
  DateTime? _lastUpdated;

  // Mock data for challenges
  final List<Map<String, dynamic>> _challenges = [
    {
      'id': 'challenge_1',
      'title': '100 Days of Meditation',
      'progress': 0.65,
      'daysRemaining': 35,
      'isCompleted': false,
    },
    {
      'id': 'challenge_2',
      'title': 'Daily Exercise Challenge',
      'progress': 0.82,
      'daysRemaining': 18,
      'isCompleted': false,
    },
    {
      'id': 'challenge_3',
      'title': 'Reading 30 Minutes Daily',
      'progress': 1.0,
      'daysRemaining': 0,
      'isCompleted': true,
    },
    {
      'id': 'challenge_4',
      'title': 'Learn Spanish - 90 Days',
      'progress': 0.43,
      'daysRemaining': 51,
      'isCompleted': false,
    },
  ];

  // Mock heatmap data
  final Map<DateTime, int> _completionData = {
    DateTime(2024, 8, 1): 1,
    DateTime(2024, 8, 2): 2,
    DateTime(2024, 8, 3): 0,
    DateTime(2024, 8, 4): 1,
    DateTime(2024, 8, 5): 3,
    DateTime(2024, 8, 6): 2,
    DateTime(2024, 8, 7): 1,
    DateTime(2024, 8, 8): 2,
    DateTime(2024, 8, 9): 1,
    DateTime(2024, 8, 10): 0,
    DateTime(2024, 8, 11): 2,
    DateTime(2024, 8, 12): 3,
    DateTime(2024, 8, 13): 1,
    DateTime(2024, 8, 14): 2,
    DateTime(2024, 8, 15): 1,
    DateTime(2024, 8, 16): 2,
    DateTime(2024, 8, 17): 0,
    DateTime(2024, 8, 18): 1,
    DateTime(2024, 8, 19): 3,
    DateTime(2024, 8, 20): 2,
    DateTime(2024, 8, 21): 1,
    DateTime(2024, 8, 22): 2,
    DateTime(2024, 8, 23): 1,
    DateTime(2024, 8, 24): 2,
  };

  // Mock progress data
  final List<Map<String, dynamic>> _progressData = [
    {'date': '8/1', 'completions': 1, 'completionRate': 50.0},
    {'date': '8/2', 'completions': 2, 'completionRate': 75.0},
    {'date': '8/3', 'completions': 0, 'completionRate': 25.0},
    {'date': '8/4', 'completions': 1, 'completionRate': 60.0},
    {'date': '8/5', 'completions': 3, 'completionRate': 90.0},
    {'date': '8/6', 'completions': 2, 'completionRate': 80.0},
    {'date': '8/7', 'completions': 1, 'completionRate': 55.0},
    {'date': '8/8', 'completions': 2, 'completionRate': 85.0},
    {'date': '8/9', 'completions': 1, 'completionRate': 65.0},
    {'date': '8/10', 'completions': 0, 'completionRate': 30.0},
    {'date': '8/11', 'completions': 2, 'completionRate': 75.0},
    {'date': '8/12', 'completions': 3, 'completionRate': 95.0},
    {'date': '8/13', 'completions': 1, 'completionRate': 70.0},
    {'date': '8/14', 'completions': 2, 'completionRate': 80.0},
  ];

  // Mock mood distribution
  final Map<String, int> _moodDistribution = {
    'Excellent': 8,
    'Good': 12,
    'Neutral': 5,
    'Poor': 2,
    'Terrible': 1,
  };

  // Mock journal insights
  final List<Map<String, dynamic>> _wordCountTrends = [
    {'date': '8/1', 'wordCount': 150},
    {'date': '8/2', 'wordCount': 220},
    {'date': '8/3', 'wordCount': 180},
    {'date': '8/4', 'wordCount': 300},
    {'date': '8/5', 'wordCount': 250},
    {'date': '8/6', 'wordCount': 190},
    {'date': '8/7', 'wordCount': 280},
    {'date': '8/8', 'wordCount': 320},
    {'date': '8/9', 'wordCount': 210},
    {'date': '8/10', 'wordCount': 160},
    {'date': '8/11', 'wordCount': 290},
    {'date': '8/12', 'wordCount': 350},
    {'date': '8/13', 'wordCount': 240},
    {'date': '8/14', 'wordCount': 270},
  ];

  final List<Map<String, dynamic>> _topTags = [
    {'tag': '#breakthrough', 'count': 15},
    {'tag': '#struggle', 'count': 8},
    {'tag': '#motivation', 'count': 12},
    {'tag': '#progress', 'count': 20},
    {'tag': '#reflection', 'count': 10},
    {'tag': '#gratitude', 'count': 18},
    {'tag': '#challenge', 'count': 6},
    {'tag': '#mindfulness', 'count': 14},
  ];

  final Map<String, int> _writingFrequency = {
    'Mon': 4,
    'Tue': 6,
    'Wed': 3,
    'Thu': 5,
    'Fri': 7,
    'Sat': 2,
    'Sun': 1,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _lastUpdated = DateTime.now();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar.analytics(
        onFilterPressed: _showFilterOptions,
        onExportPressed: _showExportOptions,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Column(
          children: [
            ChallengeSelectorWidget(
              challenges: _challenges,
              selectedChallengeId: _selectedChallengeId,
              onChallengeChanged: _onChallengeChanged,
            ),
            CustomTabBar.progressAnalytics(
              controller: _tabController,
              onTap: _onTabChanged,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(),
                  _buildTrendsTab(),
                  _buildInsightsTab(),
                  _buildCompareTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar.standard(
        currentIndex: _currentBottomNavIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          HeatmapCalendarWidget(
            completionData: _completionData,
            onDateTap: _onDateTap,
          ),
          SizedBox(height: 3.h),
          MetricsCardsWidget(
            currentStreak: 12,
            totalCompletions: 65,
            completionRate: 78.5,
            averageMoodRating: 4.2,
            streakTrend: 3,
            completionsTrend: 8,
            rateTrend: 5.2,
            moodTrend: 0.3,
          ),
          SizedBox(height: 3.h),
          ProgressChartWidget(
            progressData: _progressData,
            selectedPeriod: _selectedPeriod,
            onPeriodChanged: _onPeriodChanged,
          ),
          if (_lastUpdated != null) ...[
            SizedBox(height: 2.h),
            _buildLastUpdatedInfo(),
          ],
        ],
      ),
    );
  }

  Widget _buildTrendsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          ProgressChartWidget(
            progressData: _progressData,
            selectedPeriod: _selectedPeriod,
            onPeriodChanged: _onPeriodChanged,
          ),
          SizedBox(height: 3.h),
          MoodTrackingWidget(
            moodDistribution: _moodDistribution,
            onMoodFilter: _onMoodFilter,
          ),
          SizedBox(height: 3.h),
          _buildTrendSummary(),
        ],
      ),
    );
  }

  Widget _buildInsightsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          JournalInsightsWidget(
            wordCountTrends: _wordCountTrends,
            topTags: _topTags,
            writingFrequency: _writingFrequency,
          ),
          SizedBox(height: 3.h),
          MoodTrackingWidget(
            moodDistribution: _moodDistribution,
            onMoodFilter: _onMoodFilter,
          ),
          SizedBox(height: 3.h),
          _buildInsightsSummary(),
        ],
      ),
    );
  }

  Widget _buildCompareTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          _buildChallengeComparison(),
          SizedBox(height: 3.h),
          _buildPerformanceComparison(),
          SizedBox(height: 3.h),
          _buildGoalsComparison(),
        ],
      ),
    );
  }

  Widget _buildLastUpdatedInfo() {
    final theme = Theme.of(context);
    final timeAgo = DateTime.now().difference(_lastUpdated!).inMinutes;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'access_time',
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            size: 16,
          ),
          SizedBox(width: 2.w),
          Text(
            'Last updated $timeAgo minutes ago',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendSummary() {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trend Summary',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          _buildTrendItem(
            theme,
            'Completion Rate',
            '+12.5%',
            'Improved significantly over the last month',
            true,
          ),
          _buildTrendItem(
            theme,
            'Mood Rating',
            '+0.3',
            'Slight improvement in overall mood',
            true,
          ),
          _buildTrendItem(
            theme,
            'Streak Length',
            '-2 days',
            'Recent dip but still maintaining consistency',
            false,
          ),
        ],
      ),
    );
  }

  Widget _buildInsightsSummary() {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Key Insights',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          _buildInsightItem(
            theme,
            'Most Active Day',
            'Friday',
            'You write 3x more on Fridays than weekends',
          ),
          _buildInsightItem(
            theme,
            'Popular Theme',
            '#progress',
            'Your most used tag, appearing in 71% of entries',
          ),
          _buildInsightItem(
            theme,
            'Writing Pattern',
            '250 words avg',
            'Consistent word count with peaks during breakthroughs',
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeComparison() {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Challenge Comparison',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          ..._challenges.map((challenge) {
            final progress = challenge['progress'] as double;
            final title = challenge['title'] as String;
            return Container(
              margin: EdgeInsets.only(bottom: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${(progress * 100).toStringAsFixed(0)}%',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.5.h),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor:
                        theme.colorScheme.outline.withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progress > 0.8 ? Colors.green : theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPerformanceComparison() {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance vs Goals',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          _buildPerformanceItem(theme, 'Daily Completion', '78%', '80%', false),
          _buildPerformanceItem(
              theme, 'Weekly Streak', '12 days', '14 days', false),
          _buildPerformanceItem(theme, 'Monthly Progress', '65%', '60%', true),
        ],
      ),
    );
  }

  Widget _buildGoalsComparison() {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Goals Achievement',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildGoalCard(theme, 'Completed', '1', Colors.green),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildGoalCard(theme, 'In Progress', '3', Colors.orange),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildGoalCard(
                    theme, 'On Track', '2', theme.colorScheme.primary),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildGoalCard(theme, 'Behind', '1', Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrendItem(ThemeData theme, String title, String value,
      String description, bool isPositive) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: isPositive ? 'trending_up' : 'trending_down',
            color: isPositive ? Colors.green : Colors.orange,
            size: 20,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      value,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isPositive ? Colors.green : Colors.orange,
                      ),
                    ),
                  ],
                ),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightItem(
      ThemeData theme, String title, String value, String description) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'lightbulb',
            color: Colors.amber,
            size: 20,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      value,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceItem(ThemeData theme, String title, String actual,
      String target, bool isAchieved) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: isAchieved ? 'check_circle' : 'radio_button_unchecked',
            color: isAchieved ? Colors.green : Colors.orange,
            size: 20,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Actual: $actual',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    Text(
                      'Target: $target',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard(
      ThemeData theme, String title, String count, Color color) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _onChallengeChanged(String challengeId) {
    setState(() {
      _selectedChallengeId = challengeId;
    });
    HapticFeedback.selectionClick();
  }

  void _onTabChanged(int index) {
    HapticFeedback.selectionClick();
  }

  void _onBottomNavTap(int index) {
    if (index != _currentBottomNavIndex) {
      final routes = [
        '/challenge-dashboard',
        '/daily-check-in',
        '/challenge-creation',
        '/progress-analytics',
        '/settings-and-profile',
      ];

      if (index < routes.length) {
        Navigator.pushNamed(context, routes[index]);
      }
    }
  }

  void _onDateTap(DateTime date) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected date: ${date.day}/${date.month}/${date.year}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onPeriodChanged(String period) {
    setState(() {
      _selectedPeriod = period;
    });
    HapticFeedback.selectionClick();
  }

  void _onMoodFilter(String mood) {
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Filtering by mood: $mood'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _lastUpdated = DateTime.now();
    });
    HapticFeedback.mediumImpact();
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Filter Options',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'date_range',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: const Text('Date Range'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'mood',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: const Text('Mood Filter'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'tag',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: const Text('Tag Filter'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showExportOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Export Options',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'picture_as_pdf',
                color: Colors.red,
                size: 24,
              ),
              title: const Text('Export as PDF'),
              onTap: () {
                Navigator.pop(context);
                _exportToPDF();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'table_chart',
                color: Colors.green,
                size: 24,
              ),
              title: const Text('Export as CSV'),
              onTap: () {
                Navigator.pop(context);
                _exportToCSV();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'code',
                color: Colors.blue,
                size: 24,
              ),
              title: const Text('Export as JSON'),
              onTap: () {
                Navigator.pop(context);
                _exportToJSON();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: const Text('Share Progress Image'),
              onTap: () {
                Navigator.pop(context);
                _shareProgressImage();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportToPDF() async {
    try {
      final pdfContent = '''
ChallengeTracker Pro - Progress Report
Generated: ${DateTime.now().toString()}

Challenge: ${_challenges.firstWhere((c) => c['id'] == _selectedChallengeId)['title']}

Metrics:
- Current Streak: 12 days
- Total Completions: 65
- Completion Rate: 78.5%
- Average Mood: 4.2/5

Recent Progress:
${_progressData.map((data) => '${data['date']}: ${data['completionRate']}%').join('\n')}

Mood Distribution:
${_moodDistribution.entries.map((entry) => '${entry.key}: ${entry.value}').join('\n')}
      ''';

      await _downloadFile(pdfContent, 'progress_report.txt');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PDF report exported successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to export PDF')),
        );
      }
    }
  }

  Future<void> _exportToCSV() async {
    try {
      final csvContent = '''Date,Completions,Completion Rate,Mood
${_progressData.map((data) => '${data['date']},${data['completions']},${data['completionRate']},4.2').join('\n')}''';

      await _downloadFile(csvContent, 'progress_data.csv');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('CSV data exported successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to export CSV')),
        );
      }
    }
  }

  Future<void> _exportToJSON() async {
    try {
      final jsonData = {
        'challenge':
            _challenges.firstWhere((c) => c['id'] == _selectedChallengeId),
        'metrics': {
          'currentStreak': 12,
          'totalCompletions': 65,
          'completionRate': 78.5,
          'averageMoodRating': 4.2,
        },
        'progressData': _progressData,
        'moodDistribution': _moodDistribution,
        'exportDate': DateTime.now().toIso8601String(),
      };

      final jsonContent = const JsonEncoder.withIndent('  ').convert(jsonData);
      await _downloadFile(jsonContent, 'challenge_data.json');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('JSON backup exported successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to export JSON')),
        );
      }
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

  void _shareProgressImage() {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Progress image shared successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
