import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sizer/sizer.dart';

class JournalInsightsWidget extends StatefulWidget {
  final List<Map<String, dynamic>> wordCountTrends;
  final List<Map<String, dynamic>> topTags;
  final Map<String, int> writingFrequency;

  const JournalInsightsWidget({
    super.key,
    required this.wordCountTrends,
    required this.topTags,
    required this.writingFrequency,
  });

  @override
  State<JournalInsightsWidget> createState() => _JournalInsightsWidgetState();
}

class _JournalInsightsWidgetState extends State<JournalInsightsWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  String _selectedInsight = 'Word Count';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
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
                'Journal Insights',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              _buildInsightSelector(theme),
            ],
          ),
          SizedBox(height: 3.h),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return _buildSelectedInsight(theme);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInsightSelector(ThemeData theme) {
    final insights = ['Word Count', 'Tags', 'Frequency'];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: insights.map((insight) {
          final isSelected = insight == _selectedInsight;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedInsight = insight;
              });
              _animationController.reset();
              _animationController.forward();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color:
                    isSelected ? theme.colorScheme.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                insight,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isSelected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSelectedInsight(ThemeData theme) {
    switch (_selectedInsight) {
      case 'Word Count':
        return _buildWordCountChart(theme);
      case 'Tags':
        return _buildTagsCloud(theme);
      case 'Frequency':
        return _buildFrequencyChart(theme);
      default:
        return _buildWordCountChart(theme);
    }
  }

  Widget _buildWordCountChart(ThemeData theme) {
    return SizedBox(
      height: 25.h,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 50,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < widget.wordCountTrends.length) {
                    final date =
                        widget.wordCountTrends[index]['date'] as String;
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(
                        date,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 100,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  );
                },
                reservedSize: 42,
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: (widget.wordCountTrends.length - 1).toDouble(),
          minY: 0,
          maxY: widget.wordCountTrends.isNotEmpty
              ? widget.wordCountTrends
                      .map((e) => e['wordCount'] as int)
                      .reduce((a, b) => a > b ? a : b)
                      .toDouble() +
                  50
              : 100,
          lineBarsData: [
            LineChartBarData(
              spots: widget.wordCountTrends.asMap().entries.map((entry) {
                return FlSpot(
                  entry.key.toDouble(),
                  (entry.value['wordCount'] as int).toDouble() *
                      _animation.value,
                );
              }).toList(),
              isCurved: true,
              color: theme.colorScheme.secondary,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: theme.colorScheme.secondary.withValues(alpha: 0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagsCloud(ThemeData theme) {
    return SizedBox(
      height: 25.h,
      child: SingleChildScrollView(
        child: Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: widget.topTags.map((tagData) {
            final tag = tagData['tag'] as String;
            final count = tagData['count'] as int;
            final maxCount = widget.topTags.isNotEmpty
                ? widget.topTags
                    .map((e) => e['count'] as int)
                    .reduce((a, b) => a > b ? a : b)
                : 1;
            final intensity = (count / maxCount).clamp(0.3, 1.0);

            return AnimatedContainer(
              duration:
                  Duration(milliseconds: (500 + count * 100).clamp(500, 1500)),
              curve: Curves.easeOutBack,
              transform: Matrix4.identity()..scale(_animation.value),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary
                      .withValues(alpha: intensity * 0.8),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color:
                        theme.colorScheme.primary.withValues(alpha: intensity),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      tag,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w500,
                        fontSize: (12 + intensity * 4).sp,
                      ),
                    ),
                    SizedBox(width: 1.w),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color:
                            theme.colorScheme.onPrimary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$count',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFrequencyChart(ThemeData theme) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final maxFrequency = widget.writingFrequency.values.isNotEmpty
        ? widget.writingFrequency.values.reduce((a, b) => a > b ? a : b)
        : 1;

    return SizedBox(
      height: 25.h,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxFrequency.toDouble() + 2,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < days.length) {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(
                        days[index],
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                        ),
                      ),
                    );
                  }
                  return const Text('');
                },
                reservedSize: 30,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  );
                },
              ),
            ),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          barGroups: days.asMap().entries.map((entry) {
            final index = entry.key;
            final day = entry.value;
            final frequency = widget.writingFrequency[day] ?? 0;

            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: frequency.toDouble() * _animation.value,
                  color: theme.colorScheme.tertiary,
                  width: 6.w,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }).toList(),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
                strokeWidth: 1,
              );
            },
          ),
        ),
      ),
    );
  }
}
