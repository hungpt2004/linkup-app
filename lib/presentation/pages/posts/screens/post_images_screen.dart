import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:vdiary_internship/presentation/pages/posts/widgets/post-images/image_view_interact_widget.dart';
import 'package:vdiary_internship/presentation/routes/app_navigator.dart';
import 'package:vdiary_internship/presentation/shared/extensions/store_extension.dart';
import 'package:vdiary_internship/presentation/shared/widgets/appbar/appbar_widget.dart';
import 'package:vdiary_internship/presentation/shared/widgets/layout/padding_layout.dart';

// RELATIVE IMPORT
import '../widgets/post-images/image_edit_section_widget.dart';
import '../controllers/post_controller.dart';

class EditImagePostScreen extends StatefulWidget {
  const EditImagePostScreen({super.key, required this.mode});

  final String mode;

  @override
  State<EditImagePostScreen> createState() => _EditImagePostScreenState();
}

class _EditImagePostScreenState extends State<EditImagePostScreen> {
  late final PostController _postController;

  @override
  void initState() {
    debugPrint('Mode image: ${widget.mode}');
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _postController = PostController(postStoreRef: context.postStore);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          widget.mode == 'edit'
              ? AppBar(
                automaticallyImplyLeading: false,
                title: CustomAppBarWidget(
                  title: 'Edit',
                  trailingText: 'Done',
                  currentPage: 'edit-image',
                  onTrailingPressed: () => AppNavigator.pop(context),
                  navigateContext: context,
                ),
              )
              : null,
      body: Observer(
        builder: (context) {
          final postImageArray = context.createPostStore.selectedImagePaths;
          int positionAddMoreButton =
              context.createPostStore.selectedImagePaths.length + 1;
          return widget.mode == 'edit'
              ? ListView.builder(
                itemCount: positionAddMoreButton,
                itemBuilder: (context, index) {
                  if (index == postImageArray.length) {
                    return PaddingLayout.symmetric(
                      vertical: 10,
                      horizontal: 16, // Thêm padding ngang cho nút
                      child: ElevatedButton.icon(
                        onPressed: () => {}, // Gọi hàm thêm ảnh
                        icon: const Icon(Icons.add_a_photo_outlined),
                        label: const Text('Add More Photos'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    );
                  }
                  return EditImageWidget(
                    () => context.createPostStore.removeImagePath(index),
                    () => _postController.openEditImageBottomSheet(
                      context,
                      index,
                    ),
                    imageUrl: postImageArray[index],
                  );
                },
              )
              : ImageViewerScreen(images: postImageArray, tag: 'view-1');
        },
      ),
    );
  }
}
