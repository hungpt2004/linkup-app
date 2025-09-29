import 'package:flutter/cupertino.dart';
import 'package:vdiary_internship/core/constants/message/message_debug.dart';
import 'package:vdiary_internship/presentation/pages/friends/store/user_store.dart';

class UserController {
  UserStore userStore = UserStore();

  UserController(this.userStore);

  Future<void> handleGetAllUser(BuildContext context) async {
    try {
      final success = await userStore.findAllSuggestion();
      if (success) {
        debugPrint(MessageDebug.fetchListSuccess);
      } else {
        debugPrint(MessageDebug.fetchListFail);
      }
    } catch (error) {
      rethrow;
    }
  }
}

