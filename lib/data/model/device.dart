import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:gallery/util/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:plugin/plugin.dart';
import 'package:plugin/screen_info.dart';

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

  void init(BuildContext context) async {
    var size = MediaQuery
        .of(context)
        .size;
    width = size.width;
    height = size.height;
    aspectRatio = size.aspectRatio;
    devicePixelRatio = MediaQuery
        .of(context)
        .devicePixelRatio;
    screenInfo = await Plugin.screenInfo;

    appDir = await getApplicationDocumentsDirectory();
    pictureDir = (await getExternalStorageDirectories(type: StorageDirectory.pictures))!.first;
    sdcard = await getExternalStorageDirectory();
    logger.i("doc dir: $appDir");
    logger.i("picture dir: $pictureDir");
    logger.i("sdcard dir: $sdcard");

  }

  Device._() {}
}
