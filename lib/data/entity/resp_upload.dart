/// code : 1000
/// msg : "success"
/// data : [223,224]

class RespUpload {
  RespUpload({
    this.code,
    this.msg,
    this.data,
  });

  RespUpload.fromJson(dynamic json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ? json['data'].cast<int>() : [];
  }

  int? code;
  String? msg;
  List<int>? data;

  RespUpload copyWith({
    int? code,
    String? msg,
    List<int>? data,
  }) =>
      RespUpload(
        code: code ?? this.code,
        msg: msg ?? this.msg,
        data: data ?? this.data,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['msg'] = msg;
    map['data'] = data;
    return map;
  }
}
