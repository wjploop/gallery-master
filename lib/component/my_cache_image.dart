import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery/data/model/my_cache_manger.dart';

import '../data/model/device.dart';

class MyCacheImage extends StatelessWidget {
  final String url;

  const MyCacheImage({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => CachedNetworkImage(
        placeholder: ((context, url) =>
            // Image.asset("assets/images/loading.gif"),
        Container(color: Theme.of(context).primaryColor)
        ),
        imageUrl: url,
        // width: constraints.maxWidth,
        // height: constraints.maxWidth / Device().aspectRatio,
        cacheManager: MyCacheManager(),
        fit: BoxFit.cover,
        memCacheWidth: Device().width.toInt(),
        memCacheHeight: Device().height.toInt(),

      ))
    ;
  }
}
