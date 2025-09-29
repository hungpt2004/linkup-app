import 'dart:io';
import 'package:flutter/material.dart';
import 'package:vdiary_internship/presentation/shared/widgets/layout/padding_layout.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_responsive_size.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

// RELATIVE IMPORT
import '../../screens/post_videos_player_screen.dart';
import '../../utils/video_manager.dart';
import 'package:video_player/video_player.dart';

class PostVideoLayout extends StatefulWidget {
  final List<String> videoUrls;

  const PostVideoLayout({super.key, required this.videoUrls});

  @override
  State<PostVideoLayout> createState() => _PostVideoLayoutState();
}

class _PostVideoLayoutState extends State<PostVideoLayout> {
  late List<VideoPlayerController?> _controllers;
  late List<bool> _isInitialized;
  bool _isVisible = false;
  String get postId =>
      widget.videoUrls.hashCode.toString(); // Unique ID cho mỗi video widget

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.videoUrls.length, (index) => null);
    _isInitialized = List.generate(widget.videoUrls.length, (index) => false);
    _initializeControllers();

    // Check visibility ngay sau khi init và mỗi 500ms
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkVideoVisibility();
      // Thêm timer để check visibility định kỳ
      Future.delayed(Duration(milliseconds: 500), () {
        if (mounted) _checkVideoVisibility();
      });
    });
  }

  void _initializeControllers() {
    for (int i = 0; i < widget.videoUrls.length; i++) {
      // Skip nếu đã initialize
      if (_isInitialized[i]) continue;

      VideoPlayerController controller;

      // Check if it's a URL or local file path
      if (widget.videoUrls[i].startsWith('http')) {
        // ignore: deprecated_member_use
        controller = VideoPlayerController.network(widget.videoUrls[i]);
      } else {
        controller = VideoPlayerController.file(File(widget.videoUrls[i]));
      }

      _controllers[i] = controller;
      controller.initialize().then((_) {
        if (mounted) {
          _isInitialized[i] = true; // Đánh dấu đã initialize
          controller.setLooping(true);
          // Kiểm tra visibility sau khi initialize xong
          _checkVideoVisibility();
          setState(() {});
        }
      });
    }
  }

  @override
  void didUpdateWidget(PostVideoLayout oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Chỉ initialize lại nếu video URLs thay đổi
    if (!_areVideoUrlsEqual(oldWidget.videoUrls, widget.videoUrls)) {
      // Dispose old controllers
      for (var controller in _controllers) {
        controller?.dispose();
      }

      // Reset state
      _controllers = List.generate(widget.videoUrls.length, (index) => null);
      _isInitialized = List.generate(widget.videoUrls.length, (index) => false);
      _initializeControllers();
    }
  }

  bool _areVideoUrlsEqual(List<String> oldUrls, List<String> newUrls) {
    if (oldUrls.length != newUrls.length) return false;
    for (int i = 0; i < oldUrls.length; i++) {
      if (oldUrls[i] != newUrls[i]) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.videoUrls.isEmpty) {
      return const SizedBox.shrink();
    }

    // Wrap với ScrollVisibilityDetector để detect khi video vào/ra viewport
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        // Tính toán visibility và control video play/pause
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _checkVideoVisibility();
        });
        return false;
      },
      child:
          widget.videoUrls.length == 1
              ? _buildSingleVideo(context, 0)
              : _buildMultipleVideos(context),
    );
  }

  void _checkVideoVisibility() {
    // Kiểm tra vị trí widget trong viewport
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null && renderBox.hasSize) {
      final position = renderBox.localToGlobal(Offset.zero);
      final size = renderBox.size;
      final screenHeight = MediaQuery.of(context).size.height;

      // Đơn giản: video visible khi >50% hiển thị trên màn hình
      double visibleHeight = 0;
      if (position.dy < screenHeight && position.dy + size.height > 0) {
        double topVisible = position.dy < 0 ? 0 : position.dy;
        double bottomVisible =
            position.dy + size.height > screenHeight
                ? screenHeight
                : position.dy + size.height;
        visibleHeight = bottomVisible - topVisible;
      }

      bool shouldPlay = (visibleHeight / size.height) > 0.5; // 50% visible

      // Sử dụng VideoManager để đảm bảo chỉ 1 video chạy
      final videoManager = VideoManager();

      if (shouldPlay && videoManager.shouldPlayVideo(postId)) {
        if (!_isVisible) {
          _isVisible = true;
          for (var controller in _controllers) {
            if (controller != null && controller.value.isInitialized) {
              controller.play();
            }
          }
          setState(() {});
        }
      } else if (_isVisible) {
        _isVisible = false;
        for (var controller in _controllers) {
          if (controller != null && controller.value.isInitialized) {
            controller.pause();
          }
        }
        if (videoManager.currentActiveVideoId == postId) {
          videoManager.pauseCurrentVideo();
        }
        setState(() {});
      }
    }
  }

  Widget _buildSingleVideo(BuildContext context, int index) {
    final controller = _controllers[index];

    return PaddingLayout.all(
      value: 0,
      child: Container(
        width: ResponsiveSizeApp(context).screenWidth,
        decoration: BoxDecoration(color: Colors.black),
        child: ClipRRect(
          child: GestureDetector(
            onTap: () {
              // Toggle play/pause khi tap vào video
              final controller = _controllers[index];
              if (controller != null && controller.value.isInitialized) {
                if (controller.value.isPlaying) {
                  controller.pause();
                } else {
                  controller.play();
                }
                setState(() {});
              }
            },
            onDoubleTap: () {
              // Double tap để mở fullscreen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => FullScreenVideoPlayer(
                        videoPath: widget.videoUrls[index],
                      ),
                ),
              );
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (controller != null && controller.value.isInitialized)
                  AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: VideoPlayer(controller),
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    height: ResponsiveSizeApp(context).heightPercent(300),
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
                // Play/Pause button overlay - chỉ hiện khi video pause
                if (controller != null &&
                    controller.value.isInitialized &&
                    !controller.value.isPlaying)
                  Positioned.fill(
                    child: Center(
                      child: Container(
                        width: ResponsiveSizeApp(context).widthPercent(80),
                        height: ResponsiveSizeApp(context).heightPercent(80),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          FluentIcons.play_32_filled,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMultipleVideos(BuildContext context) {
    return SizedBox(
      height: ResponsiveSizeApp(context).heightPercent(200),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.videoUrls.length,
        itemBuilder: (context, index) {
          final controller = _controllers[index];

          return Container(
            width: ResponsiveSizeApp(context).widthPercent(300),
            margin: EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: GestureDetector(
                onTap: () {
                  // Toggle play/pause khi tap vào video
                  final controller = _controllers[index];
                  if (controller != null && controller.value.isInitialized) {
                    if (controller.value.isPlaying) {
                      controller.pause();
                    } else {
                      controller.play();
                    }
                    setState(() {});
                  }
                },
                onDoubleTap: () {
                  // Double tap để mở fullscreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => FullScreenVideoPlayer(
                            videoPath: widget.videoUrls[index],
                          ),
                    ),
                  );
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (controller != null && controller.value.isInitialized)
                      AspectRatio(
                        aspectRatio: controller.value.aspectRatio,
                        child: VideoPlayer(controller),
                      )
                    else
                      SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      ),
                    // Play/Pause button overlay - chỉ hiện khi video pause
                    if (controller != null &&
                        controller.value.isInitialized &&
                        !controller.value.isPlaying)
                      Positioned.fill(
                        child: Center(
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              FluentIcons.play_32_filled,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
