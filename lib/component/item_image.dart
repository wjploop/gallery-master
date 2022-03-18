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

    // Client().tagsByImageId(widget.imageModel.id!).then((value) {
    //   value.data?.forEach((t) {
    //     var tag = Container(
    //       margin: EdgeInsets.symmetric(horizontal: 6),
    //       child: TextButton(
    //           style: ButtonStyle(
    //               shape: MaterialStateProperty.resolveWith((states) =>
    //                   RoundedRectangleBorder(
    //                       borderRadius: BorderRadius.circular(18))),
    //               backgroundColor: MaterialStateProperty.resolveWith(
    //                   (states) => Colors.white.withOpacity(0.5))),
    //           onPressed: () {
    //             Navigator.of(context).pushNamedAndRemoveUntil(
    //                 ImageByTagScreen.routeName, ModalRoute.withName('/'),
    //                 arguments: Tag.instance(t.id, t.name));
    //           },
    //           child: Text(
    //             t.name!,
    //             textAlign: TextAlign.center,
    //             style: TextStyle(
    //                 fontSize: 12,
    //                 backgroundColor: Colors.grey.withOpacity(0.5),
    //                 color: Colors.white),
    //           )),
    //     );
    //     tags.add(tag);
    //     if (isActive) {
    //       setState(() {});
    //     }
    //   });
    // });
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
