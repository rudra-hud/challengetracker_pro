import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ProgressChartWidget extends StatefulWidget {
  final List<Map<String, dynamic>> progressData;
  final String selectedPeriod;
  final Function(String)? onPeriodChanged;

  const ProgressChartWidget({
    super.key,
    required this.progressData,
    required this.selectedPeriod,
    this.onPeriodChanged,
  });

  @override
  State<ProgressChartWidget> createState() => _ProgressChartWidgetState();
}

class _ProgressChartWidgetState extends State<ProgressChartWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int? _touchedIndex;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
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
                'Progress Over Time',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              _buildPeriodSelector(theme),
            ],
          ),
          SizedBox(height: 3.h),
          SizedBox(
            height: 30.h,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return LineChart(
                  _buildLineChartData(theme),
                  duration: const Duration(milliseconds: 250),
                );
              },
            ),
          ),
          if (_touchedIndex != null) ...[
            SizedBox(height: 2.h),
            _buildTouchDetails(theme),
          ],
        ],
      ),
    );
  }

  Widget _buildPeriodSelector(ThemeData theme) {
    final periods = ['Week', 'Month', '3 Months', 'Year'];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: periods.map((period) {
          final isSelected = period == widget.selectedPeriod;
          return GestureDetector(
            onTap: () => widget.onPeriodChanged?.call(period),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color:
                    isSelected ? theme.colorScheme.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                period,
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

  LineChartData _buildLineChartData(ThemeData theme) {
    final spots = widget.progressData.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      return FlSpot(
        index.toDouble(),
        (data['completionRate'] as double) * _animation.value,
      );
    }).toList();

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 20,
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
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index >= 0 && index < widget.progressData.length) {
                final date = widget.progressData[index]['date'] as String;
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    date,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
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
            interval: 25,
            getTitlesWidget: (value, meta) {
              return Text(
                '${value.toInt()}%',
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
      maxX: (widget.progressData.length - 1).toDouble(),
      minY: 0,
      maxY: 100,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.primary.withValues(alpha: 0.7),
            ],
          ),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: _touchedIndex == index ? 6 : 4,
                color: theme.colorScheme.primary,
                strokeWidth: 2,
                strokeColor: theme.colorScheme.surface,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary.withValues(alpha: 0.3),
                theme.colorScheme.primary.withValues(alpha: 0.1),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        enabled: true,
        touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
          setState(() {
            if (touchResponse != null && touchResponse.lineBarSpots != null) {
              _touchedIndex = touchResponse.lineBarSpots!.first.spotIndex;
            } else {
              _touchedIndex = null;
            }
          });
        },
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: theme.colorScheme.inverseSurface,
          tooltipRoundedRadius: 8,
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              final index = barSpot.spotIndex;
              final data = widget.progressData[index];
              return LineTooltipItem(
                '${data['date']}\n${barSpot.y.toStringAsFixed(1)}%',
                theme.textTheme.bodySmall!.copyWith(
                  color: theme.colorScheme.onInverseSurface,
                  fontWeight: FontWeight.w500,
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }

  Widget _buildTouchDetails(ThemeData theme) {
    if (_touchedIndex == null || _touchedIndex! >= widget.progressData.length) {
      return const SizedBox.shrink();
    }

    final data = widget.progressData[_touchedIndex!];

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildDetailItem(
            theme,
            'Date',
            data['date'] as String,
            CustomIconWidget(
              iconName: 'calendar_today',
              color: theme.colorScheme.primary,
              size: 16,
            ),
          ),
          _buildDetailItem(
            theme,
            'Completions',
            '${data['completions']}',
            CustomIconWidget(
              iconName: 'check_circle',
              color: theme.colorScheme.primary,
              size: 16,
            ),
          ),
          _buildDetailItem(
            theme,
            'Rate',
            '${data['completionRate'].toStringAsFixed(1)}%',
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

  Widget _buildDetailItem(
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
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}