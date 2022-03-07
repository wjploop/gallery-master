import 'package:flutter/material.dart';
import 'package:gallery/data/api/client.dart';
import 'package:gallery/data/model/resp_image.dart';

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
        var tag = TextButton(
            style: ButtonStyle().copyWith(
                backgroundColor: MaterialStateProperty.resolveWith(
                    (states) => Colors.white.withOpacity(0.5)),
            ),

            onPressed: () {},
            child: Text(
              t.name!,
              style: TextStyle(),
            ));
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
            child: Row(
              children: tags,
            ),
          ),
        ]),
      ],
    );
  }
}
