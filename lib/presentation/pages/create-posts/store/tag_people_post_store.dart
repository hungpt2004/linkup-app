import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:vdiary_internship/data/models/user/user_model.dart';
import 'package:vdiary_internship/presentation/shared/extensions/store_extension.dart';

part 'tag_people_post_store.g.dart';

// ignore: library_private_types_in_public_api
class TagUserStore = _TagUserStore with _$TagUserStore;

abstract class _TagUserStore with Store {
  @observable
  ObservableList<Map<String, dynamic>> users = ObservableList();

  @observable
  ObservableList<UserModel> searchUsers = ObservableList();

  @observable
  ObservableSet<String> selectedUserIds = ObservableSet<String>();

  @observable
  ObservableList<UserModel> selectedUserInfor = ObservableList<UserModel>();

  @action
  void clearSelectedUserInfor() {
    selectedUserIds.clear();
    selectedUserInfor.clear();
  }

  // Hàm xử lý chọn user
  @action
  void toggleChooseUser(String userId, bool checkChoose, BuildContext context) {
    var friendLists = context.friendStore.friends;
    if (checkChoose) {
      // Chọn user - thêm vào danh sách
      selectedUserIds.add(userId);
      final user = friendLists.firstWhere(
        (u) => u.id == userId,
        orElse: () => UserModel(),
      );
      if (user.id != null && user.id == userId) {
        selectedUserInfor.add(user);
      }
      debugPrint('Friends: ${friendLists.length}');
      debugPrint('Chọn user: ${selectedUserIds.length}');
      debugPrint('Chọn user infor:  ${selectedUserInfor.length}');
    } else {
      // Bỏ chọn user - xóa khỏi danh sách
      selectedUserIds.remove(userId);
      selectedUserInfor.removeWhere((user) => user.id == userId);
      debugPrint('Bỏ chọn user: ${selectedUserIds.length}');
    }
  }

  // Hàm gợi ý search
  @action
  void searchUser(String searchText, BuildContext context) {
    var friendLists = context.friendStore.friends;
    searchUsers.clear();
    if (searchText.isNotEmpty) {
      for (var friend in friendLists) {
        if (friend.name != null &&
            friend.name!.toLowerCase().contains(searchText.toLowerCase())) {
          searchUsers.add(friend);
        }
      }
    }
  }

  bool isSelected(String userId) => selectedUserIds.contains(userId);
}
