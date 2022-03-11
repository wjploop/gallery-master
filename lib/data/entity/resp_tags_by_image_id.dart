/// code : 1000
/// msg : "success"
/// data : [{"name":"赵露思","id":25,"type":"tag"},{"name":"白色裙子","id":29,"type":"tag"},{"name":"美女手机壁纸\n","id":31,"type":"tag"},{"name":"户外","id":35,"type":"tag"}]

class RespTagsByImageId {
  RespTagsByImageId({
      this.code, 
      this.msg, 
      this.data,});

  RespTagsByImageId.fromJson(dynamic json) {
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }
  int? code;
  String? msg;
  List<Data>? data;

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

/// name : "赵露思"
/// id : 25
/// type : "tag"

class Data {
  Data({
      this.name, 
      this.id, 
      this.type,});

  Data.fromJson(dynamic json) {
    name = json['name']?.replaceAll("\n","");
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

}