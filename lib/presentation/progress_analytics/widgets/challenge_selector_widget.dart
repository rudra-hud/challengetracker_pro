import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ChallengeSelectorWidget extends StatelessWidget {
  final List<Map<String, dynamic>> challenges;
  final String selectedChallengeId;
  final Function(String) onChallengeChanged;

  const ChallengeSelectorWidget({
    super.key,
    required this.challenges,
    required this.selectedChallengeId,
    required this.onChallengeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedChallenge = challenges.firstWhere(
      (challenge) => challenge['id'] == selectedChallengeId,
      orElse: () => challenges.isNotEmpty ? challenges.first : {},
    );

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
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
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedChallengeId,
          isExpanded: true,
          icon: CustomIconWidget(
            iconName: 'keyboard_arrow_down',
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            size: 24,
          ),
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
          dropdownColor: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          items: challenges.map<DropdownMenuItem<String>>((challenge) {
            return DropdownMenuItem<String>(
              value: challenge['id'] as String,
              child: _buildChallengeItem(context, challenge),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              onChallengeChanged(newValue);
            }
          },
        ),
      ),
    );
  }

  Widget _buildChallengeItem(
      BuildContext context, Map<String, dynamic> challenge) {
    final theme = Theme.of(context);
    final title = challenge['title'] as String;
    final progress = challenge['progress'] as double;
    final daysRemaining = challenge['daysRemaining'] as int;
    final isCompleted = challenge['isCompleted'] as bool;

    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isCompleted
                ? Colors.green
                : progress > 0.7
                    ? theme.colorScheme.primary
                    : Colors.orange,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 0.5.h),
              Row(
                children: [
                  Text(
                    '${(progress * 100).toStringAsFixed(0)}% complete',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const Spacer(),
                  if (!isCompleted)
                    Text(
                      '$daysRemaining days left',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  if (isCompleted)
                    CustomIconWidget(
                      iconName: 'check_circle',
                      color: Colors.green,
                      size: 16,
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
