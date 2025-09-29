class ThreatMatch {
  final String threatType;
  final String platformType;
  final String threatEntryType;
  final String url;

  ThreatMatch({
    required this.threatType,
    required this.platformType,
    required this.threatEntryType,
    required this.url,
  });

  factory ThreatMatch.fromJson(Map<String, dynamic> json) {
    return ThreatMatch(
      threatType: json['threatType'] ?? '',
      platformType: json['platformType'] ?? '',
      threatEntryType: json['threatEntryType'] ?? '',
      url: json['threat']?['url'] ?? '',
    );
  }
}
