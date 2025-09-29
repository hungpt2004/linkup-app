import 'package:flutter/material.dart';

class ShareActionModel {
  final String title;
  final String icon;
  final VoidCallback? function;

  const ShareActionModel({
    required this.title,
    required this.icon,
    this.function,
  });

  const ShareActionModel.withDefault({required this.title, required this.icon})
    : function = null;

  factory ShareActionModel.withDefaultFunction({
    required String title,
    required String icon,
    VoidCallback? function,
  }) {
    return ShareActionModel(
      title: title,
      icon: icon,
      function: function ?? () {},
    );
  }
}
