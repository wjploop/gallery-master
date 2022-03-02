import 'package:json_annotation/json_annotation.dart';
part 'image.g.dart';
/// id : 3
/// tagId : 28
/// tagName : "美腿"
/// categoryId : 5
/// categoryName : "美女"
/// originUrl : "http://img.netbian.com/file/2022/0118/small1924388gbMp1642505078.jpg"
/// currentUrl : null


@JsonSerializable()
class ImageModel {
  int id;
  int tagId;
  String tagName;
  int categoryId;
  String categoryName;
  String? originUrl;
  String? currentUrl;

  ImageModel({
      required this.id,
      required this.tagId,
      required this.tagName,
      required this.categoryId,
      required this.categoryName,
      this.originUrl, 
      this.currentUrl});

  factory ImageModel.fromJson(dynamic json) => _$ImageModelFromJson(json);

  Map<String, dynamic> toJson() => _$ImageModelToJson(this);

  @override
  String toString() {
    return 'Image{id: $id, tagId: $tagId, tagName: $tagName, categoryId: $categoryId, categoryName: $categoryName, originUrl: $originUrl, currentUrl: $currentUrl}';
  }
}