class ScreenInfo {
  int arcRadius = 0;

  ScreenInfo({this.arcRadius = 0});

  static ScreenInfo fromJson(dynamic json) {
    return ScreenInfo(arcRadius: json['arcRadius']);
  }

  @override
  String toString() {
    return 'ScreenInfo{arcRadius: $arcRadius}';
  }
}
