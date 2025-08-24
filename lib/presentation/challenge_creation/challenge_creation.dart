import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/advanced_options_section.dart';
import './widgets/challenge_form_section.dart';
import './widgets/challenge_template_card.dart';
import './widgets/color_theme_selector.dart';
import './widgets/goal_setting_section.dart';
import './widgets/photo_upload_section.dart';
import './widgets/reminder_configuration_section.dart';

class ChallengeCreation extends StatefulWidget {
  const ChallengeCreation({super.key});

  @override
  State<ChallengeCreation> createState() => _ChallengeCreationState();
}

class _ChallengeCreationState extends State<ChallengeCreation>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;

  // Form Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Form State
  int _currentStep = 0;
  Map<String, dynamic>? _selectedTemplate;
  int _selectedDuration = 30;
  String _durationType = 'days';
  DateTime _selectedStartDate = DateTime.now();
  String _goalType = 'Daily';
  int _numericGoal = 1;
  String _goalUnit = 'minutes';
  TimeOfDay _reminderTime = const TimeOfDay(hour: 9, minute: 0);
  String _reminderFrequency = 'Daily';
  List<String> _selectedDays = [];
  String _selectedTheme = 'Forest';
  bool _isAdvancedExpanded = false;
  String _privacySetting = 'Private';
  bool _enableNotifications = true;
  bool _enableStreakProtection = true;
  bool _enableSocialSharing = false;
  XFile? _selectedImage;
  bool _isFormValid = false;

  // Mock Data
  final List<Map<String, dynamic>> _challengeTemplates = [
    {
      "id": 1,
      "title": "100-Day Fitness Challenge",
      "description":
          "Transform your body and mind with daily workouts, nutrition tracking, and mindfulness practices.",
      "duration": 100,
      "participants": 2500,
      "difficulty": "Intermediate",
      "image":
          "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=300&fit=crop",
    },
    {
      "id": 2,
      "title": "Daily Writing Practice",
      "description":
          "Develop your writing skills with daily journaling, creative writing exercises, and reflection.",
      "duration": 30,
      "participants": 1200,
      "difficulty": "Beginner",
      "image":
          "https://images.unsplash.com/photo-1455390582262-044cdead277a?w=400&h=300&fit=crop",
    },
    {
      "id": 3,
      "title": "Meditation Journey",
      "description":
          "Find inner peace and clarity through daily meditation, breathing exercises, and mindfulness.",
      "duration": 21,
      "participants": 3200,
      "difficulty": "Beginner",
      "image":
          "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=300&fit=crop",
    },
    {
      "id": 4,
      "title": "Reading Marathon",
      "description":
          "Expand your knowledge and imagination by reading books across different genres and topics.",
      "duration": 365,
      "participants": 800,
      "difficulty": "Advanced",
      "image":
          "https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400&h=300&fit=crop",
    },
    {
      "id": 5,
      "title": "Custom Challenge",
      "description":
          "Create your own personalized challenge with custom goals, duration, and tracking methods.",
      "duration": 0,
      "participants": 0,
      "difficulty": "Custom",
      "image":
          "https://images.unsplash.com/photo-1484480974693-6ca0a78fb36b?w=400&h=300&fit=crop",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _pageController = PageController();
    _titleController.addListener(_validateForm);
    _descriptionController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _titleController.text.trim().isNotEmpty &&
          _descriptionController.text.trim().isNotEmpty &&
          (_selectedTemplate != null || _titleController.text.isNotEmpty);
    });
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _tabController.animateTo(_currentStep);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _tabController.animateTo(_currentStep);
    }
  }

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedStartDate) {
      setState(() => _selectedStartDate = picked);
    }
  }

  Future<void> _selectReminderTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );
    if (picked != null && picked != _reminderTime) {
      setState(() => _reminderTime = picked);
    }
  }

  void _showDurationPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildDurationPicker(),
    );
  }

  Widget _buildDurationPicker() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: colorScheme.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Select Duration',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text('Duration', style: theme.textTheme.bodySmall),
                      SizedBox(height: 1.h),
                      Container(
                        height: 20.h,
                        child: ListWheelScrollView.useDelegate(
                          itemExtent: 50,
                          onSelectedItemChanged: (index) {
                            setState(() => _selectedDuration = index + 1);
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                            builder: (context, index) {
                              final number = index + 1;
                              return Center(
                                child: Text(
                                  number.toString(),
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: number == _selectedDuration
                                        ? colorScheme.primary
                                        : colorScheme.onSurface
                                            .withValues(alpha: 0.6),
                                    fontWeight: number == _selectedDuration
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                ),
                              );
                            },
                            childCount: 365,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text('Type', style: theme.textTheme.bodySmall),
                      SizedBox(height: 1.h),
                      Container(
                        height: 20.h,
                        child: ListWheelScrollView(
                          itemExtent: 50,
                          onSelectedItemChanged: (index) {
                            final types = ['days', 'weeks', 'months'];
                            setState(() => _durationType = types[index]);
                          },
                          children: ['days', 'weeks', 'months'].map((type) {
                            final isSelected = type == _durationType;
                            return Center(
                              child: Text(
                                type,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: isSelected
                                      ? colorScheme.primary
                                      : colorScheme.onSurface
                                          .withValues(alpha: 0.6),
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Done'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createChallenge() async {
    if (!_isFormValid) return;

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Simulate challenge creation
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.pop(context); // Close loading dialog

      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'celebration',
                size: 24,
                color: Colors.green,
              ),
              SizedBox(width: 2.w),
              const Text('Challenge Created!'),
            ],
          ),
          content: Text(
            'Your challenge "${_titleController.text}" has been created successfully. Ready to start your journey?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/challenge-dashboard');
              },
              child: const Text('Go to Dashboard'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _saveDraft() async {
    // Show confirmation
    final bool? shouldSave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Draft'),
        content: const Text(
            'Save your progress as a draft? You can continue editing later.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (shouldSave == true) {
      // Simulate saving draft
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Draft saved successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<bool> _onWillPop() async {
    if (_titleController.text.isNotEmpty ||
        _descriptionController.text.isNotEmpty) {
      final bool? shouldExit = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Unsaved Changes'),
          content: const Text(
              'You have unsaved changes. Do you want to save as draft before leaving?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Discard'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context, false);
                await _saveDraft();
                if (mounted) Navigator.pop(context);
              },
              child: const Text('Save Draft'),
            ),
          ],
        ),
      );
      return shouldExit ?? false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          title: const Text('Create Challenge'),
          backgroundColor: colorScheme.surface,
          elevation: 0,
          leading: IconButton(
            icon: CustomIconWidget(
              iconName: 'arrow_back',
              size: 24,
              color: colorScheme.onSurface,
            ),
            onPressed: () async {
              if (await _onWillPop()) {
                Navigator.pop(context);
              }
            },
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(12.h),
            child: Column(
              children: [
                // Progress Indicator
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Row(
                    children: List.generate(4, (index) {
                      final isActive = index <= _currentStep;
                      final isCompleted = index < _currentStep;

                      return Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 1.w),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 0.5.h,
                                  decoration: BoxDecoration(
                                    color: isActive
                                        ? colorScheme.primary
                                        : colorScheme.outline
                                            .withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                              if (index < 3) SizedBox(width: 1.w),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                SizedBox(height: 2.h),

                // Step Indicator
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Step ${_currentStep + 1} of 4',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                      Text(
                        [
                          'Templates',
                          'Details',
                          'Settings',
                          'Review'
                        ][_currentStep],
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentStep = index);
            _tabController.animateTo(index);
          },
          children: [
            _buildTemplateSelection(),
            _buildChallengeDetails(),
            _buildChallengeSettings(),
            _buildReviewStep(),
          ],
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousStep,
                      child: const Text('Previous'),
                    ),
                  ),
                if (_currentStep > 0) SizedBox(width: 4.w),
                Expanded(
                  flex: _currentStep == 0 ? 1 : 1,
                  child: _currentStep == 3
                      ? ElevatedButton(
                          onPressed: _isFormValid ? _createChallenge : null,
                          child: const Text('Create Challenge'),
                        )
                      : ElevatedButton(
                          onPressed: _nextStep,
                          child: const Text('Next'),
                        ),
                ),
                SizedBox(width: 4.w),
                OutlinedButton(
                  onPressed: _saveDraft,
                  child: const Text('Save Draft'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTemplateSelection() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose a Template',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),

          Text(
            'Start with a proven template or create your own custom challenge',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 3.h),

          // Template Carousel
          SizedBox(
            height: 45.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _challengeTemplates.length,
              itemBuilder: (context, index) {
                final template = _challengeTemplates[index];
                final isSelected = _selectedTemplate?["id"] == template["id"];

                return ChallengeTemplateCard(
                  template: template,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      _selectedTemplate = template;
                      if (template["id"] != 5) {
                        // Not custom
                        _titleController.text = template["title"] as String;
                        _descriptionController.text =
                            template["description"] as String;
                        _selectedDuration = template["duration"] as int;
                      } else {
                        _titleController.clear();
                        _descriptionController.clear();
                        _selectedDuration = 30;
                      }
                    });
                    _validateForm();
                  },
                );
              },
            ),
          ),

          SizedBox(height: 3.h),

          // Template Info
          if (_selectedTemplate != null)
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'info',
                        size: 20,
                        color: colorScheme.primary,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Template Selected',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    _selectedTemplate!["id"] == 5
                        ? 'You can customize all aspects of your challenge in the next steps.'
                        : 'You can modify the template details in the next step to make it your own.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildChallengeDetails() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ChallengeFormSection(
            titleController: _titleController,
            descriptionController: _descriptionController,
            selectedDuration: _selectedDuration,
            durationType: _durationType,
            selectedStartDate: _selectedStartDate,
            onDurationTap: _showDurationPicker,
            onStartDateTap: _selectStartDate,
            onTitleChanged: (value) => _validateForm(),
            onDescriptionChanged: (value) => _validateForm(),
          ),
          SizedBox(height: 4.h),
          GoalSettingSection(
            goalType: _goalType,
            numericGoal: _numericGoal,
            goalUnit: _goalUnit,
            onGoalTypeChanged: (type) => setState(() => _goalType = type),
            onNumericGoalChanged: (goal) => setState(() => _numericGoal = goal),
            onGoalUnitChanged: (unit) => setState(() => _goalUnit = unit),
          ),
          SizedBox(height: 4.h),
          PhotoUploadSection(
            selectedImage: _selectedImage,
            onImageSelected: (image) => setState(() => _selectedImage = image),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeSettings() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReminderConfigurationSection(
            reminderTime: _reminderTime,
            reminderFrequency: _reminderFrequency,
            selectedDays: _selectedDays,
            onTimeSelect: _selectReminderTime,
            onFrequencyChanged: (frequency) {
              setState(() {
                _reminderFrequency = frequency;
                if (frequency == 'Weekdays') {
                  _selectedDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
                } else if (frequency == 'Daily') {
                  _selectedDays = [
                    'Mon',
                    'Tue',
                    'Wed',
                    'Thu',
                    'Fri',
                    'Sat',
                    'Sun'
                  ];
                }
              });
            },
            onDayToggle: (day) {
              setState(() {
                if (_selectedDays.contains(day)) {
                  _selectedDays.remove(day);
                } else {
                  _selectedDays.add(day);
                }
              });
            },
          ),
          SizedBox(height: 4.h),
          ColorThemeSelector(
            selectedTheme: _selectedTheme,
            onThemeChanged: (theme) => setState(() => _selectedTheme = theme),
          ),
          SizedBox(height: 4.h),
          AdvancedOptionsSection(
            isExpanded: _isAdvancedExpanded,
            privacySetting: _privacySetting,
            enableNotifications: _enableNotifications,
            enableStreakProtection: _enableStreakProtection,
            enableSocialSharing: _enableSocialSharing,
            onToggleExpanded: () =>
                setState(() => _isAdvancedExpanded = !_isAdvancedExpanded),
            onPrivacyChanged: (privacy) =>
                setState(() => _privacySetting = privacy),
            onNotificationsChanged: (enabled) =>
                setState(() => _enableNotifications = enabled),
            onStreakProtectionChanged: (enabled) =>
                setState(() => _enableStreakProtection = enabled),
            onSocialSharingChanged: (enabled) =>
                setState(() => _enableSocialSharing = enabled),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewStep() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Review Your Challenge',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),

          Text(
            'Review all details before creating your challenge',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 3.h),

          // Challenge Summary Card
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Challenge Image
                if (_selectedImage != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      height: 20.h,
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: 'image',
                          size: 48,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ),

                if (_selectedImage != null) SizedBox(height: 3.h),

                // Title and Description
                Text(
                  _titleController.text,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 1.h),

                Text(
                  _descriptionController.text,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                SizedBox(height: 3.h),

                // Challenge Details
                _buildReviewItem(
                    'Duration', '$_selectedDuration $_durationType'),
                _buildReviewItem('Start Date',
                    '${_selectedStartDate.month}/${_selectedStartDate.day}/${_selectedStartDate.year}'),
                _buildReviewItem('Goal', '$_numericGoal $_goalUnit $_goalType'),
                _buildReviewItem('Reminder',
                    '${_reminderTime.format(context)} - $_reminderFrequency'),
                _buildReviewItem('Theme', _selectedTheme),
                _buildReviewItem('Privacy', _privacySetting),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Success Preview
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorScheme.primary.withValues(alpha: 0.1),
                  colorScheme.secondary.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                CustomIconWidget(
                  iconName: 'emoji_events',
                  size: 48,
                  color: colorScheme.primary,
                ),
                SizedBox(height: 2.h),
                Text(
                  'Ready to Start Your Journey?',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Your challenge will begin on ${_selectedStartDate.month}/${_selectedStartDate.day}/${_selectedStartDate.year}. You\'ll receive daily reminders and track your progress every step of the way.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(String label, String value) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 25.w,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
