import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable()
class Category {
  String type;
  int id;
  String name;

  Category(this.type, this.id, this.name);

  factory Category.fromJson(dynamic json) => _$CategoryFromJson(json);

  toJson() => _$CategoryToJson(this);
}
