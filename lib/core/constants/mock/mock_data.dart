import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:lottie/lottie.dart';
import 'package:vdiary_internship/core/constants/gen/image_path.dart';
import 'package:vdiary_internship/data/models/story/story_model.dart';
import 'package:vdiary_internship/data/models/tab/tab.model.dart';
import 'package:vdiary_internship/data/models/user/user_model.dart';
import 'package:vdiary_internship/presentation/routes/app_navigator.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';

class MockData {
  // List User
  static final List<UserModel> users = [];

  // Type Button
  static final List<String> typeAction = [
    'All',
    'Suggestions',
    'Friend requests',
    'Followers',
    'Following',
  ];

  static List<TabModel> tabs({VoidCallback? onUnfriend}) => [
    TabModel(text: 'Quick share', icon: FluentIcons.document_add_16_regular),
    TabModel(
      text: 'Create new post',
      icon: FluentIcons.document_data_link_16_regular,
    ),
    TabModel(text: 'Share with friends', icon: FluentIcons.share_16_regular),
    TabModel(text: 'Share to page', icon: FluentIcons.page_fit_16_regular),
    TabModel(text: 'Share to group', icon: FluentIcons.group_20_regular),
    TabModel(text: 'Send via message', icon: FluentIcons.send_16_regular),
    TabModel(text: 'Switch to another app', icon: FluentIcons.apps_20_regular),
    TabModel(text: 'Copy link', icon: FluentIcons.copy_16_regular),
    TabModel(text: 'Add to folder', icon: FluentIcons.folder_add_16_regular),
    TabModel(text: 'Rename', icon: FluentIcons.rename_16_regular),
    TabModel(text: 'Pairing', icon: FluentIcons.heart_12_regular),
    TabModel(
      text: 'Unfriend',
      icon: FluentIcons.people_subtract_20_regular,
      onTap: onUnfriend,
    ),
  ];

  // Data for story model
  static final List<StoryModel> stories = [
    StoryModel(
      id: '1',
      user: UserModel(
        id: '1',
        name: 'Diễm Ngọc',
        avatarUrl: 'https://i.pravatar.cc/150?img=1',
      ),
      mediaUrl:
          'https://i.pinimg.com/736x/e5/72/c7/e572c7320c4719578c10855b8f846a50.jpg',
      mediaType: 'image',
      caption: 'Beautiful day! 🌅',
      createdAt: DateTime.now().subtract(Duration(hours: 2)),
      isViewed: false,
    ),
    StoryModel(
      id: '2',
      user: UserModel(
        id: '2',
        name: 'Thảo Vi',
        avatarUrl: 'https://i.pravatar.cc/150?img=2',
      ),
      mediaUrl:
          'https://i.pinimg.com/736x/c5/c7/a1/c5c7a1bf1287352cea00944a82b81944.jpg',
      mediaType: 'image',
      caption: 'Coffee time ☕',
      createdAt: DateTime.now().subtract(Duration(hours: 4)),
      isViewed: false,
    ),
    StoryModel(
      id: '3',
      user: UserModel(
        id: '3',
        name: 'Anh Quốc',
        avatarUrl: 'https://i.pravatar.cc/150?img=3',
      ),
      mediaUrl:
          'https://i.pinimg.com/736x/e1/9f/89/e19f89b408b30b6f2294367c84ebbb75.jpg',
      mediaType: 'image',
      caption: 'Working from home 💻',
      createdAt: DateTime.now().subtract(Duration(hours: 6)),
      isViewed: true,
    ),
    StoryModel(
      id: '4',
      user: UserModel(
        id: '4',
        name: 'Louis Nguyễn',
        avatarUrl: 'https://i.pravatar.cc/150?img=4',
      ),
      mediaUrl:
          'https://i.pinimg.com/736x/c8/96/1a/c8961a7e88a8f6d1e45226f27e4cfd3f.jpg',
      mediaType: 'image',
      caption: 'Great day! 🌟',
      createdAt: DateTime.now().subtract(Duration(hours: 8)),
      isViewed: false,
    ),
    StoryModel(
      id: '5',
      user: UserModel(
        id: '5',
        name: 'Lê Quang Bách',
        avatarUrl: 'https://i.pravatar.cc/150?img=5',
      ),
      mediaUrl:
          'https://i.pinimg.com/736x/a3/1d/1a/a31d1acdd7930cf3b159a09717054230.jpg',
      mediaType: 'image',
      caption: 'Amazing view! 🏔️',
      createdAt: DateTime.now().subtract(Duration(hours: 12)),
      isViewed: false,
    ),
  ];

  // ## AUDIENCE OPTION LIST
  static final List<Map<String, String>> audienceOptions = [
    {
      'icon': ImagePath.earthIcon,
      'title': 'Public',
      'subtitle': 'Anyone on or off Facebook',
      'value': 'Public',
    },

    {
      'icon': ImagePath.friendOptionIcon,
      'title': 'Friends',
      'subtitle': 'Your friends on Facebook',
      'value': 'Friends',
    },
    {
      'icon': ImagePath.lockBlackIcon,
      'title': 'Only me',
      'subtitle': 'Only you can see this post',
      'value': 'Private',
    },
  ];

  // ## POST OPTION LIST (metadata only)
  static final List<Map<String, dynamic>> postOptions = [
    {'icon': ImagePath.photoIcon, 'name': 'Photo/video', 'type': 'photo'},
    {'icon': ImagePath.tagIcon, 'name': 'Tag people', 'type': 'tag'},
    {
      'icon': ImagePath.reactionIcon,
      'name': 'Feeling/activity',
      'type': 'feeling',
    },
    {'icon': ImagePath.checkinIcon, 'name': 'Check in', 'type': 'checkin'},
    {'icon': ImagePath.liveVideoIcon, 'name': 'Live video', 'type': 'live'},
    {'icon': ImagePath.cameraIcon, 'name': 'Camera', 'type': 'camera'},
  ];

  // ## PROFILE OPTION LIST MAP (metadata only)
  static List<Map<String, dynamic>> editProfileOptions(BuildContext context) {
    return [
      {
        'optionTitle': 'Name',
        'optionFunction': () => AppNavigator.toEditNameScreen(context),
      },
      {'optionTitle': 'Username', 'optionFunction': () {}},
      {'optionTitle': 'Profile picture', 'optionFunction': () {}},
      {'optionTitle': 'Avatar', 'optionFunction': () {}},
    ];
  }

  // ## REACTION LIST
  static List<Reaction<String>> reactions = [
    Reaction<String>(
      value: 'like',
      icon: SizedBox(
        width: 20,
        height: 20,
        child: Lottie.asset(ImagePath.lottieLikeReaction),
      ),
      previewIcon: SizedBox(
        width: 20,
        height: 20,
        child: Lottie.asset(ImagePath.lottieLikeReaction),
      ),
      title: const Text('Like', style: TextStyle(color: AppColor.defaultColor)),
    ),
    Reaction<String>(
      value: 'care',
      icon: SizedBox(
        width: 20,
        height: 20,
        child: Lottie.asset(ImagePath.lottieSubLoveReaction),
      ),
      previewIcon: SizedBox(
        width: 20,
        height: 20,
        child: Lottie.asset(ImagePath.lottieSubLoveReaction),
      ),
      title: const Text('Care', style: TextStyle(color: AppColor.errorRed)),
    ),
    Reaction<String>(
      value: 'love',
      icon: SizedBox(
        width: 20,
        height: 20,
        child: Lottie.asset(ImagePath.lottieLoveReaction),
      ),
      previewIcon: SizedBox(
        width: 20,
        height: 20,
        child: Lottie.asset(ImagePath.lottieLoveReaction),
      ),
      title: const Text('Love', style: TextStyle(color: AppColor.errorRed)),
    ),
    Reaction<String>(
      value: 'haha',
      icon: SizedBox(
        width: 20,
        height: 20,
        child: Lottie.asset(ImagePath.lottieSmileReaction),
      ),
      previewIcon: SizedBox(
        width: 20,
        height: 20,
        child: Lottie.asset(ImagePath.lottieSmileReaction),
      ),
      title: const Text(
        'Haha',
        style: TextStyle(color: Color.fromARGB(255, 212, 193, 16)),
      ),
    ),
    Reaction<String>(
      value: 'wow',
      icon: SizedBox(
        width: 20,
        height: 20,
        child: Lottie.asset(ImagePath.lottieWowReaction),
      ),
      previewIcon: SizedBox(
        width: 20,
        height: 20,
        child: Lottie.asset(ImagePath.lottieWowReaction),
      ),
      title: const Text(
        'Wow',
        style: TextStyle(color: Color.fromARGB(255, 230, 212, 58)),
      ),
    ),
    Reaction<String>(
      value: 'sad',
      icon: SizedBox(
        width: 20,
        height: 20,
        child: Lottie.asset(ImagePath.lottieSadReaction),
      ),
      previewIcon: SizedBox(
        width: 20,
        height: 20,
        child: Lottie.asset(ImagePath.lottieSadReaction),
      ),
      title: const Text(
        'Sad',
        style: TextStyle(color: Color.fromARGB(255, 199, 182, 29)),
      ),
    ),
    Reaction<String>(
      value: 'angry',
      icon: SizedBox(
        width: 20,
        height: 20,
        child: Lottie.asset(ImagePath.lottieAngryReaction),
      ),
      previewIcon: SizedBox(
        width: 20,
        height: 20,
        child: Lottie.asset(ImagePath.lottieAngryReaction),
      ),
      title: const Text('Angry', style: TextStyle(color: Colors.deepOrange)),
    ),
  ];

  // Tab post
  static const List<Map<String, dynamic>> listPostReport = [
    {
      'icon': ImagePath.plusCircleIcon,
      'title': 'Interested',
      'subtitle': 'You will see more similar articles',
    },
    {
      'icon': ImagePath.minusCircleIcon,
      'title': 'Not interested ',
      'subtitle': 'You will see fewer similar posts',
    },
    {
      'icon': ImagePath.saveIcon,
      'title': 'Save post',
      'subtitle': 'Thêm vào danh sách các mục đã lưu',
    },
    {'icon': ImagePath.shareIcon, 'title': 'Share'},
    {'icon': ImagePath.tagReportIcon, 'title': 'Tag Image'},
    {'icon': ImagePath.closePostIcon, 'title': 'Remove appear'},
    {
      'icon': ImagePath.reportIcon,
      'title': 'Report this post',
      'subtitle': 'They won\'t know who report their\'s post',
    },
    {
      'icon': ImagePath.notificationPostIcon,
      'title': 'Turn on notification of this post',
    },
    {'icon': ImagePath.copyIcon, 'title': 'Copy link ref'},
  ];

  // Options story

  // Options chat
  static const List<Map<String, dynamic>> listOptionsChat = [
    {'value': 'chat_group', 'icon': ImagePath.groupIcon, 'title': 'Chat Group'},
    {'value': 'chat_box', 'icon': ImagePath.chatIcon, 'title': 'Chat BoAI'},
    {
      'value': 'chat_support',
      'icon': ImagePath.supportIcon,
      'title': 'Chat Support',
    },
  ];
}
