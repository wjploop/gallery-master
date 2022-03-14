import 'package:flutter/material.dart';
import 'package:gallery/data/entity/resp_tag.dart';
import 'package:gallery/page/page_image_by_tag.dart';

class ScreenImageByTag extends StatelessWidget {
  const ScreenImageByTag({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Tag;
    return ImageByTag(
      tag: args,
    );
  }
}
