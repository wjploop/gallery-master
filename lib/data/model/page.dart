import 'package:gallery/data/model/category.dart';
import 'package:gallery/data/model/image.dart';
import 'package:json_annotation/json_annotation.dart';

part 'page.g.dart';

@JsonSerializable()
class Page<T> {
  int number;
  int numberOfElements;
  bool last;
  @_ContentConverter()
  List<T> content;

  Page(this.number, this.numberOfElements, this.last, this.content);

  factory Page.fromJson(dynamic json) => _$PageFromJson(json);

  Map<String, dynamic> toJson() => _$PageToJson(this);
}

class _ContentConverter<T> implements JsonConverter<T, dynamic> {
  const _ContentConverter();

  @override
  T fromJson(dynamic json) {
    if (json is Map<String, dynamic> && json.containsKey("type")) {
      var type = json["type"];
      dynamic res;
      if (type == "image") {
        res = Image.fromJson(json);
      } else if (type == "category") {
        res = Category.fromJson(json);
      }
      return res as T;
    }
    return json as T;
  }

  @override
  toJson(T object) => object;
}
