import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/celebration_animation_widget.dart';
import './widgets/custom_tag_input_widget.dart';
import './widgets/daily_rating_widget.dart';
import './widgets/mood_tracking_widget.dart';
import './widgets/photo_attachment_widget.dart';
import './widgets/rich_text_editor_widget.dart';

class DailyCheckIn extends StatefulWidget {
  const DailyCheckIn({super.key});

  @override
  State<DailyCheckIn> createState() => _DailyCheckInState();
}

class _DailyCheckInState extends State<DailyCheckIn>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final AudioRecorder _audioRecorder = AudioRecorder();

  // Form Data
  String _journalText = '';
  List<XFile> _attachedPhotos = [];
  int? _selectedMood;
  List<String> _selectedTags = [];
  double? _dailyRating;
  bool _challengeCompleted = false;

  // UI State
  bool _isLoading = false;
  bool _isDraft = false;
  bool _showCelebration = false;
  bool _isRecording = false;
  String? _recordingPath;

  // Mock Challenge Data
  final Map<String, dynamic> _currentChallenge = {
    "id": 1,
    "name": "30-Day Fitness Challenge",
    "currentDay": 15,
    "totalDays": 30,
    "description": "Complete 30 minutes of exercise daily",
    "streak": 14,
    "completedToday": false,
  };

  @override
  void initState() {
    super.initState();
    _loadDraftData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  void _loadDraftData() {
    // Simulate loading draft data
    setState(() {
      _isDraft = false;
    });
  }

  Future<void> _startVoiceRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        setState(() => _isRecording = true);

        await _audioRecorder.start(const RecordConfig(),
            path: 'voice_note.m4a');

        HapticFeedback.lightImpact();
      }
    } catch (e) {
      debugPrint('Recording error: $e');
      setState(() => _isRecording = false);
    }
  }

  Future<void> _stopVoiceRecording() async {
    try {
      final path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
        _recordingPath = path;
      });

      if (path != null) {
        // Simulate voice-to-text conversion
        await Future.delayed(const Duration(seconds: 2));
        setState(() {
          _journalText += _journalText.isEmpty
              ? "Today was a great day for my fitness challenge. I managed to complete my workout despite feeling tired initially."
              : " I also want to add that I'm feeling more energetic and motivated than yesterday.";
        });
      }
    } catch (e) {
      debugPrint('Stop recording error: $e');
      setState(() => _isRecording = false);
    }
  }

  void _handleVoiceToText() {
    if (_isRecording) {
      _stopVoiceRecording();
    } else {
      _startVoiceRecording();
    }
  }

  Future<void> _saveDraft() async {
    setState(() => _isLoading = true);

    // Simulate saving draft
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
      _isDraft = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Draft saved successfully'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Future<void> _completeCheckIn() async {
    if (_journalText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              const Text('Please add some journal content before completing'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _challengeCompleted = true;
      _showCelebration = true;
    });

    HapticFeedback.heavyImpact();
  }

  void _onCelebrationComplete() {
    setState(() => _showCelebration = false);
    Navigator.pushReplacementNamed(context, '/challenge-dashboard');
  }

  bool get _canComplete => _journalText.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _currentChallenge['name'],
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Day ${_currentChallenge['currentDay']} of ${_currentChallenge['totalDays']}',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
        actions: [
          // Challenge Completion Toggle
          Container(
            margin: EdgeInsets.only(right: 4.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Completed',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 2.w),
                Switch(
                  value: _challengeCompleted,
                  onChanged: (value) {
                    setState(() => _challengeCompleted = value);
                    HapticFeedback.selectionClick();
                  },
                  activeColor: AppTheme.lightTheme.colorScheme.primary,
                ),
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Main Content
          Column(
            children: [
              // Progress Indicator
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'local_fire_department',
                          color: Colors.orange,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          '${_currentChallenge['streak']} day streak',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.orange,
                          ),
                        ),
                        const Spacer(),
                        if (_isDraft)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Draft Saved',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    LinearProgressIndicator(
                      value: _currentChallenge['currentDay'] /
                          _currentChallenge['totalDays'],
                      backgroundColor: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),

              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    children: [
                      // Rich Text Editor
                      RichTextEditorWidget(
                        initialText: _journalText,
                        onTextChanged: (text) =>
                            setState(() => _journalText = text),
                        onVoiceToText: _handleVoiceToText,
                      ),

                      SizedBox(height: 3.h),

                      // Photo Attachment
                      PhotoAttachmentWidget(
                        attachedPhotos: _attachedPhotos,
                        onPhotosChanged: (photos) =>
                            setState(() => _attachedPhotos = photos),
                      ),

                      SizedBox(height: 3.h),

                      // Mood Tracking
                      MoodTrackingWidget(
                        selectedMood: _selectedMood,
                        onMoodSelected: (mood) =>
                            setState(() => _selectedMood = mood),
                      ),

                      SizedBox(height: 3.h),

                      // Custom Tags
                      CustomTagInputWidget(
                        selectedTags: _selectedTags,
                        onTagsChanged: (tags) =>
                            setState(() => _selectedTags = tags),
                      ),

                      SizedBox(height: 3.h),

                      // Daily Rating
                      DailyRatingWidget(
                        selectedRating: _dailyRating,
                        onRatingChanged: (rating) =>
                            setState(() => _dailyRating = rating),
                      ),

                      SizedBox(height: 10.h), // Space for bottom bar
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Voice Recording Indicator
          if (_isRecording)
            Positioned(
              top: 20.h,
              left: 4.w,
              right: 4.w,
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withValues(alpha: 0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 3.w,
                      height: 3.w,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Recording... Tap to stop',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: _handleVoiceToText,
                      child: CustomIconWidget(
                        iconName: 'stop',
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Bottom Action Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    // Save Draft Button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isLoading ? null : _saveDraft,
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          side: BorderSide(
                            color: AppTheme.lightTheme.colorScheme.outline,
                          ),
                        ),
                        child: _isLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppTheme.lightTheme.colorScheme.primary,
                                  ),
                                ),
                              )
                            : Text(
                                'Save Draft',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                      ),
                    ),

                    SizedBox(width: 4.w),

                    // Complete Check-in Button
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: _canComplete && !_isLoading
                            ? _completeCheckIn
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _canComplete
                              ? AppTheme.lightTheme.colorScheme.primary
                              : Colors.grey[400],
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          elevation: _canComplete ? 2 : 0,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomIconWidget(
                                    iconName: 'check_circle',
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    'Complete Check-in',
                                    style: AppTheme
                                        .lightTheme.textTheme.titleMedium
                                        ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Celebration Animation
          CelebrationAnimationWidget(
            isVisible: _showCelebration,
            achievementText:
                'Day ${_currentChallenge['currentDay']} completed! You\'re ${(_currentChallenge['currentDay'] / _currentChallenge['totalDays'] * 100).round()}% through your challenge.',
            onAnimationComplete: _onCelebrationComplete,
          ),
        ],
      ),
    );
  }
}
