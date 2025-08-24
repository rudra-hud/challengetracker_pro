import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/achievement_badges_widget.dart';
import './widgets/data_management_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/settings_section_widget.dart';
import './widgets/theme_customization_widget.dart';

class SettingsAndProfile extends StatefulWidget {
  const SettingsAndProfile({super.key});

  @override
  State<SettingsAndProfile> createState() => _SettingsAndProfileState();
}

class _SettingsAndProfileState extends State<SettingsAndProfile> {
  int _currentBottomIndex = 4; // Profile tab active
  String _currentTheme = 'system';
  String _currentColorScheme = 'default';

  // Mock user profile data
  final Map<String, dynamic> userProfile = {
    'name': 'Sarah Johnson',
    'email': 'sarah.johnson@email.com',
    'avatar':
        'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400&h=400&fit=crop&crop=face',
    'level': 12,
    'totalChallenges': 25,
    'completedChallenges': 18,
    'currentStreak': 47,
  };

  // Mock achievement badges data
  final List<Map<String, dynamic>> achievementBadges = [
    {
      'id': 1,
      'name': 'First Steps',
      'icon': 'emoji_events',
      'earned': true,
      'description': 'Complete your first challenge',
    },
    {
      'id': 2,
      'name': 'Streak Master',
      'icon': 'local_fire_department',
      'earned': true,
      'description': 'Maintain a 30-day streak',
    },
    {
      'id': 3,
      'name': 'Consistency Champion',
      'icon': 'military_tech',
      'earned': true,
      'description': 'Complete 10 challenges',
    },
    {
      'id': 4,
      'name': 'Century Club',
      'icon': 'workspace_premium',
      'earned': false,
      'description': 'Complete a 100-day challenge',
    },
    {
      'id': 5,
      'name': 'Social Butterfly',
      'icon': 'share',
      'earned': false,
      'description': 'Share 5 progress updates',
    },
    {
      'id': 6,
      'name': 'Reflection Master',
      'icon': 'auto_stories',
      'earned': true,
      'description': 'Write 50 journal entries',
    },
  ];

  // Settings sections data
  late List<Map<String, dynamic>> settingsSections;

  @override
  void initState() {
    super.initState();
    _initializeSettingsSections();
  }

  void _initializeSettingsSections() {
    settingsSections = [
      {
        'title': 'Account',
        'items': [
          {
            'key': 'edit_profile',
            'title': 'Edit Profile',
            'subtitle': 'Update your personal information',
            'icon': 'person',
            'type': 'disclosure',
          },
          {
            'key': 'change_password',
            'title': 'Change Password',
            'subtitle': 'Update your account security',
            'icon': 'lock',
            'type': 'disclosure',
          },
          {
            'key': 'privacy_settings',
            'title': 'Privacy Settings',
            'subtitle': 'Control your data and visibility',
            'icon': 'privacy_tip',
            'type': 'disclosure',
          },
          {
            'key': 'biometric_auth',
            'title': 'Biometric Authentication',
            'subtitle': 'Use fingerprint or face unlock',
            'icon': 'fingerprint',
            'type': 'switch',
            'value': true,
          },
        ],
      },
      {
        'title': 'Notifications',
        'items': [
          {
            'key': 'push_notifications',
            'title': 'Push Notifications',
            'subtitle': 'Daily reminders and updates',
            'icon': 'notifications',
            'type': 'switch',
            'value': true,
          },
          {
            'key': 'email_digest',
            'title': 'Email Digest',
            'subtitle': 'Weekly progress summary',
            'icon': 'email',
            'type': 'switch',
            'value': false,
          },
          {
            'key': 'reminder_times',
            'title': 'Reminder Times',
            'subtitle': 'Customize notification schedule',
            'icon': 'schedule',
            'type': 'value',
            'value': '9:00 AM, 6:00 PM',
          },
          {
            'key': 'streak_alerts',
            'title': 'Streak Protection',
            'subtitle': 'Alerts when streak is at risk',
            'icon': 'warning',
            'type': 'switch',
            'value': true,
          },
        ],
      },
      {
        'title': 'Accessibility',
        'items': [
          {
            'key': 'high_contrast',
            'title': 'High Contrast Mode',
            'subtitle': 'Improve text readability',
            'icon': 'contrast',
            'type': 'switch',
            'value': false,
          },
          {
            'key': 'large_text',
            'title': 'Large Text',
            'subtitle': 'Increase font size',
            'icon': 'text_fields',
            'type': 'switch',
            'value': false,
          },
          {
            'key': 'screen_reader',
            'title': 'Screen Reader Support',
            'subtitle': 'Enhanced accessibility features',
            'icon': 'accessibility',
            'type': 'switch',
            'value': false,
          },
        ],
      },
      {
        'title': 'Help & Support',
        'items': [
          {
            'key': 'faq',
            'title': 'FAQ',
            'subtitle': 'Frequently asked questions',
            'icon': 'help',
            'type': 'disclosure',
          },
          {
            'key': 'contact_support',
            'title': 'Contact Support',
            'subtitle': 'Get help from our team',
            'icon': 'support_agent',
            'type': 'disclosure',
          },
          {
            'key': 'app_version',
            'title': 'App Version',
            'subtitle': 'Check for updates',
            'icon': 'info',
            'type': 'value',
            'value': '2.1.0',
          },
          {
            'key': 'rate_app',
            'title': 'Rate App',
            'subtitle': 'Share your feedback',
            'icon': 'star',
            'type': 'disclosure',
          },
        ],
      },
      {
        'title': 'Account Management',
        'items': [
          {
            'key': 'delete_account',
            'title': 'Delete Account',
            'subtitle': 'Permanently remove your account',
            'icon': 'delete_forever',
            'type': 'action',
            'actionIcon': 'warning',
          },
        ],
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CustomAppBar.dashboard(
        title: 'Settings & Profile',
        onMenuPressed: () => _showMenuOptions(context),
        onNotificationPressed: () => _showNotifications(context),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 2.h),

            // Profile Header
            ProfileHeaderWidget(userProfile: userProfile),

            SizedBox(height: 2.h),

            // Achievement Badges
            AchievementBadgesWidget(badges: achievementBadges),

            SizedBox(height: 2.h),

            // Theme Customization
            ThemeCustomizationWidget(
              currentTheme: _currentTheme,
              currentColorScheme: _currentColorScheme,
              onThemeChanged: _handleThemeChange,
              onColorSchemeChanged: _handleColorSchemeChange,
            ),

            SizedBox(height: 2.h),

            // Data Management
            DataManagementWidget(
              onExportComplete: _handleExportComplete,
              onImportComplete: _handleImportComplete,
            ),

            SizedBox(height: 2.h),

            // Settings Sections
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: settingsSections.length,
              itemBuilder: (context, index) {
                final section = settingsSections[index];
                return SettingsSectionWidget(
                  title: section['title'] as String,
                  items:
                      (section['items'] as List).cast<Map<String, dynamic>>(),
                  onItemTap: _handleSettingItemTap,
                );
              },
            ),

            SizedBox(height: 10.h), // Bottom padding for navigation
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar.standard(
        currentIndex: _currentBottomIndex,
        onTap: _handleBottomNavigation,
      ),
    );
  }

  void _handleBottomNavigation(int index) {
    if (index == _currentBottomIndex) return;

    setState(() {
      _currentBottomIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/challenge-dashboard');
        break;
      case 1:
        Navigator.pushNamed(context, '/daily-check-in');
        break;
      case 2:
        Navigator.pushNamed(context, '/challenge-creation');
        break;
      case 3:
        Navigator.pushNamed(context, '/progress-analytics');
        break;
      case 4:
        // Already on settings page
        break;
    }
  }

  void _handleThemeChange(String theme) {
    setState(() {
      _currentTheme = theme;
    });
    _showSuccessMessage('Theme updated to ${theme.toUpperCase()}');
  }

  void _handleColorSchemeChange(String colorScheme) {
    setState(() {
      _currentColorScheme = colorScheme;
    });
    _showSuccessMessage('Color scheme updated');
  }

  void _handleExportComplete(String message) {
    _showSuccessMessage(message);
  }

  void _handleImportComplete(String message) {
    _showSuccessMessage(message);
  }

  void _handleSettingItemTap(String key) {
    switch (key) {
      case 'edit_profile':
        _showEditProfileDialog();
        break;
      case 'change_password':
        _showChangePasswordDialog();
        break;
      case 'privacy_settings':
        _showPrivacySettings();
        break;
      case 'biometric_auth':
        _toggleBiometricAuth();
        break;
      case 'push_notifications':
        _togglePushNotifications();
        break;
      case 'email_digest':
        _toggleEmailDigest();
        break;
      case 'reminder_times':
        _showReminderTimePicker();
        break;
      case 'streak_alerts':
        _toggleStreakAlerts();
        break;
      case 'high_contrast':
        _toggleHighContrast();
        break;
      case 'large_text':
        _toggleLargeText();
        break;
      case 'screen_reader':
        _toggleScreenReader();
        break;
      case 'faq':
        _showFAQ();
        break;
      case 'contact_support':
        _showContactSupport();
        break;
      case 'app_version':
        _checkForUpdates();
        break;
      case 'rate_app':
        _showRateApp();
        break;
      case 'delete_account':
        _showDeleteAccountDialog();
        break;
    }
  }

  void _showMenuOptions(BuildContext context) {
    Navigator.pushNamed(context, '/journal-timeline');
  }

  void _showNotifications(BuildContext context) {
    _showSuccessMessage('Notifications opened');
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: const Text(
            'Profile editing functionality would be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessMessage('Profile updated successfully');
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter your current password and new password.'),
            SizedBox(height: 2.h),
            const Text(
              'Mock Credentials:\nCurrent: oldpass123\nNew: newpass456',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessMessage('Password changed successfully');
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showPrivacySettings() {
    _showSuccessMessage('Privacy settings opened');
  }

  void _toggleBiometricAuth() {
    _updateSettingValue('biometric_auth', 'Account');
    _showSuccessMessage('Biometric authentication toggled');
  }

  void _togglePushNotifications() {
    _updateSettingValue('push_notifications', 'Notifications');
    _showSuccessMessage('Push notifications toggled');
  }

  void _toggleEmailDigest() {
    _updateSettingValue('email_digest', 'Notifications');
    _showSuccessMessage('Email digest toggled');
  }

  void _showReminderTimePicker() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((time) {
      if (time != null) {
        _showSuccessMessage('Reminder time updated');
      }
    });
  }

  void _toggleStreakAlerts() {
    _updateSettingValue('streak_alerts', 'Notifications');
    _showSuccessMessage('Streak alerts toggled');
  }

  void _toggleHighContrast() {
    _updateSettingValue('high_contrast', 'Accessibility');
    _showSuccessMessage('High contrast mode toggled');
  }

  void _toggleLargeText() {
    _updateSettingValue('large_text', 'Accessibility');
    _showSuccessMessage('Large text toggled');
  }

  void _toggleScreenReader() {
    _updateSettingValue('screen_reader', 'Accessibility');
    _showSuccessMessage('Screen reader support toggled');
  }

  void _showFAQ() {
    _showSuccessMessage('FAQ opened');
  }

  void _showContactSupport() {
    _showSuccessMessage('Contact support opened');
  }

  void _checkForUpdates() {
    _showSuccessMessage('App is up to date');
  }

  void _showRateApp() {
    _showSuccessMessage('Rate app dialog opened');
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently removed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessMessage('Account deletion process started');
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _updateSettingValue(String key, String sectionTitle) {
    setState(() {
      final sectionIndex = settingsSections
          .indexWhere((section) => section['title'] == sectionTitle);
      if (sectionIndex != -1) {
        final items = settingsSections[sectionIndex]['items']
            as List<Map<String, dynamic>>;
        final itemIndex = items.indexWhere((item) => item['key'] == key);
        if (itemIndex != -1 && items[itemIndex]['type'] == 'switch') {
          items[itemIndex]['value'] = !(items[itemIndex]['value'] as bool);
        }
      }
    });
  }

  void _showSuccessMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Theme.of(context).colorScheme.primary,
      textColor: Theme.of(context).colorScheme.onPrimary,
    );
  }
}
