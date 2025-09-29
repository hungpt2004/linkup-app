import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:vdiary_internship/data/models/user/user_model.dart';
import 'package:vdiary_internship/presentation/pages/chat/widgets/chat-room/chat_user_section_widget.dart';
import 'package:vdiary_internship/presentation/shared/extensions/store_extension.dart';

class ChatGroupListWidget extends StatefulWidget {
  const ChatGroupListWidget({super.key});

  @override
  State<ChatGroupListWidget> createState() => _ChatGroupListWidgetState();
}

class _ChatGroupListWidgetState extends State<ChatGroupListWidget> {
  late Future<List<UserModel>> _futureData;

  @override
  void didChangeDependencies() {
    _futureData = fetchData();
    super.didChangeDependencies();
  }

  Future<List<UserModel>> fetchData() async {
    await context.friendStore.initializeFriends();
    // ignore: use_build_context_synchronously
    return context.friendStore.friends;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Observer(
        builder: (_) {
          final friendList = context.friendStore.friends;
          return FutureBuilder(
            future: _futureData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text("Lỗi: ${snapshot.error}"));
              }
              final data = snapshot.data ?? [];
              if (data.isEmpty) {
                return const Center(child: Text('Không có dữ liệu user chat'));
              }
              return ListView.builder(
                itemCount: friendList.length,
                itemBuilder: (context, index) {
                  final friendIndex = friendList[index];
                  return ChatUserSectionWidget(
                    index: index,
                    userIndex: friendIndex,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
