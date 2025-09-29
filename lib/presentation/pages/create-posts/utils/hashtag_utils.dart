import 'package:vdiary_internship/core/constants/validation/validation_string.dart';

List<String> extractHashtagsFromText(String text) {
  final RegExp hashtagRegex = checkHashtagRegExp;

  final matches = hashtagRegex.allMatches(text);

  return matches
      .map((match) => match.group(0)?.substring(1) ?? '')
      .where((hashtag) => hashtag.isNotEmpty)
      .toSet()
      .toList();
}
