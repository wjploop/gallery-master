import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:gallery/util/logger.dart';
import 'package:my_plugin/my_plugin.dart';
import 'package:my_plugin/screen_info.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

class Device {
  static final _instane = Device._();

  factory Device() {
    return _instane;
  }

  late double width;
  late double height;
  late double devicePixelRatio;
  late double aspectRatio;

  late ScreenInfo screenInfo;

  late Directory appDir;
  late Directory pictureDir;
  late Directory? sdcard;

  bool initData = false;

  late PackageInfo packageInfo;

  void init(BuildContext context) async {
    if(initData) {
      return;
    }
    initData = true;
    var size = MediaQuery
        .of(context)
        .size;
    width = size.width;
    height = size.height;
    aspectRatio = size.aspectRatio;
    devicePixelRatio = MediaQuery
        .of(context)
        .devicePixelRatio;
    screenInfo = await MyPlugin.screenInfo;

    appDir = await getApplicationDocumentsDirectory();
    pictureDir = (await getExternalStorageDirectories(type: StorageDirectory.pictures))!.first;
    sdcard = await getExternalStorageDirectory();
    packageInfo = await PackageInfo.fromPlatform();
    logger.i("doc dir: $appDir");
    logger.i("picture dir: $pictureDir");
    logger.i("sdcard dir: $sdcard");
  }

  Device._() {}
}
