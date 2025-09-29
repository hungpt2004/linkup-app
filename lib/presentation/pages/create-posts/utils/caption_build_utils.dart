import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vdiary_internship/core/constants/validation/validation_string.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import 'package:vdiary_internship/presentation/pages/posts/controllers/post_controller.dart';
import 'package:vdiary_internship/presentation/shared/extensions/store_extension.dart';

Widget buildCaption(
  String caption,
  BuildContext context,
  VoidCallback lauchFunction,
) {
  final hashtagReg = checkHashtagRegExp;
  final urlReg = checkUrlRegExp;
  final matches = <RegExpMatch>[];
  matches.addAll(hashtagReg.allMatches(caption));
  matches.addAll(urlReg.allMatches(caption));
  matches.sort((a, b) => a.start.compareTo(b.start));

  List<TextSpan> spans = [];
  int last = 0;
  for (final match in matches) {
    if (match.start > last) {
      spans.add(
        TextSpan(
          text: caption.substring(last, match.start),
          style: context.textTheme.bodyMedium,
        ),
      );
    }
    final matchedText = caption.substring(match.start, match.end);
    final isUrl = urlReg.hasMatch(matchedText);
    spans.add(
      TextSpan(
        text: matchedText,
        style: context.textTheme.bodyMedium?.copyWith(
          color: AppColor.lightBlue,
          fontWeight: FontWeight.w500,
        ),
        recognizer:
            isUrl
                ? (TapGestureRecognizer()
                  ..onTap = () async {
                    final postController = PostController(
                      postStoreRef: context.postStore,
                    );
                    await postController.handleUrlTap(context, matchedText);
                  })
                : null,
      ),
    );
    last = match.end;
  }
  if (last < caption.length) {
    spans.add(
      TextSpan(
        text: caption.substring(last),
        style: context.textTheme.bodyMedium,
      ),
    );
  }

  return RichText(text: TextSpan(children: spans));
}
