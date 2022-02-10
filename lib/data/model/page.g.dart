// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Page<T> _$PageFromJson<T>(Map<String, dynamic> json) => Page<T>(
      json['number'] as int,
      json['numberOfElements'] as int,
      json['last'] as bool,
      (json['content'] as List<dynamic>)
          .map(_ContentConverter<T>().fromJson)
          .toList(),
    );

Map<String, dynamic> _$PageToJson<T>(Page<T> instance) => <String, dynamic>{
      'number': instance.number,
      'numberOfElements': instance.numberOfElements,
      'last': instance.last,
      'content': instance.content.map(_ContentConverter<T>().toJson).toList(),
    };
