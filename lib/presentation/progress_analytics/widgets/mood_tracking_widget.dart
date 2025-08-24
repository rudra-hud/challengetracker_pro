import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class MoodTrackingWidget extends StatefulWidget {
  final Map<String, int> moodDistribution;
  final Function(String)? onMoodFilter;

  const MoodTrackingWidget({
    super.key,
    required this.moodDistribution,
    this.onMoodFilter,
  });

  @override
  State<MoodTrackingWidget> createState() => _MoodTrackingWidgetState();
}

class _MoodTrackingWidgetState extends State<MoodTrackingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int _touchedIndex = -1;

  final Map<String, String> _moodEmojis = {
    'Excellent': '😄',
    'Good': '😊',
    'Neutral': '😐',
    'Poor': '😔',
    'Terrible': '😢',
  };

  final Map<String, Color> _moodColors = {
    'Excellent': Colors.green,
    'Good': Colors.lightGreen,
    'Neutral': Colors.amber,
    'Poor': Colors.orange,
    'Terrible': Colors.red,
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mood Distribution',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              CustomIconWidget(
                iconName: 'filter_list',
                color: theme.colorScheme.primary,
                size: 20,
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 25.h,
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return PieChart(
                        _buildPieChartData(theme),
                        swapAnimationDuration:
                            const Duration(milliseconds: 750),
                        swapAnimationCurve: Curves.easeInOutQuint,
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                flex: 1,
                child: _buildLegend(theme),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildMoodStats(theme),
        ],
      ),
    );
  }

  PieChartData _buildPieChartData(ThemeData theme) {
    final total =
        widget.moodDistribution.values.fold(0, (sum, count) => sum + count);

    return PieChartData(
      pieTouchData: PieTouchData(
        touchCallback: (FlTouchEvent event, pieTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                pieTouchResponse == null ||
                pieTouchResponse.touchedSection == null) {
              _touchedIndex = -1;
              return;
            }
            _touchedIndex =
                pieTouchResponse.touchedSection!.touchedSectionIndex;
          });
        },
      ),
      borderData: FlBorderData(show: false),
      sectionsSpace: 2,
      centerSpaceRadius: 8.w,
      sections: _buildPieChartSections(total, theme),
    );
  }

  List<PieChartSectionData> _buildPieChartSections(int total, ThemeData theme) {
    final entries = widget.moodDistribution.entries.toList();

    return entries.asMap().entries.map((entry) {
      final index = entry.key;
      final moodEntry = entry.value;
      final mood = moodEntry.key;
      final count = moodEntry.value;
      final isTouched = index == _touchedIndex;
      final percentage = total > 0 ? (count / total * 100) : 0.0;

      return PieChartSectionData(
        color: _moodColors[mood] ?? theme.colorScheme.primary,
        value: count.toDouble() * _animation.value,
        title: isTouched ? '${percentage.toStringAsFixed(1)}%' : '',
        radius: isTouched ? 12.w : 10.w,
        titleStyle: theme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        titlePositionPercentageOffset: 0.6,
      );
    }).toList();
  }

  Widget _buildLegend(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.moodDistribution.entries.map((entry) {
        final mood = entry.key;
        final count = entry.value;
        final total =
            widget.moodDistribution.values.fold(0, (sum, c) => sum + c);
        final percentage = total > 0 ? (count / total * 100) : 0.0;

        return GestureDetector(
          onTap: () => widget.onMoodFilter?.call(mood),
          child: Container(
            margin: EdgeInsets.only(bottom: 1.h),
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: _moodColors[mood]?.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _moodColors[mood],
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            _moodEmojis[mood] ?? '',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              mood,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '$count (${percentage.toStringAsFixed(1)}%)',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMoodStats(ThemeData theme) {
    final total =
        widget.moodDistribution.values.fold(0, (sum, count) => sum + count);
    final mostCommonMood = widget.moodDistribution.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            theme,
            'Total Entries',
            '$total',
            CustomIconWidget(
              iconName: 'edit_note',
              color: theme.colorScheme.primary,
              size: 16,
            ),
          ),
          _buildStatItem(
            theme,
            'Most Common',
            '${_moodEmojis[mostCommonMood]} $mostCommonMood',
            CustomIconWidget(
              iconName: 'trending_up',
              color: theme.colorScheme.primary,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      ThemeData theme, String label, String value, Widget icon) {
    return Column(
      children: [
        icon,
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.primary,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
