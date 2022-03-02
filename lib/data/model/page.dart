import 'package:gallery/data/model/category.dart';
import 'package:gallery/data/model/image.dart';
import 'package:gallery/data/model/tag.dart';
import 'package:json_annotation/json_annotation.dart';

class Page<T> {
  int number;
  int numberOfElements;
  bool last;
  List<T> content;

  Page(this.number, this.numberOfElements, this.last, this.content);

  factory Page.fromJson(dynamic json) {
    json as Map<String, dynamic>;
    var _number = json['number'];
    var _numberOfElements = json['numberOfElements'];
    var _last = json['last'];
    var content_json = json['content'] as List<dynamic>;
    var _content = [];
    if (content_json.isNotEmpty) {
      var first = content_json.first as Map<String, dynamic>;
      var type = first["type"];
      if (type == "tag") {
        return Page<Tag>(_number, _numberOfElements, _last,
            content_json.map((e) => Tag.fromJson(e)).toList()) as Page<T>;
      } else if (type == "image") {
        return Page<ImageModel>(_number, _numberOfElements, _last,
            content_json.map((e) => ImageModel.fromJson(e)).toList()) as Page<T>;
      } else if (type == "category") {
        return Page<Category>(_number, _numberOfElements, _last,
            content_json.map((e) => Category.fromJson(e)).toList()) as Page<T>;
      } else {
        return Page(_number, _numberOfElements, _last, []);
      }
    } else {
      return Page(_number, _numberOfElements, _last, []);
    }
  }

  @override
  String toString() {
    return 'Page{number: $number, numberOfElements: $numberOfElements, last: $last, content: $content}';
  }

// Map<String, dynamic> toJson() => _$PageToJson(this);
}

class _ContentConverter<T> implements JsonConverter<T, dynamic> {
  const _ContentConverter();

  @override
  T fromJson(dynamic json) {
    print('content ${json}');
    if (json is Map<String, dynamic> && json.containsKey("type")) {
      var type = json["type"];
      dynamic res;
      if (type == "image") {
        res = ImageModel.fromJson(json);
      } else if (type == "category") {
        res = Category.fromJson(json);
      } else if (type == "tag") {
        res = Tag.fromJson(json);
      }
      return res as T;
    }
    throw Exception("should contain type attr ${json}");

    return json as T;
  }

  @override
  toJson(T object) => object;
}
