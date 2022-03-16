import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:gallery/data/api/client.dart';

class MyCacheManager extends CacheManager{

  static const key = "image_cache";

  static final _instance = MyCacheManager._();

  factory MyCacheManager(){
    return _instance;
  }

  MyCacheManager._():super(Config(key, ));

}