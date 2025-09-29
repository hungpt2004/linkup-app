import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vdiary_internship/core/constants/gen/image_path.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_responsive_size.dart';

// RELATIVE IMPORT
import '../../../../shared/widgets/images/image_widget.dart';

class ImageViewerScreen extends StatefulWidget {
  const ImageViewerScreen({super.key, required this.tag, required this.images});

  final List<String> images;
  final String tag;

  @override
  _ImageViewerScreenState createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<ImageViewerScreen>
    with TickerProviderStateMixin {
  Offset _position = Offset.zero;
  late AnimationController _controller;
  late Animation<Offset> _animation;
  late Animation<double> _opacityAnimation;
  late AnimationController _opacityController;

  bool isViewPostInformation = false;

  void setIsViewPostInformation() {
    setState(() {
      isViewPostInformation = !isViewPostInformation;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(_controller);

    // Khởi tạo animation controller cho opacity
    _opacityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.addListener(() {
      setState(() {
        _position = _animation.value;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_controller.isAnimating) return;
    setState(() {
      _position += details.delta;
      _opacityController.value = 1 - (_position.dy.abs() / 300).clamp(0.0, 1.0);
    });
  }

  void _onDragEnd(DragEndDetails details) {
    if (_controller.isAnimating) return;

    if (_position.dy.abs() > 150) {
      Navigator.of(context).pop();
    } else {
      _animation = Tween<Offset>(
        begin: _position,
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
      _controller.forward(from: 0);
      _opacityController.animateTo(1.0, curve: Curves.easeOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Giá trị độ mờ được tính toán trực tiếp
    double backgroundOpacity = 1 - (_position.dy.abs() / 300).clamp(0.0, 1.0);
    debugPrint("LENGTH LIST IMAGES: ${widget.images.length}");
    return AnimatedBuilder(
      animation: _opacityAnimation,
      builder:
          (context, child) => Scaffold(
            // Thay đổi màu nền của Scaffold
            backgroundColor: Colors.black.withValues(
              alpha: _opacityAnimation.value,
            ),
            appBar:
                isViewPostInformation
                    ? AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      automaticallyImplyLeading: false,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          GestureDetector(
                            child: SvgPicture.asset(
                              ImagePath.optionWhiteIcon,
                              width: 25,
                              height: 25,
                            ),
                          ),
                        ],
                      ),
                    )
                    : null,
            extendBodyBehindAppBar: true,
            body: GestureDetector(
              onTap: () => setIsViewPostInformation(),
              child: GestureDetector(
                onPanUpdate: _onDragUpdate,
                onPanEnd: _onDragEnd,
                child: Stack(
                  children: [
                    Center(
                      child: Transform.translate(
                        offset: _position,
                        child:
                            widget.images.length == 1
                                ? _buildImageSection(
                                  widget.images.first,
                                  widget.tag,
                                  context,
                                )
                                : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: widget.images.length,
                                  itemBuilder: (context, index) {
                                    final imageIndex = widget.images[index];
                                    return _buildImageSection(
                                      imageIndex,
                                      '${widget.tag}_$index',
                                      context,
                                    );
                                  },
                                ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      child: Opacity(
                        opacity: backgroundOpacity,
                        child: Container(
                          height: 100,
                          width: ResponsiveSizeApp(context).screenWidth,
                          decoration: BoxDecoration(
                            color: AppColor.backgroundColor.withValues(
                              alpha: 0.2,
                            ),
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
}

Widget _buildImageSection(
  String imageUrl,
  String heroTag,
  BuildContext context,
) {
  return Hero(
    tag: heroTag,
    child: MyImageWidget(
      imageUrl: imageUrl,
      imageWidth: ResponsiveSizeApp(context).screenWidth,
      imageHeight: ResponsiveSizeApp(context).heightPercent(300),
    ),
  );
}
