// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Image _$ImageFromJson(Map<String, dynamic> json) => Image(
      id: json['id'] as int,
      tagId: json['tagId'] as int,
      tagName: json['tagName'] as String,
      categoryId: json['categoryId'] as int,
      categoryName: json['categoryName'] as String,
      originUrl: json['originUrl'] as String?,
      currentUrl: json['currentUrl'] as String?,
    );

Map<String, dynamic> _$ImageToJson(Image instance) => <String, dynamic>{
      'id': instance.id,
      'tagId': instance.tagId,
      'tagName': instance.tagName,
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
      'originUrl': instance.originUrl,
      'currentUrl': instance.currentUrl,
    };
