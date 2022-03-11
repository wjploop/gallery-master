import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:gallery/data/api/client.dart';
import 'package:gallery/data/entity/resp_image.dart';
import 'package:gallery/screen/ImageByTagScreen.dart';

import '../data/entity//resp_tag.dart';

class ItemImage extends StatefulWidget {
  final ImageEntity imageModel;

  const ItemImage({Key? key, required this.imageModel}) : super(key: key);

  @override
  _ItemImageState createState() => _ItemImageState();
}

class _ItemImageState extends State<ItemImage> {
  bool show = false;
  List<Widget> tags = [];

  bool shouldUpdate = false;

  @override
  void initState() {
    super.initState();
    shouldUpdate = true;

    Client().tagsByImageId(widget.imageModel.id!).then((value) {
      value.data?.forEach((t) {
        var tag = Container(
          margin: EdgeInsets.symmetric(horizontal: 6),
          child: TextButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.resolveWith((states) =>
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18))),
                  backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.white.withOpacity(0.5))),
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    ImageByTagScreen.routeName, ModalRoute.withName('/'),
                    arguments: Tag.instance(t.id, t.name));
              },
              child: Text(
                t.name!,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                    backgroundColor: Colors.grey.withOpacity(0.5),
                    color: Colors.white),
              )),
        );
        tags.add(tag);
        if (shouldUpdate) {
          setState(() {});
        }
      });
    });
  }

  @override
  void dispose() {
    shouldUpdate = false;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6))),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(widget.imageModel.originUrl!))),
        ),
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
    );
  }
}
