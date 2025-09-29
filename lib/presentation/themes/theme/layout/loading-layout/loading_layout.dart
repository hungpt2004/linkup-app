// Nhận một hàm load dữ liệu delay
// Nhận một child để render trong layout
import 'package:flutter/material.dart';
import '../../../../shared/widgets/loading/animation_loading.dart';

class LoadingPageLayout extends StatefulWidget {
  const LoadingPageLayout({
    super.key,
    required this.loadFuture,
    required this.child,
    this.isLoading = false,
  });

  // 1) Đổi signature cho rõ ràng, trả về Future<void>
  final Future<void> Function() loadFuture;
  final Widget child;
  final bool isLoading;

  @override
  State<LoadingPageLayout> createState() => _LoadingPageLayoutState();
}

class _LoadingPageLayoutState extends State<LoadingPageLayout> {
  bool _isMockDataLoading = true;

  @override
  void initState() {
    super.initState();       // luôn gọi super trước
    loadDataDelay();
  }

  // Hàm load dữ liệu từ widget được truyền vào
  Future<void> loadDataDelay() async {
    if (!mounted) return;    // 2) guard trước khi setState
    setState(() => _isMockDataLoading = true);

    await widget.loadFuture();

    if (!mounted) return;    // guard trước khi setState
    setState(() => _isMockDataLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final shouldShowLoading = _isMockDataLoading || widget.isLoading;

    return Stack(
      children: [
        widget.child,
        if (shouldShowLoading)
          Positioned.fill(
            child: Center(
              child: ColoredBox(
                color: Colors.black45,
                child: AnimationLoadingWidget(),
              ),
            ),
          ),
      ],
    );
  }
}