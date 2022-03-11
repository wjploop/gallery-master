import 'package:flutter/material.dart';
import 'package:gallery/data/entity/resp_tag.dart';

import '../component/item_image.dart';
import '../data/api/client.dart';
import '../data/entity/resp_image.dart';

class ImageByTagPage extends StatefulWidget {
  final Tag tag;

  const ImageByTagPage({Key? key, required this.tag}) : super(key: key);

  @override
  _ImageByTagPageState createState() => _ImageByTagPageState();
}

class _ImageByTagPageState extends State<ImageByTagPage> {
  List<ImageEntity> items = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.tag.name!),
        ),
        body: RefreshIndicator(
            child: PageView.builder(
                scrollDirection: Axis.vertical,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ItemImage(imageModel: items[index]);
                }),
            onRefresh: _onRefresh));
  }

  Future<void> _onRefresh() async {
    getData();
  }

  void getData() async {
    Client().imagesByTagId(widget.tag.id!, 0, 100).then((value) {
      value.data?.content?.forEach((element) {
        items.add(element);
      });
      setState(() {});
    });
  }
}
