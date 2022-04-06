import 'package:dio/dio.dart';
import 'package:gallery/data/entity/resp_category.dart';
import 'package:gallery/data/entity/resp_image.dart';
import 'package:gallery/data/entity/resp_tag.dart';
import 'package:gallery/data/entity/resp_tags_by_image_id.dart';
import 'package:gallery/data/entity/resp_upgrade.dart';
import 'package:gallery/util/prety_log_for_dio.dart';

class Client {
  static final Client _client = Client._internal();

  factory Client() {
    return _client;
  }

  late Dio dio;
  late Dio shareDio;

  var _domain = "http://wjploop.xyz/";

  Client._internal() {
    shareDio = Dio();
    dio = Dio(BaseOptions(baseUrl: _domain, headers: {
      "Access-Control-Allow-Origin": "*",
    }));
    dio.interceptors.add(PrettyDioLogger());
  }

  Future<RespUpgrade> appVersion() async {
    var resp = await dio.get("app/version");
    return RespUpgrade.fromJson(resp.data);
  }

  Future<RespCategory> categories() async {
    var resp = await dio.get("image/categories");
    return RespCategory.fromJson(resp.data);
  }

  Future<RespTag> tags() async {
    var resp = await dio.get("image/tags");
    return RespTag.fromJson(resp.data);
  }

  Future<RespImage> images(int categoryId, int page) async {
    var resp = await dio.get("image/images", queryParameters: {"categoryId": categoryId, "page": page});
    return RespImage.fromJson(resp.data);
  }

  Future<RespImage> imagesByTagId(int tagId, int page, int size) async {
    var resp = await dio.get("image/images", queryParameters: {"tagId": tagId, "page": page, "size": size});
    return RespImage.fromJson(resp.data);
  }

  Future<RespImage> imageBySearch(String key, int page, int size) async {
    var resp = await dio.get("image/images", queryParameters: {"search": key, "page": page, "size": size});
    return RespImage.fromJson(resp.data);
  }

  Future<RespTagsByImageId> tagsByImageId(int imageId) async {
    var resp = await dio.get("image/tags_by_image_id", queryParameters: {"imageId": imageId});
    return RespTagsByImageId.fromJson(resp.data);
  }
}
