import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/timeline_context_menu.dart';
import './widgets/timeline_date_header.dart';
import './widgets/timeline_empty_state.dart';
import './widgets/timeline_entry_card.dart';
import './widgets/timeline_filter_sheet.dart';
import './widgets/timeline_search_bar.dart';

class JournalTimeline extends StatefulWidget {
  const JournalTimeline({super.key});

  @override
  State<JournalTimeline> createState() => _JournalTimelineState();
}

class _JournalTimelineState extends State<JournalTimeline> {
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';
  Map<String, dynamic> _activeFilters = {};
  bool _isLoading = false;
  bool _hasMoreData = true;
  List<Map<String, dynamic>> _allEntries = [];
  List<Map<String, dynamic>> _filteredEntries = [];

  // Mock data for journal entries
  final List<Map<String, dynamic>> _mockEntries = [
    {
      "id": 1,
      "date": "August 24, 2025",
      "time": "9:30 AM",
      "mood": "😊",
      "content":
          "Started my 100-day fitness challenge today! Feeling motivated and ready to transform my lifestyle. Did a 30-minute morning workout and meal prepped for the week. The hardest part is always getting started, but I'm committed to making this work.",
      "wordCount": 156,
      "isCompleted": true,
      "tags": ["breakthrough", "fitness", "motivation"],
      "photos": [
        "https://images.pexels.com/photos/416778/pexels-photo-416778.jpeg?auto=compress&cs=tinysrgb&w=800",
        "https://images.pexels.com/photos/1552242/pexels-photo-1552242.jpeg?auto=compress&cs=tinysrgb&w=800"
      ]
    },
    {
      "id": 2,
      "date": "August 23, 2025",
      "time": "7:45 PM",
      "mood": "🤔",
      "content":
          "Reflecting on my progress so far. Some days are harder than others, but I'm learning to be patient with myself. Today I struggled with staying consistent with my meditation practice, but I managed to complete my reading goal.",
      "wordCount": 89,
      "isCompleted": false,
      "tags": ["reflection", "struggle", "meditation"],
      "photos": []
    },
    {
      "id": 3,
      "date": "August 22, 2025",
      "time": "6:15 PM",
      "mood": "😍",
      "content":
          "Amazing breakthrough today! Finally mastered that difficult yoga pose I've been working on for weeks. It's incredible how persistence pays off. Feeling grateful for my body's strength and flexibility. This challenge is teaching me so much about patience and self-compassion.",
      "wordCount": 203,
      "isCompleted": true,
      "tags": ["breakthrough", "yoga", "gratitude", "milestone"],
      "photos": [
        "https://images.pexels.com/photos/317157/pexels-photo-317157.jpeg?auto=compress&cs=tinysrgb&w=800",
        "https://images.pexels.com/photos/1051838/pexels-photo-1051838.jpeg?auto=compress&cs=tinysrgb&w=800",
        "https://images.pexels.com/photos/3822622/pexels-photo-3822622.jpeg?auto=compress&cs=tinysrgb&w=800"
      ]
    },
    {
      "id": 4,
      "date": "August 21, 2025",
      "time": "8:20 AM",
      "mood": "😰",
      "content":
          "Woke up feeling overwhelmed today. The challenge seems harder than I expected. Had to remind myself that growth happens outside the comfort zone. Decided to take it one step at a time and focus on small wins.",
      "wordCount": 124,
      "isCompleted": false,
      "tags": ["struggle", "overwhelm", "growth"],
      "photos": []
    },
    {
      "id": 5,
      "date": "August 20, 2025",
      "time": "5:30 PM",
      "mood": "🤗",
      "content":
          "Celebrated a small victory today - completed my first week of the challenge! Treated myself to a healthy smoothie and called my best friend to share the good news. Having support makes such a difference in staying motivated.",
      "wordCount": 167,
      "isCompleted": true,
      "tags": ["celebration", "milestone", "support"],
      "photos": [
        "https://images.pexels.com/photos/1092730/pexels-photo-1092730.jpeg?auto=compress&cs=tinysrgb&w=800"
      ]
    },
    {
      "id": 6,
      "date": "August 19, 2025",
      "time": "10:15 AM",
      "mood": "😎",
      "content":
          "Feeling confident and strong today! Increased my workout intensity and tried a new healthy recipe. The mind-body connection is becoming clearer each day. I'm starting to see real changes in my energy levels and mood.",
      "wordCount": 142,
      "isCompleted": true,
      "tags": ["confidence", "workout", "energy"],
      "photos": [
        "https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&w=800",
        "https://images.pexels.com/photos/1640774/pexels-photo-1640774.jpeg?auto=compress&cs=tinysrgb&w=800"
      ]
    }
  ];

  @override
  void initState() {
    super.initState();
    _initializeData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeData() {
    setState(() {
      _allEntries = List.from(_mockEntries);
      _filteredEntries = List.from(_allEntries);
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreEntries();
    }
  }

  void _loadMoreEntries() {
    if (_isLoading || !_hasMoreData) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate loading more data
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
          // In a real app, you would load more data here
          _hasMoreData = false; // No more mock data to load
        });
      }
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _applyFilters();
    });
  }

  void _onFiltersChanged(Map<String, dynamic> filters) {
    setState(() {
      _activeFilters = filters;
      _applyFilters();
    });
  }

  void _applyFilters() {
    List<Map<String, dynamic>> filtered = List.from(_allEntries);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((entry) {
        final content = (entry['content'] as String? ?? '').toLowerCase();
        final tags = (entry['tags'] as List?)?.join(' ').toLowerCase() ?? '';
        final query = _searchQuery.toLowerCase();
        return content.contains(query) || tags.contains(query);
      }).toList();
    }

    // Apply date range filter
    if (_activeFilters.containsKey('dateRange')) {
      final dateRange = _activeFilters['dateRange'] as DateTimeRange;
      filtered = filtered.where((entry) {
        // In a real app, you would parse the actual date
        return true; // Simplified for mock data
      }).toList();
    }

    // Apply mood filter
    if (_activeFilters.containsKey('moods')) {
      final selectedMoods = _activeFilters['moods'] as List<String>;
      filtered = filtered.where((entry) {
        return selectedMoods.contains(entry['mood']);
      }).toList();
    }

    // Apply tags filter
    if (_activeFilters.containsKey('tags')) {
      final selectedTags = _activeFilters['tags'] as List<String>;
      filtered = filtered.where((entry) {
        final entryTags = (entry['tags'] as List?)?.cast<String>() ?? [];
        return selectedTags.any((tag) => entryTags.contains(tag));
      }).toList();
    }

    // Apply completion filter
    if (_activeFilters['completedOnly'] == true) {
      filtered =
          filtered.where((entry) => entry['isCompleted'] == true).toList();
    }

    // Apply photos filter
    if (_activeFilters['withPhotosOnly'] == true) {
      filtered = filtered.where((entry) {
        final photos = entry['photos'] as List?;
        return photos != null && photos.isNotEmpty;
      }).toList();
    }

    setState(() {
      _filteredEntries = filtered;
    });
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => TimelineFilterSheet(
          currentFilters: _activeFilters,
          onFiltersChanged: _onFiltersChanged,
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context, Map<String, dynamic> entry) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => TimelineContextMenu(
        entry: entry,
        onEdit: () => _editEntry(entry),
        onShare: () => _shareEntry(entry),
        onExport: () => _exportEntry(entry),
        onDelete: () => _deleteEntry(entry),
      ),
    );
  }

  void _editEntry(Map<String, dynamic> entry) {
    // Navigate to edit screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit entry functionality would open here')),
    );
  }

  void _shareEntry(Map<String, dynamic> entry) {
    // Share entry functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              'Sharing "${entry['content']?.toString().substring(0, 30)}..."')),
    );
  }

  void _exportEntry(Map<String, dynamic> entry) {
    // Export entry functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Exporting entry to PDF...')),
    );
  }

  void _deleteEntry(Map<String, dynamic> entry) {
    setState(() {
      _allEntries.removeWhere((e) => e['id'] == entry['id']);
      _applyFilters();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Entry deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _allEntries.add(entry);
              _applyFilters();
            });
          },
        ),
      ),
    );
  }

  void _createNewEntry() {
    Navigator.pushNamed(context, '/daily-check-in');
  }

  Map<String, List<Map<String, dynamic>>> _groupEntriesByDate() {
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (final entry in _filteredEntries) {
      final date = entry['date'] as String? ?? 'Unknown';
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(entry);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final groupedEntries = _groupEntriesByDate();
    final hasActiveFilters = _activeFilters.isNotEmpty;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text('Journal Timeline'),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Voice search functionality would be implemented here
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Voice search feature coming soon')),
              );
            },
            icon: CustomIconWidget(
              iconName: 'mic',
              color: colorScheme.primary,
              size: 24,
            ),
            tooltip: 'Voice search',
          ),
        ],
      ),
      body: Column(
        children: [
          TimelineSearchBar(
            initialQuery: _searchQuery,
            onSearchChanged: _onSearchChanged,
            onVoiceSearch: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Voice search activated')),
              );
            },
            onFilterTap: _showFilterSheet,
            hasActiveFilters: hasActiveFilters,
          ),
          Expanded(
            child: _filteredEntries.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
                    onRefresh: () async {
                      await Future.delayed(const Duration(seconds: 1));
                      _initializeData();
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.only(bottom: 10.h),
                      itemCount: _calculateItemCount(groupedEntries),
                      itemBuilder: (context, index) =>
                          _buildTimelineItem(context, groupedEntries, index),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createNewEntry,
        icon: CustomIconWidget(
          iconName: 'add',
          color: colorScheme.onPrimary,
          size: 24,
        ),
        label: Text('New Entry'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildEmptyState() {
    if (_searchQuery.isNotEmpty || _activeFilters.isNotEmpty) {
      return _searchQuery.isNotEmpty
          ? TimelineEmptyState.noSearchResults(query: _searchQuery)
          : TimelineEmptyState.noFilterResults();
    }

    return TimelineEmptyState.noEntries(
      onCreateEntry: _createNewEntry,
    );
  }

  int _calculateItemCount(
      Map<String, List<Map<String, dynamic>>> groupedEntries) {
    int count = 0;
    for (final entries in groupedEntries.values) {
      count += 1 + entries.length; // 1 for header + entries
    }
    if (_isLoading) count += 1; // Loading indicator
    return count;
  }

  Widget _buildTimelineItem(BuildContext context,
      Map<String, List<Map<String, dynamic>>> groupedEntries, int index) {
    int currentIndex = 0;

    for (final dateEntry in groupedEntries.entries) {
      final date = dateEntry.key;
      final entries = dateEntry.value;

      // Date header
      if (currentIndex == index) {
        final isToday =
            date.contains('August 24, 2025'); // Simplified check for demo
        return TimelineDateHeader(
          date: date,
          entryCount: entries.length,
          isToday: isToday,
        );
      }
      currentIndex++;

      // Entries for this date
      for (int i = 0; i < entries.length; i++) {
        if (currentIndex == index) {
          return TimelineEntryCard(
            entry: entries[i],
            onTap: () {
              // Navigate to full entry view
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Opening full entry view...')),
              );
            },
            onLongPress: () => _showContextMenu(context, entries[i]),
          );
        }
        currentIndex++;
      }
    }

    // Loading indicator
    if (_isLoading && index == currentIndex) {
      return Container(
        padding: EdgeInsets.all(4.w),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
