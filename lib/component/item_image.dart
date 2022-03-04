import 'package:flutter/material.dart';
import 'package:gallery/data/model/resp_image.dart';

class ItemImage extends StatelessWidget {
  final ImageModel imageModel;

  const ItemImage({Key? key, required this.imageModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: FadeInImage.assetNetwork(
        placeholder: "assets/images/loading.gif",
        image: imageModel.originUrl!,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
