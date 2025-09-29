import 'package:flutter/material.dart';
import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vdiary_internship/presentation/shared/extensions/store_extension.dart';
import 'link_preview_video_widget.dart';
import 'link_preview_youtube_widget.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';

class LinkPreviewCardWidget extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;

  const LinkPreviewCardWidget({
    super.key,
    required this.url,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final double defaultWidth = MediaQuery.of(context).size.width * 0.9;
    final double defaultHeight = 210.0;

    Future<void> handleLaunchUrl(String url) async {
      final uri = Uri.parse(url);
      if (!await launchUrl(uri)) {
        throw Exception('Không thể mở URL: $url');
      }
    }

    final isYoutube = _isYoutubeUrl(url);
    final isVideo = _isVideoUrl(url);
    return Observer(
      builder: (_) {
        final postStore = context.postStore;
        return GestureDetector(
          onTap: () => handleLaunchUrl(url),
          child: Container(
            width: width ?? defaultWidth,
            height: postStore.isPreviewLink ? 100 : defaultHeight,
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: AppColor.superLightGrey,
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child:
                  isVideo
                      ? LinkPreviewVideoWidget(
                        videoUrl: url,
                        width: width ?? defaultWidth,
                        height: height ?? defaultHeight,
                      )
                      : isYoutube
                      ? (postStore.isPreviewLink
                          ? AnyLinkPreview(
                            link: url,
                            displayDirection: UIDirection.uiDirectionHorizontal,
                            showMultimedia: true,
                            bodyStyle: context.textTheme.bodySmall,
                            bodyTextOverflow: TextOverflow.ellipsis,
                            bodyMaxLines: 5,
                            backgroundColor: AppColor.superLightGrey,
                            errorWidget: _buildErrorWidget(),
                            placeholderWidget: _buildPlaceholderWidget(),
                          )
                          : LinkPreviewYoutubeWebView(
                            youtubeUrl: url,
                            width: width ?? defaultWidth,
                            height: height ?? defaultHeight,
                          ))
                      : AnyLinkPreview(
                        link: url,
                        urlLaunchMode: LaunchMode.inAppWebView,
                        displayDirection: UIDirection.uiDirectionHorizontal,
                        showMultimedia: true,
                        bodyStyle: context.textTheme.bodySmall,
                        bodyTextOverflow: TextOverflow.ellipsis,
                        bodyMaxLines: 5,
                        backgroundColor: AppColor.superLightGrey,
                        errorWidget: _buildErrorWidget(),
                        placeholderWidget: _buildPlaceholderWidget(),
                      ),
            ),
          ),
        );
      },
    );
  }

  bool _isYoutubeUrl(String url) {
    final lowerUrl = url.toLowerCase();
    return lowerUrl.contains('youtube.com/watch') ||
        lowerUrl.contains('youtu.be/');
  }

  bool _isVideoUrl(String url) {
    final videoExtensions = [
      '.mp4',
      '.webm',
      '.mov',
      '.avi',
      '.m3u8',
      '.mpd',
      '.mkv',
      '.flv',
      '.wmv',
      '.3gp',
    ];
    final lowerUrl = url.toLowerCase();
    return videoExtensions.any((ext) => lowerUrl.contains(ext));
  }

  Widget _buildErrorWidget() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: const Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red),
          SizedBox(width: 8.0),
          Expanded(
            child: Text(
              'Không thể tải bản xem trước cho đường link này.',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderWidget() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}
