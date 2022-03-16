import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:gallery/data/model/my_cache_manger.dart';

import '../data/model/device.dart';

class MyCacheImage extends StatelessWidget {
  final String url;

  const MyCacheImage({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      placeholder: ((context, url) => Image.asset("assets/images/loading.gif")),
      imageUrl: url,
      cacheManager: MyCacheManager(),
      fit: BoxFit.fitWidth,
      memCacheWidth: Device().width.toInt(),
      memCacheHeight: Device().height.toInt(),

    );
  }
}
