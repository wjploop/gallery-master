import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:gallery/data/api/client.dart';
import 'package:gallery/data/model/resp_image.dart';
import 'package:gallery/page/ImageByTagScreen.dart';

import '../data/model/resp_tag.dart';

class ItemImage extends StatefulWidget {
  final ImageModel imageModel;

  const ItemImage({Key? key, required this.imageModel}) : super(key: key);

  @override
  _ItemImageState createState() => _ItemImageState();
}

class _ItemImageState extends State<ItemImage> {
  bool show = false;
  List<Widget> tags = [];

  @override
  void initState() {
    super.initState();

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
                style: TextStyle(fontSize: 12, backgroundColor:Colors.grey
                    .withOpacity(0.5),color: Colors.white),
              )),
        );
        setState(() {
          tags.add(tag);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          color: Colors.blue,
          child: FadeInImage.assetNetwork(
            placeholder: "assets/images/loading.gif",
            image: widget.imageModel.originUrl!,
            fit: BoxFit.fitWidth,
          ),
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
