// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageModel _$ImageModelFromJson(Map<String, dynamic> json) => ImageModel(
      id: json['id'] as int,
      tagId: json['tagId'] as int,
      tagName: json['tagName'] as String,
      categoryId: json['categoryId'] as int,
      categoryName: json['categoryName'] as String,
      originUrl: json['originUrl'] as String?,
      currentUrl: json['currentUrl'] as String?,
    );

Map<String, dynamic> _$ImageModelToJson(ImageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tagId': instance.tagId,
      'tagName': instance.tagName,
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
      'originUrl': instance.originUrl,
      'currentUrl': instance.currentUrl,
    };
