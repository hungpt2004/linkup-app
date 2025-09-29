import 'package:vdiary_internship/core/constants/validation/validation_string.dart';

bool checkIsUrl(String url) {
  try {
    final uri = Uri.parse(url);
    return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
  } catch (e) {
    return false;
  }
}

List<String> findAllUrls(String text) {
  final urlRegex = checkUrlRegExp;

  final matches = urlRegex.allMatches(text);

  return matches
      .map((match) => text.substring(match.start, match.end))
      .toList();
}
