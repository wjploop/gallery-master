import 'package:flutter/material.dart';
import 'package:gallery/data/api/client.dart';
import 'package:gallery/data/model/category.dart';
import 'package:gallery/data/model/image.dart';

import 'home.dart';

class PhotoGrid extends StatefulWidget {
  final Category category;

  const PhotoGrid({Key? key, required this.category}) : super(key: key);

  @override
  _PhotoGridState createState() => _PhotoGridState();
}

class _PhotoGridState extends State<PhotoGrid> {
  List<ImageModel> images = [];

  @override
  void initState() {
    super.initState();
    Client().images().then((value) {
      var first = value.data.content;
      logger.i(first);
      setState(() {
        images.addAll(first);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return images.isEmpty
        ? Center(
          child: Text("loading"),
        )
        : ListView.builder(
            itemBuilder: (context, index) =>
                Image.network(images[index].originUrl!),
          );
  }
}
