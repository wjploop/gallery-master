import 'package:dio/dio.dart';
import 'package:gallery/data/entity/resp_category.dart';
import 'package:gallery/data/entity/resp_image.dart';
import 'package:gallery/data/entity/resp_tag.dart';
import 'package:gallery/data/entity/resp_tags_by_image_id.dart';

class Client {
  static final Client _client = Client._internal();

  factory Client() {
    return _client;
  }

  late Dio dio;

  var _domain = "http://wjploop.xyz/image/";

  Client._internal() {
    dio = Dio(BaseOptions(
      baseUrl: _domain,
      headers: {
        "Access-Control-Allow-Origin": "*",
      }
    ));
  }

  Future<RespCategory> categories() async {
    var resp = await dio.get("categories");
    return RespCategory.fromJson(resp.data);
  }

  Future<RespTag> tags() async {
    var resp = await dio.get("tags");
    return RespTag.fromJson(resp.data);
  }

  Future<RespImage> images(int categoryId, int page) async {
    var resp = await dio.get("images",
        queryParameters: {"categoryId": categoryId, "page": page});
    return RespImage.fromJson(resp.data);
  }

  Future<RespImage> imagesByTagId(int tagId, int page, int size) async {
    var resp = await dio.get("images",
        queryParameters: {"tagId": tagId, "page": page, "size": size});
    return RespImage.fromJson(resp.data);
  }

  Future<RespTagsByImageId> tagsByImageId(int imageId) async {
    var resp = await dio
        .get("tags_by_image_id", queryParameters: {"imageId": imageId});
    return RespTagsByImageId.fromJson(resp.data);
  }
}
