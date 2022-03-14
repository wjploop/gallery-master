import 'package:gallery/data/model/ImagePageModel.dart';

class ImagePageMapModel {
  Map<int, ImagePageModel> map = {};

  ImagePageModel getModel(int categoryId) {
    map.putIfAbsent(categoryId, () => ImagePageModel.init());
    return map[categoryId]!;
  }
}
