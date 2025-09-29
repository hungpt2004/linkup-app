import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';
import 'package:vdiary_internship/presentation/pages/posts/screens/post_videos_player_screen.dart';

class MultipleVideoLayout extends StatefulWidget {
  final List<String> videoPaths;
  final Function(int) onRemoveVideo;

  const MultipleVideoLayout({
    super.key,
    required this.videoPaths,
    required this.onRemoveVideo,
  });

  @override
  State<MultipleVideoLayout> createState() => _MultipleVideoLayoutState();
}

class _MultipleVideoLayoutState extends State<MultipleVideoLayout> {
  late List<VideoPlayerController?> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.videoPaths.length, (index) => null);
    _initializeControllers();
  }

  @override
  void didUpdateWidget(covariant MultipleVideoLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(widget.videoPaths, oldWidget.videoPaths)) {
      // Dispose old controllers
      for (var controller in _controllers) {
        controller?.dispose();
      }
      _controllers = List.generate(widget.videoPaths.length, (index) => null);
      _initializeControllers();
    }
  }

  void _initializeControllers() {
    for (int i = 0; i < widget.videoPaths.length; i++) {
      final controller = VideoPlayerController.file(File(widget.videoPaths[i]));
      _controllers[i] = controller;
      controller.initialize().then((_) {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.videoPaths.length,
      itemBuilder: (context, index) {
        // Robust index checks to prevent RangeError
        if (index < 0 ||
            index >= widget.videoPaths.length ||
            index >= _controllers.length) {
          return const SizedBox.shrink();
        }
        final controller = _controllers[index];
        final videoPath = widget.videoPaths[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Stack(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              FullScreenVideoPlayer(videoPath: videoPath),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child:
                        controller != null && controller.value.isInitialized
                            ? AspectRatio(
                              aspectRatio: controller.value.aspectRatio,
                              child: VideoPlayer(controller),
                            )
                            : Container(
                              height: 180,
                              color: Colors.black12,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(4),
                  child: InkWell(
                    onTap: () {
                      // Robust index check before removing
                      if (index >= 0 && index < widget.videoPaths.length) {
                        widget.onRemoveVideo(index);
                      }
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
