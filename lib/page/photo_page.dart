import 'package:flutter/material.dart';
import 'package:gallery/data/model/ImagePageModel.dart';
import 'package:gallery/util/logger.dart';

import '../data/api/client.dart';
import '../data/entity/resp_tag.dart';
import '../screen/routes.dart';

class PhotoPage extends StatefulWidget {
  final ImagePageModel model;
  final int initialPage;

  const PhotoPage({Key? key, required this.model, required this.initialPage}) : super(key: key);

  @override
  _PhotoPageState createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  late PageController _controller;

  List<Tag> tags = [];

  bool isActive = false;

  bool showDetail = true;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: widget.initialPage);
    logger.i("photo page init");
    isActive = true;
    getTags(widget.initialPage);
  }

  void getTags(int index) {
    Client().tagsByImageId(widget.model.items[index].id!).then((value) {
      if (isActive) {
        setState(() {
          tags.clear();
          tags.addAll(value.data!);
          logger.i("get tags $tags");
        });
      }
    });
  }

  @override
  void dispose() {
    isActive = false;
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    var items = widget.model.items;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: AnimatedOpacity(
            opacity: showDetail ? 1.0 : 0.0,
            duration: Duration(milliseconds: 500),
            child: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            )),
      ),
      body: PageView.builder(
          scrollDirection: Axis.vertical,
          controller: _controller,
          itemCount: items.length,
          onPageChanged: (page) {
            getTags(page);
          },
          itemBuilder: (context, index) => Hero(
                tag: items[index].id!,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      showDetail = !showDetail;
                    });
                  },
                  child: Material(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0)),
                    ),
                    child: InkWell(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            items[index].originUrl!,
                            fit: BoxFit.cover,
                          ),
                          Visibility(
                            visible: showDetail,
                            child: Stack(alignment: Alignment.bottomLeft, children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 30),
                                width: double.maxFinite,
                                child: Column(
                                  verticalDirection: VerticalDirection.up,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () {},
                                        style: ButtonStyle(
                                            padding: MaterialStateProperty.resolveWith((states) => EdgeInsets.symmetric(horizontal: 80, vertical: 12)),
                                            shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20)))),
                                            backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.yellow.shade700)),
                                        child: Text(
                                          "设为壁纸",
                                          style: TextStyle(color: Colors.white),
                                        )),
                                    SizedBox(
                                      width: double.maxFinite,
                                      child: SingleChildScrollView(
                                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 40),
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: tags
                                              .map((e) => Container(
                                                    margin: EdgeInsets.symmetric(horizontal: 6),
                                                    child: Material(
                                                      color: Colors.blueGrey.withOpacity(0.5).withAlpha(120),
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(22))),
                                                      child: InkWell(
                                                        onTap: () {
                                                          Navigator.of(context).pushNamed(Routes.image_by_tag.name, arguments: e);
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                                          child: Text(
                                                            e.name!,
                                                            style: TextStyle(fontSize: 12, color: Colors.white),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ))
                                              .toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )),
    );
  }
}
