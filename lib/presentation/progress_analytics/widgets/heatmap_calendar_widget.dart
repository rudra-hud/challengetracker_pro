import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HeatmapCalendarWidget extends StatefulWidget {
  final Map<DateTime, int> completionData;
  final Function(DateTime)? onDateTap;

  const HeatmapCalendarWidget({
    super.key,
    required this.completionData,
    this.onDateTap,
  });

  @override
  State<HeatmapCalendarWidget> createState() => _HeatmapCalendarWidgetState();
}

class _HeatmapCalendarWidgetState extends State<HeatmapCalendarWidget> {
  late ScrollController _scrollController;
  double _scaleFactor = 1.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Color _getIntensityColor(int completionCount) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    if (completionCount == 0) {
      return theme.colorScheme.surface.withValues(alpha: 0.3);
    } else if (completionCount == 1) {
      return primaryColor.withValues(alpha: 0.3);
    } else if (completionCount == 2) {
      return primaryColor.withValues(alpha: 0.6);
    } else {
      return primaryColor;
    }
  }

  List<DateTime> _generateDateRange() {
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month - 6, 1);
    final endDate = DateTime(now.year, now.month + 1, 0);

    List<DateTime> dates = [];
    DateTime current = startDate;

    while (current.isBefore(endDate) || current.isAtSameMomentAs(endDate)) {
      dates.add(current);
      current = current.add(const Duration(days: 1));
    }

    return dates;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dates = _generateDateRange();

    return Container(
      height: 25.h,
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
            'Activity Heatmap',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: GestureDetector(
              onScaleUpdate: (details) {
                setState(() {
                  _scaleFactor = (_scaleFactor * details.scale).clamp(0.8, 2.0);
                });
              },
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: Transform.scale(
                  scale: _scaleFactor,
                  child: _buildHeatmapGrid(dates, theme),
                ),
              ),
            ),
          ),
          SizedBox(height: 1.h),
          _buildLegend(theme),
        ],
      ),
    );
  }

  Widget _buildHeatmapGrid(List<DateTime> dates, ThemeData theme) {
    const int weeksToShow = 26;
    const int daysInWeek = 7;

    return SizedBox(
      width: weeksToShow * 16.0,
      height: daysInWeek * 16.0,
      child: CustomPaint(
        painter: HeatmapPainter(
          dates: dates,
          completionData: widget.completionData,
          getIntensityColor: _getIntensityColor,
          onDateTap: widget.onDateTap,
          theme: theme,
        ),
      ),
    );
  }

  Widget _buildLegend(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Less',
          style: theme.textTheme.bodySmall,
        ),
        Row(
          children: List.generate(4, (index) {
            return Container(
              width: 12,
              height: 12,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: _getIntensityColor(index),
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        ),
        Text(
          'More',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}

class HeatmapPainter extends CustomPainter {
  final List<DateTime> dates;
  final Map<DateTime, int> completionData;
  final Color Function(int) getIntensityColor;
  final Function(DateTime)? onDateTap;
  final ThemeData theme;

  HeatmapPainter({
    required this.dates,
    required this.completionData,
    required this.getIntensityColor,
    this.onDateTap,
    required this.theme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const double cellSize = 14.0;
    const double cellSpacing = 2.0;

    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < dates.length; i++) {
      final date = dates[i];
      final weekIndex = i ~/ 7;
      final dayIndex = i % 7;

      final x = weekIndex * (cellSize + cellSpacing);
      final y = dayIndex * (cellSize + cellSpacing);

      final completionCount =
          completionData[DateTime(date.year, date.month, date.day)] ?? 0;
      paint.color = getIntensityColor(completionCount);

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, cellSize, cellSize),
        const Radius.circular(2),
      );

      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
