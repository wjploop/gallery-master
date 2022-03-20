class ScreenInfo {
  int connerRadius = 0;

  ScreenInfo({this.connerRadius = 0});

  static ScreenInfo fromJson(dynamic json) {
    return ScreenInfo(connerRadius: json['connerRadius']);
  }

  @override
  String toString() {
    return 'ScreenInfo{arcRadius: $connerRadius}';
  }
}
