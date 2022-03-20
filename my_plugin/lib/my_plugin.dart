import 'dart:async';

import 'package:flutter/services.dart';
import 'package:my_plugin/screen_info.dart';

class MyPlugin {
  static const MethodChannel _channel = MethodChannel('my_plugin');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<ScreenInfo> get screenInfo async {
    var json = await _channel.invokeMethod("screenInfo");
    return ScreenInfo.fromJson(json);
  }

  static Future<bool> insertPictureToSystemGallery(String path, String name) async {
    await _channel.invokeMethod("insertPictureToSystemGallery", {"path": path, "name": name, "desc": "壁纸"});
    return true;
  }

  static void openGallery() {
    _channel.invokeMethod("openGallery");
  }

  static Future<bool> setWallpaper(String path, int type) async {
    return await _channel.invokeMethod("setWallpaper", {
      "path": path,
      "type": type,
    });
  }

  static void share(String path) {
    _channel.invokeMethod("share",{
      "path": path
    });
  }
}
