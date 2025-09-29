import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:lottie/lottie.dart';
import 'package:vdiary_internship/core/constants/gen/image_path.dart';
import 'package:vdiary_internship/data/models/user/user_model.dart';
import 'package:vdiary_internship/presentation/pages/friends/controller/friends_controller.dart';
import 'package:vdiary_internship/presentation/pages/friends/widgets/friend_section_widget.dart';
import 'package:vdiary_internship/presentation/shared/extensions/store_extension.dart';
import 'package:vdiary_internship/presentation/shared/widgets/skeletionizer_loading/friend_section_skeletionizer.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_responsive_size.dart';

class MyFriendScreen extends StatefulWidget {
  const MyFriendScreen({super.key});

  @override
  State<MyFriendScreen> createState() => _MyFriendScreenState();
}

class _MyFriendScreenState extends State<MyFriendScreen> {
  late final FriendController _friendController;
  List<UserModel> listUsers = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadDataUsers();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _friendController = FriendController(
      context.friendStore,
      context.userStore,
    );
  }

  Future<void> loadDataUsers() async {
    await _friendController.handleGetAllFriends(context);
  }

  Future<void> refreshLoad() async {
    await loadDataUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final friendStore = context.friendStore;
        if (friendStore.isLoading) {
          // Hiển thị skeleton loading thay cho LoadingPageLayout
          return Scaffold(
            backgroundColor: context.colorScheme.surface,
            body: Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                top: kToolbarHeight,
              ),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 1.5,
                  mainAxisExtent: ResponsiveSizeApp(context).heightPercent(370),
                ),
                padding: const EdgeInsets.symmetric(vertical: 2),
                itemCount: 6, // Số lượng skeleton card hiển thị
                itemBuilder:
                    (context, index) => const FriendSectionSkeletonizer(),
              ),
            ),
          );
        }
        return Scaffold(
          backgroundColor: context.colorScheme.surface,
          body: Observer(
            builder: (context) {
              if (friendStore.friends.isEmpty) {
                return _notiNoneData(context);
              }
              return Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: kToolbarHeight,
                ),
                child: RefreshIndicator(
                  onRefresh: refreshLoad,
                  child: _gridViewUser(friendStore.friends, context),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

Widget _gridViewUser(List<UserModel> userData, BuildContext context) {
  if (userData.isEmpty) {
    return Center(child: _notiNoneData(context));
  }
  return GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2, // Số lượng cột
      mainAxisSpacing: 2, // Khoảng cách dọc giữa các item
      crossAxisSpacing: 1.5, // Khoảng cách ngang giữa các item
      mainAxisExtent: ResponsiveSizeApp(context).heightPercent(370),
    ),
    padding: const EdgeInsets.symmetric(vertical: 2),
    itemCount: userData.length,
    itemBuilder: (context, index) {
      final userIndex = userData[index];
      return CardFriendDashboardWidget(user: userIndex);
    },
  );
}

Widget _notiNoneData(BuildContext context) {
  return Center(
    child: SizedBox(
      width: ResponsiveSizeApp(context).widthPercent(200),
      height: ResponsiveSizeApp(context).heightPercent(200),
      child: ClipRRect(child: Lottie.asset(ImagePath.lottieFriend)),
    ),
  );
}
