import 'package:gallery/data/entity/resp_tag.dart';

/// code : 1000
/// msg : "success"
/// data : {"content":[{"id":173,"categoryId":10,"categoryName":"动物","originUrl":"http://img.netbian.com/file/2022/0119/small005527KyuJt1642524927.jpg","currentUrl":null,"type":"image"}],"pageable":{"sort":{"empty":true,"sorted":false,"unsorted":true},"offset":0,"pageNumber":0,"pageSize":10,"paged":true,"unpaged":false},"last":true,"totalPages":1,"totalElements":1,"size":10,"number":0,"sort":{"empty":true,"sorted":false,"unsorted":true},"first":true,"numberOfElements":1,"empty":false}

class RespImage {
  RespImage({
    this.code,
    this.msg,
    this.data,
  });

  RespImage.fromJson(dynamic json) {
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

  @override
  String toString() {
    return 'RespImage{code: $code, msg: $msg, data: $data}';
  }
}

/// content : [{"id":173,"categoryId":10,"categoryName":"动物","originUrl":"http://img.netbian.com/file/2022/0119/small005527KyuJt1642524927.jpg","currentUrl":null,"type":"image"}]
/// pageable : {"sort":{"empty":true,"sorted":false,"unsorted":true},"offset":0,"pageNumber":0,"pageSize":10,"paged":true,"unpaged":false}
/// last : true
/// totalPages : 1
/// totalElements : 1
/// size : 10
/// number : 0
/// sort : {"empty":true,"sorted":false,"unsorted":true}
/// first : true
/// numberOfElements : 1
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
        content?.add(ImageEntity.fromJson(v));
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

  List<ImageEntity>? content;
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

  @override
  String toString() {
    return 'Pageable{sort: $sort, offset: $offset, pageNumber: $pageNumber, pageSize: $pageSize, paged: $paged, unpaged: $unpaged}';
  }
}

/// id : 173
/// categoryId : 10
/// categoryName : "动物"
/// originUrl : "http://img.netbian.com/file/2022/0119/small005527KyuJt1642524927.jpg"
/// currentUrl : null
/// type : "image"

class ImageEntity {
  ImageEntity({
    this.id,
    this.categoryId,
    this.categoryName,
    this.originUrl,
    this.currentUrl,
    this.type,
  });

  ImageEntity.fromJson(dynamic json) {
    id = json['id'];
    categoryId = json['categoryId'];
    categoryName = json['categoryName'];
    originUrl = json['originUrl'];
    currentUrl = json['currentUrl'];
    type = json['type'];
    tags = fromTagStr(json['tags']);
  }

  int? id;
  int? categoryId;
  String? categoryName;
  String? originUrl;
  String? currentUrl;
  String? type;
  List<Tag> tags = [];

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['categoryId'] = categoryId;
    map['categoryName'] = categoryName;
    map['originUrl'] = originUrl;
    map['currentUrl'] = currentUrl;
    map['type'] = type;
    return map;
  }



  @override
  String toString() {
    return 'ImageModel{id: $id, categoryId: $categoryId, categoryName: $categoryName, originUrl: $originUrl, currentUrl: $currentUrl, type: $type}';
  }

  List<Tag> fromTagStr(String json) {
    List<Tag> tags = [];
    json.split(",").forEach((e) {
      var arr = e.split(":");
      Tag tag = Tag(name :arr[1].replaceAll("\n", "").trim(),id: int.parse(arr[0]));
      tags.add(tag);
    });
    return tags;
  }

}


