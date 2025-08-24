import 'package:flutter/material.dart';
import '../presentation/progress_analytics/progress_analytics.dart';
import '../presentation/challenge_dashboard/challenge_dashboard.dart';
import '../presentation/challenge_creation/challenge_creation.dart';
import '../presentation/journal_timeline/journal_timeline.dart';
import '../presentation/settings_and_profile/settings_and_profile.dart';
import '../presentation/daily_check_in/daily_check_in.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String progressAnalytics = '/progress-analytics';
  static const String challengeDashboard = '/challenge-dashboard';
  static const String challengeCreation = '/challenge-creation';
  static const String journalTimeline = '/journal-timeline';
  static const String settingsAndProfile = '/settings-and-profile';
  static const String dailyCheckIn = '/daily-check-in';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const ProgressAnalytics(),
    progressAnalytics: (context) => const ProgressAnalytics(),
    challengeDashboard: (context) => const ChallengeDashboard(),
    challengeCreation: (context) => const ChallengeCreation(),
    journalTimeline: (context) => const JournalTimeline(),
    settingsAndProfile: (context) => const SettingsAndProfile(),
    dailyCheckIn: (context) => const DailyCheckIn(),
    // TODO: Add your other routes here
  };
}
