/// code : 1000
/// msg : "success"
/// data : {"id":1,"versionCode":1,"versionName":"version_1","forceUpgrade":false,"apkUrl":"www.baidu.com","notice":"重大消息","insertAt":"2022-01-25T08:30:30+08:00"}

class RespUpgrade {
  RespUpgrade({
      this.code, 
      this.msg, 
      this.data,});

  RespUpgrade.fromJson(dynamic json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ? Version.fromJson(json['data']) : null;
  }
  int? code;
  String? msg;
  Version? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['msg'] = msg;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

  @override
  String toString() {
    return 'RespUpgrade{code: $code, msg: $msg, data: $data}';
  }
}

/// id : 1
/// versionCode : 1
/// versionName : "version_1"
/// forceUpgrade : false
/// apkUrl : "www.baidu.com"
/// notice : "重大消息"
/// insertAt : "2022-01-25T08:30:30+08:00"

class Version {
  Version({
      this.id, 
      this.versionCode, 
      this.versionName, 
      this.forceUpgrade, 
      this.apkUrl, 
      this.notice, 
      this.insertAt,});

  Version.fromJson(dynamic json) {
    id = json['id'];
    versionCode = json['versionCode'];
    versionName = json['versionName'];
    forceUpgrade = json['forceUpgrade'];
    apkUrl = json['apkUrl'];
    notice = json['notice'];
    insertAt = json['insertAt'];
  }
  int? id;
  int? versionCode;
  String? versionName;
  bool? forceUpgrade;
  String? apkUrl;
  String? notice;
  String? insertAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['versionCode'] = versionCode;
    map['versionName'] = versionName;
    map['forceUpgrade'] = forceUpgrade;
    map['apkUrl'] = apkUrl;
    map['notice'] = notice;
    map['insertAt'] = insertAt;
    return map;
  }

  @override
  String toString() {
    return 'Version{id: $id, versionCode: $versionCode, versionName: $versionName, forceUpgrade: $forceUpgrade, apkUrl: $apkUrl, notice: $notice, insertAt: $insertAt}';
  }
}