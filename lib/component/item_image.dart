import 'package:flutter/material.dart';
import 'package:gallery/component/my_cache_image.dart';
import 'package:gallery/data/entity/resp_image.dart';

class ItemImage extends StatefulWidget {
  final ImageEntity imageModel;

  final VoidCallback onTap;

  const ItemImage({Key? key, required this.imageModel, required this.onTap}) : super(key: key);

  @override
  _ItemImageState createState() => _ItemImageState();
}

class _ItemImageState extends State<ItemImage> {
  bool show = false;
  List<Widget> tags = [];

  bool isActive = false;

  @override
  void initState() {
    super.initState();
    isActive = true;
  }

  @override
  void dispose() {
    isActive = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var imageUrl = widget.imageModel.originUrl!;
    return Material(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: InkWell(
        onTap: widget.onTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
                tag: widget.imageModel.id!,
                child: ClipRRect(borderRadius: BorderRadius.all(Radius.circular(6)), child: MyCacheImage(url: imageUrl))),
            Stack(alignment: Alignment.bottomCenter, children: [
              Positioned(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(top: 40, bottom: 40),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: tags,
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
