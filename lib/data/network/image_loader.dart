import 'package:cached_network_image/cached_network_image.dart';
import 'package:gallery/util/logger.dart';


class ImageLoader{

  static final ImageLoader _instance = ImageLoader._internal();

  factory ImageLoader(){
    return _instance;
  }

  ImageLoader._internal(){
    logger.i("create imageLoader");
  }


  List<CachedNetworkImageProvider> cachedImage = [];

}
