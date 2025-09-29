import 'package:vdiary_internship/data/models/story/story_model.dart';
import 'package:vdiary_internship/data/models/user/user_model.dart';

class StoryMockData {
  static List<StoryModel> get stories => [
    StoryModel(
      id: '1',
      user: UserModel(
        id: '1',
        name: 'John Doe',
        avatarUrl: 'https://i.pravatar.cc/150?img=1',
      ),
      mediaUrl: 'https://picsum.photos/400/800?random=1',
      mediaType: 'image',
      caption: 'Beautiful sunset today! 🌅',
      createdAt: DateTime.now().subtract(Duration(hours: 2)),
      isViewed: false,
    ),
    StoryModel(
      id: '2',
      user: UserModel(
        id: '2',
        name: 'Jane Smith',
        avatarUrl: 'https://i.pravatar.cc/150?img=2',
      ),
      mediaUrl: 'https://picsum.photos/400/800?random=2',
      mediaType: 'image',
      caption: 'Coffee time ☕',
      createdAt: DateTime.now().subtract(Duration(hours: 4)),
      isViewed: false,
    ),
    StoryModel(
      id: '3',
      user: UserModel(
        id: '3',
        name: 'Mike Johnson',
        avatarUrl: 'https://i.pravatar.cc/150?img=3',
      ),
      mediaUrl: 'https://picsum.photos/400/800?random=3',
      mediaType: 'image',
      caption: 'Working from home today 💻',
      createdAt: DateTime.now().subtract(Duration(hours: 6)),
      isViewed: true,
    ),
    StoryModel(
      id: '4',
      user: UserModel(
        id: '4',
        name: 'Sarah Wilson',
        avatarUrl: 'https://i.pravatar.cc/150?img=4',
      ),
      mediaUrl: 'https://picsum.photos/400/800?random=4',
      mediaType: 'image',
      caption: 'Delicious lunch! 🍝',
      createdAt: DateTime.now().subtract(Duration(hours: 8)),
      isViewed: false,
    ),
    StoryModel(
      id: '5',
      user: UserModel(
        id: '5',
        name: 'David Brown',
        avatarUrl: 'https://i.pravatar.cc/150?img=5',
      ),
      mediaUrl: 'https://picsum.photos/400/800?random=5',
      mediaType: 'image',
      caption: 'Amazing workout session! 💪',
      createdAt: DateTime.now().subtract(Duration(hours: 12)),
      isViewed: false,
    ),
    StoryModel(
      id: '6',
      user: UserModel(
        id: '6',
        name: 'Lisa Davis',
        avatarUrl: 'https://i.pravatar.cc/150?img=6',
      ),
      mediaUrl: 'https://picsum.photos/400/800?random=6',
      mediaType: 'image',
      caption: 'Shopping day! 🛍️',
      createdAt: DateTime.now().subtract(Duration(hours: 18)),
      isViewed: true,
    ),
  ];

  static List<StoryModel> getStoriesByUser(String userId) {
    return stories.where((story) => story.user.id == userId).toList();
  }

  static List<String> get uniqueUserIds {
    return stories.map((story) => story.user.id!).toSet().toList();
  }

  static List<StoryModel> get groupedStories {
    final Map<String, List<StoryModel>> grouped = {};
    for (final story in stories) {
      final userId = story.user.id!;
      if (!grouped.containsKey(userId)) {
        grouped[userId] = [];
      }
      grouped[userId]!.add(story);
    }

    // Return first story of each user for story preview
    return grouped.values.map((userStories) => userStories.first).toList();
  }
}
