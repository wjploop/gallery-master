
import 'package:dio/dio.dart';
import 'package:gallery/data/model/base_response.dart';
import 'package:gallery/data/model/category.dart';
import 'package:gallery/data/model/image.dart';
import 'package:gallery/data/model/page.dart';
import 'package:gallery/data/model/tag.dart';
import 'package:retrofit/http.dart';

part 'api.g.dart';

@RestApi(baseUrl: "http://150.158.92.41/image")
abstract class Api {
  factory Api(Dio dio, {String baseUrl}) = _Api;

  @GET("/categories")
  Future<BaseResponse<List<Category>>> categories();

  @GET("/tags")
  Future<BaseResponse<Page<Tag>>> tags();

  @GET("/images")
  Future<BaseResponse<Page<ImageModel>>> images();
}