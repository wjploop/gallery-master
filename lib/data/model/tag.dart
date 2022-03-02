import 'package:json_annotation/json_annotation.dart';

part 'tag.g.dart';

@JsonSerializable()
class Tag {
  String type;
  int id;
  String name;

  Tag(this.type, this.id, this.name);

  factory Tag.fromJson(dynamic json) => _$TagFromJson(json);

  toJson() => _$TagToJson(this);

  @override
  String toString() {
    return 'Tag{type: $type, id: $id, name: $name}';
  }
}
