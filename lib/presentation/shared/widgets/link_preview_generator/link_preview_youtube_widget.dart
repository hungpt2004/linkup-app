import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_responsive_size.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:visibility_detector/visibility_detector.dart';

class LinkPreviewYoutubeWebView extends StatefulWidget {
  final String youtubeUrl;
  final double? width;
  final double? height;

  const LinkPreviewYoutubeWebView({
    super.key,
    required this.youtubeUrl,
    this.width,
    this.height,
  });

  @override
  State<LinkPreviewYoutubeWebView> createState() =>
      _LinkPreviewYoutubeWebViewState();
}

class _LinkPreviewYoutubeWebViewState extends State<LinkPreviewYoutubeWebView> {
  WebViewController? _controller;
  String? _videoId;
  bool _isWebViewLoaded = false;
  bool _isInitialized = false; // Flag để tránh load lại

  @override
  void initState() {
    super.initState();
    _videoId = _convertUrlToId(widget.youtubeUrl);
  }

  @override
  void didUpdateWidget(LinkPreviewYoutubeWebView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Nếu URL thay đổi, reset state
    if (oldWidget.youtubeUrl != widget.youtubeUrl) {
      _controller = null;
      _isWebViewLoaded = false;
      _isInitialized = false;
      _videoId = _convertUrlToId(widget.youtubeUrl);
    }
  }

  String? _convertUrlToId(String url) {
    final regExp = RegExp(r'(?:v=|youtu\.be/)([\w-]{11})');
    final match = regExp.firstMatch(url);
    return match?.group(1);
  }

  void _handleVisibility(double visibleFraction) {
    if (visibleFraction > 0.5 && _controller == null && !_isInitialized) {
      _isInitialized = true; // Đánh dấu đã bắt đầu initialize

      final String embedUrl =
          'https://www.youtube.com/embed/$_videoId?autoplay=1&mute=0&controls=0&enablejsapi=1';

      final controller =
          WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setBackgroundColor(const Color(0x00000000))
            ..addJavaScriptChannel(
              "Ready",
              onMessageReceived: (msg) {
                if (mounted) {
                  setState(() {
                    _isWebViewLoaded = true;
                  });
                }
              },
            )
            ..setNavigationDelegate(
              NavigationDelegate(
                onPageFinished: (url) {
                  // Inject script để check <video> trong DOM
                  _controller?.runJavaScript("""
                function checkReady() {
                  if (document.querySelector('video')) {
                    Ready.postMessage("ok");
                  } else {
                    setTimeout(checkReady, 200);
                  }
                }
                checkReady();
              """);
                },
              ),
            )
            ..loadRequest(Uri.parse(embedUrl));

      setState(() {
        _controller = controller;
      });
    } else if (visibleFraction <= 0.8 && _controller != null) {
      _controller?.runJavaScript('document.querySelector("video")?.pause();');
    } else {
      _controller?.runJavaScript('document.querySelector("video")?.play();');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_videoId == null || _videoId!.isEmpty) {
      return const Center(
        child: Text(
          'Không thể phát video Youtube: Link không hợp lệ.',
          style: TextStyle(color: Colors.red),
        ),
      );
    }

    return VisibilityDetector(
      key: Key('youtube_${_videoId ?? ''}'),
      onVisibilityChanged: (visibilityInfo) {
        _handleVisibility(visibilityInfo.visibleFraction);
      },
      child: SizedBox(
        width: widget.width,
        height:
            widget.height ?? ResponsiveSizeApp(context).screenWidth * 9 / 16,
        child: Stack(
          children: [
            // WebView
            if (_controller != null)
              AnimatedOpacity(
                opacity: _isWebViewLoaded ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 400),
                child: WebViewWidget(controller: _controller!),
              ),

            // Thumbnail + Skeleton che YouTube default loading
            if (!_isWebViewLoaded)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Thumbnail
                      Image.network(
                        'https://img.youtube.com/vi/$_videoId/hqdefault.jpg',
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return _skeletonLoadingContainer();
                        },
                        errorBuilder: (context, error, stack) {
                          return _skeletonLoadingContainer();
                        },
                      ),

                      // Custom overlay loading
                      Container(
                        color: Colors.black.withValues(
                          alpha: 0.4,
                        ), // che tối đi
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _skeletonLoadingContainer() {
    return Skeletonizer(
      enabled: true,
      child: Container(
        height: 200,
        width: ResponsiveSizeApp(context).screenWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[200], // màu nền xám nhạt
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
      ),
    );
  }
}
