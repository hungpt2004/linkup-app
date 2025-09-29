import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:vdiary_internship/core/constants/secret_key.dart';
import 'package:vdiary_internship/data/models/post/hive/hashtag_model_hive.dart';
import 'package:vdiary_internship/data/models/post/hive/like_model_hive.dart';
import 'package:vdiary_internship/data/models/post/hive/link_model_hive.dart';
import 'package:vdiary_internship/data/models/post/hive/mention_model_hive.dart';
import 'package:vdiary_internship/data/models/post/hive/post_model_hive.dart';
import 'package:vdiary_internship/data/models/user/hive/user_model_hive.dart';
import 'package:vdiary_internship/data/services/local_notification_service.dart';
import 'package:vdiary_internship/data/services/shared_preferences_service.dart';
import 'package:vdiary_internship/firebase_options.dart';
import 'package:vdiary_internship/presentation/routes/app_router.dart';
import 'package:vdiary_internship/presentation/shared/store/store_factory.dart';
import 'package:vdiary_internship/presentation/shared/store/supabase-provider/supabase_client_singleton.dart';
import 'package:vdiary_internship/presentation/shared/widgets/lifecycle_observer_widget.dart';
import 'package:vdiary_internship/presentation/shared/store/store_provider.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vdiary_internship/data/services/deep_link_service.dart'; // Add this import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await dotenv.load(fileName: ".env");

  // Initialize Deep Link Service
  await DeepLinkService().init();

  // Khởi tạo Local Notification
  await NotificationService().init();

  // Khởi tạo Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Khởi hive
  await Hive.initFlutter();
  Hive.registerAdapter(PostModelHiveAdapter());
  Hive.registerAdapter(UserModelHiveAdapter());
  Hive.registerAdapter(UserRoleHiveAdapter());
  Hive.registerAdapter(LikeModelHiveAdapter());
  Hive.registerAdapter(LinkModelHiveAdapter());
  Hive.registerAdapter(MentionModelHiveAdapter());
  Hive.registerAdapter(HashtagModelHiveAdapter());

  // Khởi tạo supabase - hosting image
  // Public bucket -> có nghĩa là được phép CRUD dựa trên policy đã đề ra
  await SupabaseSingleton.init(
    url: SecretKey().projectUrl,
    anonKey: SecretKey().anonKey,
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Đặt màu nền cho status bar
      statusBarIconBrightness:
          Brightness
              .dark, // Đặt màu biểu tượng trên status bar (để chúng hiển thị rõ trên nền trắng)
    ),
  );

  // khởi tạo shared preferences
  await SharedPreferencesService.init();

  await StoreFactory.initializeAll();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      userStore: StoreFactory.userStore,
      authStore: StoreFactory.authStore,
      dashboardController: StoreFactory.dashboardController,
      friendStore: StoreFactory.friendStore,
      tagUserStore: StoreFactory.tagUserStore,
      audienceStore: StoreFactory.audienceStore,
      createPostStore: StoreFactory.createPostStore,
      postStore: StoreFactory.postStore,
      profilePostStore: StoreFactory.profilePostStore,
      chatStore: StoreFactory.chatStore,
      appLifecycleStore: StoreFactory.appLifeCycleStore,
      deepLinkStore: StoreFactory.deepLinkStore,
      notificationStore: StoreFactory.notificationStore,
      networkStatusStore: StoreFactory.networkStatusStore,
      child: LifecycleObserverWidget(
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'VDiaryBookModuleFriend',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          routerConfig: AppRouter.router,
        ),
      ),
    );
  }
}
