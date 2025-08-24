import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/challenge_card_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/greeting_header_widget.dart';
import './widgets/quick_check_in_modal.dart';

class ChallengeDashboard extends StatefulWidget {
  const ChallengeDashboard({super.key});

  @override
  State<ChallengeDashboard> createState() => _ChallengeDashboardState();
}

class _ChallengeDashboardState extends State<ChallengeDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentBottomNavIndex = 0;
  bool _isRefreshing = false;
  List<Map<String, dynamic>> _challenges = [];

  // Mock user data
  final String _userName = "Alex Johnson";
  final int _currentStreak = 12;
  final int _longestStreak = 47;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadMockData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadMockData() {
    _challenges = [
      {
        'id': 1,
        'title': '100 Days of Coding',
        'category': 'Programming',
        'currentDay': 47,
        'totalDays': 100,
        'completionPercentage': 47.0,
        'isCheckedInToday': false,
        'color': 0xFF2E7D32,
        'startDate': DateTime.now().subtract(const Duration(days: 46)),
        'description': 'Code for at least 1 hour every day',
        'streak': 12,
      },
      {
        'id': 2,
        'title': '30-Day Fitness Challenge',
        'category': 'Health',
        'currentDay': 18,
        'totalDays': 30,
        'completionPercentage': 60.0,
        'isCheckedInToday': true,
        'color': 0xFFFF6F00,
        'startDate': DateTime.now().subtract(const Duration(days: 17)),
        'description': 'Daily workout routine for 30 minutes',
        'streak': 8,
      },
      {
        'id': 3,
        'title': 'Daily Reading Habit',
        'category': 'Education',
        'currentDay': 23,
        'totalDays': 60,
        'completionPercentage': 38.3,
        'isCheckedInToday': false,
        'color': 0xFF5E35B1,
        'startDate': DateTime.now().subtract(const Duration(days: 22)),
        'description': 'Read for 30 minutes every day',
        'streak': 5,
      },
      {
        'id': 4,
        'title': 'Meditation Journey',
        'category': 'Wellness',
        'currentDay': 35,
        'totalDays': 90,
        'completionPercentage': 38.9,
        'isCheckedInToday': true,
        'color': 0xFF388E3C,
        'startDate': DateTime.now().subtract(const Duration(days: 34)),
        'description': '10 minutes of daily meditation',
        'streak': 15,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(
        'ChallengeTracker Pro',
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      actions: [
        IconButton(
          icon: CustomIconWidget(
            iconName: 'notifications_outlined',
            color: Theme.of(context).colorScheme.onSurface,
            size: 24,
          ),
          onPressed: () => _showNotifications(),
        ),
        IconButton(
          icon: CustomIconWidget(
            iconName: 'account_circle_outlined',
            color: Theme.of(context).colorScheme.onSurface,
            size: 24,
          ),
          onPressed: () =>
              Navigator.pushNamed(context, '/settings-and-profile'),
        ),
        SizedBox(width: 2.w),
      ],
      bottom: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: 'Dashboard'),
          Tab(text: 'Analytics'),
          Tab(text: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildDashboardTab(),
        _buildAnalyticsTab(),
        _buildProfileTab(),
      ],
    );
  }

  Widget _buildDashboardTab() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: _challenges.isEmpty ? _buildEmptyState() : _buildChallengesList(),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        height: 70.h,
        child: EmptyStateWidget(
          onCreateChallenge: () =>
              Navigator.pushNamed(context, '/challenge-creation'),
        ),
      ),
    );
  }

  Widget _buildChallengesList() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          GreetingHeaderWidget(
            userName: _userName,
            currentStreak: _currentStreak,
            longestStreak: _longestStreak,
            currentDate: DateTime.now(),
          ),
          SizedBox(height: 1.h),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _challenges.length,
            itemBuilder: (context, index) {
              final challenge = _challenges[index];
              return Dismissible(
                key: Key('challenge_${challenge['id']}'),
                direction: DismissDirection.endToStart,
                background: _buildDismissBackground(),
                confirmDismiss: (direction) =>
                    _showQuickCheckInModal(challenge),
                child: ChallengeCardWidget(
                  challenge: challenge,
                  onCheckIn: () => _handleCheckIn(challenge),
                  onViewProgress: () => _navigateToProgress(challenge),
                  onEdit: () => _editChallenge(challenge),
                  onShare: () => _shareChallenge(challenge),
                  onArchive: () => _archiveChallenge(challenge),
                  onDelete: () => _deleteChallenge(challenge),
                ),
              );
            },
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 6.w),
      color: AppTheme.getSuccessColor(
          Theme.of(context).brightness == Brightness.light),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'check_circle',
            color: Colors.white,
            size: 32,
          ),
          SizedBox(height: 0.5.h),
          Text(
            'Quick Check-In',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'analytics',
            color: Theme.of(context).colorScheme.primary,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'Analytics Coming Soon',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Detailed progress analytics will be available here',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.7),
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/progress-analytics'),
            child: const Text('View Full Analytics'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 15.w,
            backgroundColor:
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            child: CustomIconWidget(
              iconName: 'person',
              color: Theme.of(context).colorScheme.primary,
              size: 48,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            _userName,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Challenge Enthusiast',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.7),
                ),
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/settings-and-profile'),
            child: const Text('View Full Profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () => Navigator.pushNamed(context, '/challenge-creation'),
      icon: CustomIconWidget(
        iconName: 'add',
        color: Theme.of(context).colorScheme.onPrimary,
        size: 24,
      ),
      label: Text(
        'New Challenge',
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentBottomNavIndex,
      onTap: _onBottomNavTap,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'dashboard_outlined',
            color: _currentBottomNavIndex == 0
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
            size: 24,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'dashboard',
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'check_circle_outline',
            color: _currentBottomNavIndex == 1
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
            size: 24,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'check_circle',
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
          label: 'Check-in',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'add_circle_outline',
            color: _currentBottomNavIndex == 2
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
            size: 24,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'add_circle',
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
          label: 'Create',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'analytics_outlined',
            color: _currentBottomNavIndex == 3
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
            size: 24,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'analytics',
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
          label: 'Analytics',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'person_outline',
            color: _currentBottomNavIndex == 4
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
            size: 24,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'person',
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
          label: 'Profile',
        ),
      ],
    );
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);

    // Simulate network refresh
    await Future.delayed(const Duration(seconds: 1));

    // Refresh challenge data
    _loadMockData();

    setState(() => _isRefreshing = false);

    // Show success feedback with haptic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'refresh',
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 2.w),
            const Text('Challenges updated'),
          ],
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onBottomNavTap(int index) {
    setState(() => _currentBottomNavIndex = index);

    switch (index) {
      case 0:
        // Already on dashboard
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
        Navigator.pushNamed(context, '/settings-and-profile');
        break;
    }
  }

  void _handleCheckIn(Map<String, dynamic> challenge) {
    _showQuickCheckInModal(challenge);
  }

  Future<bool?> _showQuickCheckInModal(Map<String, dynamic> challenge) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: QuickCheckInModal(
          challenge: challenge,
          onCheckIn: (checkInData) => _processCheckIn(challenge, checkInData),
        ),
      ),
    );
  }

  void _processCheckIn(
      Map<String, dynamic> challenge, Map<String, dynamic> checkInData) {
    setState(() {
      final index = _challenges.indexWhere((c) => c['id'] == challenge['id']);
      if (index != -1) {
        _challenges[index]['isCheckedInToday'] = true;
        _challenges[index]['currentDay'] =
            (_challenges[index]['currentDay'] as int) + 1;
        _challenges[index]['completionPercentage'] =
            ((_challenges[index]['currentDay'] as int) /
                    (_challenges[index]['totalDays'] as int)) *
                100;
      }
    });
  }

  void _navigateToProgress(Map<String, dynamic> challenge) {
    Navigator.pushNamed(context, '/progress-analytics');
  }

  void _editChallenge(Map<String, dynamic> challenge) {
    Navigator.pushNamed(context, '/challenge-creation');
  }

  void _shareChallenge(Map<String, dynamic> challenge) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing "${challenge['title']}" challenge...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _archiveChallenge(Map<String, dynamic> challenge) {
    setState(() {
      _challenges.removeWhere((c) => c['id'] == challenge['id']);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Challenge "${challenge['title']}" archived'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() => _challenges.add(challenge));
          },
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _deleteChallenge(Map<String, dynamic> challenge) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Challenge'),
        content: Text(
            'Are you sure you want to delete "${challenge['title']}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _challenges.removeWhere((c) => c['id'] == challenge['id']);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Challenge "${challenge['title']}" deleted'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text(
              'Delete',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'notifications',
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
            SizedBox(width: 2.w),
            const Text('Notifications'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'local_fire_department',
                color: AppTheme.getWarningColor(true),
                size: 24,
              ),
              title: const Text('Streak Alert'),
              subtitle:
                  const Text('Don\'t forget your daily coding challenge!'),
              trailing: Text(
                '2h ago',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                ),
              ),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'emoji_events',
                color: AppTheme.getSuccessColor(true),
                size: 24,
              ),
              title: const Text('Achievement Unlocked'),
              subtitle: const Text('You\'ve completed 7 days in a row!'),
              trailing: Text(
                '1d ago',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
