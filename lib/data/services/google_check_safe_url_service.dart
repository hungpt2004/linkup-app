import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:package_info_plus/package_info_plus.dart';
import '../models/google-check-response/threat_match_model.dart';

/// Kết quả trả về từ API
class SafeBrowsingResult {
  final bool isSafe;
  final List<ThreatMatch> matches;

  SafeBrowsingResult({required this.isSafe, required this.matches});

  factory SafeBrowsingResult.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty || json['matches'] == null) {
      return SafeBrowsingResult(isSafe: true, matches: []);
    }

    final matches =
        (json['matches'] as List)
            .map((e) => ThreatMatch.fromJson(e as Map<String, dynamic>))
            .toList();

    return SafeBrowsingResult(isSafe: false, matches: matches);
  }
}

/// Service check URL với Google Safe Browsing
class SafeBrowsingService {
  final Dio _dio;
  final String _apiKey;

  SafeBrowsingService({required Dio dio, required String apiKey})
    : _dio = dio,
      _apiKey = apiKey;

  Future<SafeBrowsingResult> checkUrl(String url) async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();

      final requestBody = {
        "client": {
          "clientId": "social_app_flutter",
          "clientVersion": packageInfo.version,
        },
        "threatInfo": {
          "threatTypes": [
            "MALWARE",
            "SOCIAL_ENGINEERING",
            "UNWANTED_SOFTWARE",
            "POTENTIALLY_HARMFUL_APPLICATION",
          ],
          "platformTypes": ["ANY_PLATFORM"],
          "threatEntryTypes": ["URL"],
          "threatEntries": [
            {"url": url},
          ],
        },
      };

      debugPrint('🌐 SafeBrowsing API Request URL: $url');
      debugPrint('📤 Request Body: $requestBody');

      final response = await _dio.post<Map<String, dynamic>>(
        "https://safebrowsing.googleapis.com/v4/threatMatches:find?key=$_apiKey",
        data: requestBody,
        options: Options(
          headers: {'Content-Type': 'application/json'},
          responseType: ResponseType.json,
        ),
      );

      debugPrint('📥 API Response: ${response.data}');
      debugPrint('📊 Status Code: ${response.statusCode}');

      return SafeBrowsingResult.fromJson(response.data ?? {});
    } on DioException catch (e) {
      // Log hoặc throw lỗi để UI xử lý
      throw Exception("Safe Browsing API error: ${e.message}");
    }
  }
}
