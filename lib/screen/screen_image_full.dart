import 'package:flutter/material.dart';
import 'package:gallery/page/photo_page.dart';

class ScreenFullImage extends StatelessWidget {
  const ScreenFullImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var map = ModalRoute.of(context)!.settings.arguments as Map;
    return PhotoPage(
      model: map['model'],
      initialPage: map['index'],
    );
  }
}
