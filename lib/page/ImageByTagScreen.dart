import 'package:flutter/material.dart';
import 'package:gallery/data/model/resp_tag.dart';
import 'package:gallery/page/page_image_by_tag.dart';

class ImageByTagScreen extends StatelessWidget {
  const ImageByTagScreen({Key? key}) : super(key: key);

  static const routeName = "/imageByTag";

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Tag;
    return ImageByTagPage(
      tag: args,
    );
  }
}
