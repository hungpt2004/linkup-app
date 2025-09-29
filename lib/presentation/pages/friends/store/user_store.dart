import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:vdiary_internship/data/models/user/user_model.dart';
import 'package:vdiary_internship/presentation/pages/friends/service/friend_service.dart';

part 'user_store.g.dart';

// ignore: library_private_types_in_public_api
class UserStore = _UserStore with _$UserStore;

abstract class _UserStore with Store {
  final FriendService _friendService = FriendService();

  @observable
  ObservableList<UserModel> suggestions = ObservableList<UserModel>();

  @observable
  bool isLoading = false;

  @observable
  String? successMessage;

  @observable
  String? errorMessage;

  @action
  void setSuccessMessage(String? value) => successMessage = value ?? '';

  @action
  void setErrorMessage(String? value) => errorMessage = value ?? '';

  @action
  void setLoading(bool value) => isLoading = value;

  @action
  Future<bool> findAllSuggestion() async {
    try {
      setLoading(true);
      final response = await _friendService.findAllUser();
      final users =
          (response['data'] as List<dynamic>)
              .map((json) => UserModel.fromJson(json))
              .toList();
      suggestions
        ..clear()
        ..addAll(users);
      setSuccessMessage('Get list users success');
      return true;
    } catch (error) {
      debugPrint(error.toString());
      setErrorMessage(error.toString());
      return false;
    } finally {
      await Future.delayed(
        Duration(milliseconds: 300),
        () => setLoading(false),
      );
    }
  }
}
