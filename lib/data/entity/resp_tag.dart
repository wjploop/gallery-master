/// code : 1000
/// msg : "success"
/// data : {"content":[{"name":"good life","id":15,"new":false,"type":"tag"},{"name":"带眼镜的清纯美女高清手机壁纸\n","id":24,"new":false,"type":"tag"},{"name":"赵露思","id":25,"new":false,"type":"tag"},{"name":"侧脸","id":26,"new":false,"type":"tag"},{"name":"微笑","id":27,"new":false,"type":"tag"},{"name":"美腿","id":28,"new":false,"type":"tag"},{"name":"白色裙子","id":29,"new":false,"type":"tag"},{"name":"全面屏美女手机壁纸\n","id":30,"new":false,"type":"tag"},{"name":"美女手机壁纸\n","id":31,"new":false,"type":"tag"},{"name":"粉色包臀裙美女手机壁纸\n","id":32,"new":false,"type":"tag"}],"pageable":{"sort":{"empty":true,"sorted":false,"unsorted":true},"offset":0,"pageNumber":0,"pageSize":10,"paged":true,"unpaged":false},"last":false,"totalPages":36,"totalElements":358,"size":10,"number":0,"sort":{"empty":true,"sorted":false,"unsorted":true},"first":true,"numberOfElements":10,"empty":false}

class RespTag {
  RespTag({
    this.code,
    this.msg,
    this.data,
  });

  RespTag.fromJson(dynamic json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ? Page.fromJson(json['data']) : null;
  }

  int? code;
  String? msg;
  Page? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['msg'] = msg;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}

/// content : [{"name":"good life","id":15,"new":false,"type":"tag"},{"name":"带眼镜的清纯美女高清手机壁纸\n","id":24,"new":false,"type":"tag"},{"name":"赵露思","id":25,"new":false,"type":"tag"},{"name":"侧脸","id":26,"new":false,"type":"tag"},{"name":"微笑","id":27,"new":false,"type":"tag"},{"name":"美腿","id":28,"new":false,"type":"tag"},{"name":"白色裙子","id":29,"new":false,"type":"tag"},{"name":"全面屏美女手机壁纸\n","id":30,"new":false,"type":"tag"},{"name":"美女手机壁纸\n","id":31,"new":false,"type":"tag"},{"name":"粉色包臀裙美女手机壁纸\n","id":32,"new":false,"type":"tag"}]
/// pageable : {"sort":{"empty":true,"sorted":false,"unsorted":true},"offset":0,"pageNumber":0,"pageSize":10,"paged":true,"unpaged":false}
/// last : false
/// totalPages : 36
/// totalElements : 358
/// size : 10
/// number : 0
/// sort : {"empty":true,"sorted":false,"unsorted":true}
/// first : true
/// numberOfElements : 10
/// empty : false

class Page {
  Page({
    this.content,
    this.pageable,
    this.last,
    this.totalPages,
    this.totalElements,
    this.size,
    this.number,
    this.sort,
    this.first,
    this.numberOfElements,
    this.empty,
  });

  Page.fromJson(dynamic json) {
    if (json['content'] != null) {
      content = [];
      json['content'].forEach((v) {
        content?.add(Tag.fromJson(v));
      });
    }
    pageable =
        json['pageable'] != null ? Pageable.fromJson(json['pageable']) : null;
    last = json['last'];
    totalPages = json['totalPages'];
    totalElements = json['totalElements'];
    size = json['size'];
    number = json['number'];
    sort = json['sort'] != null ? Sort.fromJson(json['sort']) : null;
    first = json['first'];
    numberOfElements = json['numberOfElements'];
    empty = json['empty'];
  }

  List<Tag>? content;
  Pageable? pageable;
  bool? last;
  int? totalPages;
  int? totalElements;
  int? size;
  int? number;
  Sort? sort;
  bool? first;
  int? numberOfElements;
  bool? empty;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (content != null) {
      map['content'] = content?.map((v) => v.toJson()).toList();
    }
    if (pageable != null) {
      map['pageable'] = pageable?.toJson();
    }
    map['last'] = last;
    map['totalPages'] = totalPages;
    map['totalElements'] = totalElements;
    map['size'] = size;
    map['number'] = number;
    if (sort != null) {
      map['sort'] = sort?.toJson();
    }
    map['first'] = first;
    map['numberOfElements'] = numberOfElements;
    map['empty'] = empty;
    return map;
  }

  @override
  String toString() {
    return 'Page{content: $content, pageable: $pageable, last: $last, totalPages: $totalPages, totalElements: $totalElements, size: $size, number: $number, sort: $sort, first: $first, numberOfElements: $numberOfElements, empty: $empty}';
  }
}

/// empty : true
/// sorted : false
/// unsorted : true

class Sort {
  Sort({
    this.empty,
    this.sorted,
    this.unsorted,
  });

  Sort.fromJson(dynamic json) {
    empty = json['empty'];
    sorted = json['sorted'];
    unsorted = json['unsorted'];
  }

  bool? empty;
  bool? sorted;
  bool? unsorted;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['empty'] = empty;
    map['sorted'] = sorted;
    map['unsorted'] = unsorted;
    return map;
  }
}

/// sort : {"empty":true,"sorted":false,"unsorted":true}
/// offset : 0
/// pageNumber : 0
/// pageSize : 10
/// paged : true
/// unpaged : false

class Pageable {
  Pageable({
    this.sort,
    this.offset,
    this.pageNumber,
    this.pageSize,
    this.paged,
    this.unpaged,
  });

  Pageable.fromJson(dynamic json) {
    sort = json['sort'] != null ? Sort.fromJson(json['sort']) : null;
    offset = json['offset'];
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    paged = json['paged'];
    unpaged = json['unpaged'];
  }

  Sort? sort;
  int? offset;
  int? pageNumber;
  int? pageSize;
  bool? paged;
  bool? unpaged;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (sort != null) {
      map['sort'] = sort?.toJson();
    }
    map['offset'] = offset;
    map['pageNumber'] = pageNumber;
    map['pageSize'] = pageSize;
    map['paged'] = paged;
    map['unpaged'] = unpaged;
    return map;
  }
}

/// name : "good life"
/// id : 15
/// new : false
/// type : "tag"

class Tag {
  Tag({
    this.name,
    this.id,
    this.type,
  });

  Tag.instance(this.id, this.name);

  Tag.fromJson(dynamic json) {
    name = json['name'].replaceAll("\n", "");
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
    return 'Tag{name: $name, id: $id, type: $type}';
  }
}
