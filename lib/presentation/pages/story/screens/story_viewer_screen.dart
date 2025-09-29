import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vdiary_internship/core/constants/gen/image_path.dart';
import 'package:vdiary_internship/data/models/story/story_model.dart';
import 'package:vdiary_internship/presentation/shared/utils/format_time_ago.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';

class StoryViewerScreen extends StatefulWidget {
  final List<StoryModel> allStories; // Tất cả stories của tất cả user
  final int initialUserIndex; // Index của user được chọn
  final int initialStoryIndex; // Index của story trong user đó

  const StoryViewerScreen({
    super.key,
    required this.allStories,
    this.initialUserIndex = 0,
    this.initialStoryIndex = 0,
  });

  @override
  State<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends State<StoryViewerScreen>
    with TickerProviderStateMixin {
  late PageController _userPageController;
  late PageController _storyPageController;
  late AnimationController _progressController;
  Timer? _timer;

  int _currentUserIndex = 0;
  int _currentStoryIndex = 0;
  List<List<StoryModel>> _groupedStories = [];

  final Duration _storyDuration = const Duration(seconds: 5);

  @override
  void initState() {
    super.initState();
    _groupUsers();
    _currentUserIndex = widget.initialUserIndex;
    _currentStoryIndex = widget.initialStoryIndex;

    _userPageController = PageController(initialPage: _currentUserIndex);
    _storyPageController = PageController(initialPage: _currentStoryIndex);
    _progressController = AnimationController(
      duration: _storyDuration,
      vsync: this,
    );
    _startTimer();
  }

  void _groupUsers() {
    final Map<String, List<StoryModel>> grouped = {};
    for (final story in widget.allStories) {
      final userId = story.user.id!;
      if (!grouped.containsKey(userId)) {
        grouped[userId] = [];
      }
      grouped[userId]!.add(story);
    }
    _groupedStories = grouped.values.toList();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _progressController.dispose();
    _userPageController.dispose();
    _storyPageController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _progressController.reset();
    _progressController.forward();

    _timer = Timer(_storyDuration, () {
      _nextStory();
    });
  }

  void _nextStory() {
    final currentUserStories = _groupedStories[_currentUserIndex];

    if (_currentStoryIndex < currentUserStories.length - 1) {
      // Chuyển sang story tiếp theo trong cùng user
      setState(() {
        _currentStoryIndex++;
      });
      _storyPageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _startTimer();
    } else {
      // Chuyển sang user tiếp theo
      _nextUser();
    }
  }

  void _previousStory() {
    if (_currentStoryIndex > 0) {
      // Quay lại story trước trong cùng user
      setState(() {
        _currentStoryIndex--;
      });
      _storyPageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _startTimer();
    } else {
      // Quay lại user trước
      _previousUser();
    }
  }

  void _nextUser() {
    if (_currentUserIndex < _groupedStories.length - 1) {
      setState(() {
        _currentUserIndex++;
        _currentStoryIndex = 0;
      });
      _userPageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _storyPageController = PageController(initialPage: 0);
      _startTimer();
    } else {
      // Hết stories, tắt viewer
      _closeStoryViewer();
    }
  }

  void _previousUser() {
    if (_currentUserIndex > 0) {
      setState(() {
        _currentUserIndex--;
        _currentStoryIndex = _groupedStories[_currentUserIndex].length - 1;
      });
      _userPageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _storyPageController = PageController(initialPage: _currentStoryIndex);
      _startTimer();
    }
  }

  void _closeStoryViewer() {
    _timer?.cancel();
    Navigator.of(context).pop();
  }

  void _pauseStory() {
    _timer?.cancel();
    _progressController.stop();
  }

  void _resumeStory() {
    if (_progressController.status == AnimationStatus.forward) {
      return;
    }
    _progressController.forward();
    final remaining = _storyDuration * (1 - _progressController.value);
    _timer = Timer(remaining, () {
      _nextStory();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_groupedStories.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (details) {
          _pauseStory();
        },
        onTapUp: (details) {
          _resumeStory();
        },
        onTapCancel: () {
          _resumeStory();
        },
        child: PageView.builder(
          controller: _userPageController,
          itemCount: _groupedStories.length,
          onPageChanged: (userIndex) {
            setState(() {
              _currentUserIndex = userIndex;
              _currentStoryIndex = 0;
            });
            _storyPageController = PageController(initialPage: 0);
            _startTimer();
          },
          itemBuilder: (context, userIndex) {
            final userStories = _groupedStories[userIndex];
            return _buildUserStoriesView(userStories);
          },
        ),
      ),
    );
  }

  Widget _buildUserStoriesView(List<StoryModel> userStories) {
    return Stack(
      children: [
        // Story content
        PageView.builder(
          controller: _storyPageController,
          itemCount: userStories.length,
          onPageChanged: (storyIndex) {
            setState(() {
              _currentStoryIndex = storyIndex;
            });
            _startTimer();
          },
          itemBuilder: (context, storyIndex) {
            return _buildStoryContent(userStories[storyIndex]);
          },
        ),

        // Header với thông tin user và nút close
        _buildHeader(userStories.first),

        // Progress bars cho từng story của user hiện tại
        _buildProgressBars(userStories),

        // Tap areas để navigate
        _buildTapAreas(),

        // Close button
        Positioned(
          top: 60,
          right: 16,
          child: GestureDetector(
            onTap: _closeStoryViewer,
            child: Container(
              padding: EdgeInsets.all(8),
              child: SvgPicture.asset(
                ImagePath.closeBlackIcon,
                colorFilter: ColorFilter.mode(
                  AppColor.backgroundColor,
                  BlendMode.color,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTapAreas() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTapDown: (details) {
              final screenWidth = MediaQuery.of(context).size.width;
              final tapPosition = details.globalPosition.dx;

              if (tapPosition < screenWidth * 0.3) {
                _previousStory();
              } else if (tapPosition > screenWidth * 0.7) {
                _nextStory();
              }
            },
            child: Container(
              color: Colors.transparent,
              height: double.infinity,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStoryContent(StoryModel story) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child:
          story.mediaType == 'image'
              ? CachedNetworkImage(
                imageUrl: story.mediaUrl,
                fit: BoxFit.cover,
                placeholder:
                    (context, url) => Container(
                      color: Colors.grey[900],
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ),
                errorWidget:
                    (context, url, error) => Container(
                      color: Colors.grey[900],
                      child: const Center(
                        child: Icon(Icons.error, color: Colors.white, size: 50),
                      ),
                    ),
              )
              : Container(
                color: Colors.grey[900],
                child: const Center(
                  child: Icon(
                    Icons.play_circle_outline,
                    color: Colors.white,
                    size: 80,
                  ),
                ),
              ),
    );
  }

  Widget _buildHeader(StoryModel story) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, top: 16, right: 60),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage:
                  story.user.avatarUrl != null
                      ? CachedNetworkImageProvider(story.user.avatarUrl!)
                      : null,
              child:
                  story.user.avatarUrl == null
                      ? const Icon(Icons.person, color: Colors.white)
                      : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    story.user.name ?? 'Unknown',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    formatTimeAgo(story.createdAt),
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBars(List<StoryModel> userStories) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: List.generate(
            userStories.length,
            (index) => Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 1),
                height: 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1.5),
                  color: Colors.white30,
                ),
                child: AnimatedBuilder(
                  animation: _progressController,
                  builder: (context, child) {
                    double progress = 0.0;
                    if (index < _currentStoryIndex) {
                      progress = 1.0;
                    } else if (index == _currentStoryIndex) {
                      progress = _progressController.value;
                    }

                    return LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.transparent,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
