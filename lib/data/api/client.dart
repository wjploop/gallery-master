import 'package:dio/dio.dart';
import 'package:gallery/data/model/base_response.dart';
import 'package:gallery/data/model/category.dart';
import 'package:gallery/data/model/image.dart';
import 'package:gallery/data/model/page.dart';
import 'package:gallery/data/model/tag.dart';

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

  Future<BaseResponse<List<Category>>> categories() async {
    var res = await _dio.get("categories");
    return BaseResponse<List<Category>>.fromJson(res.data);
  }

  Future<BaseResponse<Page<Tag>>> tags() async {
   var res = await _dio.get("tags");
   return BaseResponse<Page<Tag>>.fromJson(res.data);
  }

  Future<BaseResponse<Page<ImageModel>>> images() async{
    var res = await _dio.get("images");
    return BaseResponse<Page<ImageModel>>.fromJson(res.data);
  }
}
