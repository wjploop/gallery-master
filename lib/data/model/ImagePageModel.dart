import 'package:gallery/data/entity/resp_image.dart';

class ImagePageModel {
  List<ImageEntity> items = [];
  int page = 0;
  bool hasMore = true;

  ImagePageModel(this.items, this.page, this.hasMore);

  ImagePageModel.init();
}
