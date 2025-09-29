class VideoManager {
  static final VideoManager _instance = VideoManager._internal();
  factory VideoManager() => _instance;
  VideoManager._internal();

  String? _currentActiveVideoId;

  bool shouldPlayVideo(String videoId) {
    if (_currentActiveVideoId == null || _currentActiveVideoId == videoId) {
      _currentActiveVideoId = videoId;
      return true;
    }
    return false;
  }

  void pauseCurrentVideo() {
    _currentActiveVideoId = null;
  }

  void setActiveVideo(String videoId) {
    _currentActiveVideoId = videoId;
  }

  String? get currentActiveVideoId => _currentActiveVideoId;
}
