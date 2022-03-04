/// code : 1000
/// msg : "success"
/// data : [{"name":"动漫","id":8,"new":false,"type":"category"},{"name":"动物","id":10,"new":false,"type":"category"},{"name":"新年","id":7,"new":false,"type":"category"},{"name":"游戏","id":9,"new":false,"type":"category"},{"name":"王者荣耀","id":13,"new":false,"type":"category"},{"name":"美女","id":5,"new":false,"type":"category"},{"name":"集原美","id":12,"new":false,"type":"category"},{"name":"风景","id":6,"new":false,"type":"category"},{"name":"鬼刀","id":11,"new":false,"type":"category"}]

class RespCategory {
  RespCategory({
      this.code, 
      this.msg, 
      this.data,});

  RespCategory.fromJson(dynamic json) {
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(CategoryModel.fromJson(v));
      });
    }
  }
  int? code;
  String? msg;
  List<CategoryModel>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['msg'] = msg;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// name : "动漫"
/// id : 8
/// new : false
/// type : "category"

class CategoryModel {
  CategoryModel({
      this.name, 
      this.id, 
      this.type,});

  CategoryModel.fromJson(dynamic json) {
    name = json['name'];
    id = json['id'];
    type = json['type'];
  }
  String? name;
  int? id;
  String? type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['id'] = id;
    map['type'] = type;
    return map;
  }

  @override
  String toString() {
    return 'CategoryModel{name: $name, id: $id, type: $type}';
  }
}