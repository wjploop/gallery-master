import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gallery/data/model/resp_category.dart';
import 'package:gallery/data/model/resp_image.dart';
import 'package:gallery/data/model/resp_tag.dart';

class Client {
  static final Client _client = Client._internal();

  factory Client() {
    return _client;
  }

  late Dio _dio;

  var _domain = "http://150.158.92.41/image/";

  Client._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: _domain,
    ));
  }

  Future<RespCategory> categories() async {
    var resp = await _dio.get("categories");
    return RespCategory.fromJson(resp.data);
  }

  Future<RespTag> tags() async {
    var resp = await _dio.get("tags");
    return RespTag.fromJson(resp.data);
  }

  Future<RespImage> images(
      int categoryId, int page) async {
    var resp = await _dio.get("images",
        queryParameters: {"categoryId": categoryId, "page": page});
    return RespImage.fromJson(resp.data);

  }
}
