import 'package:flutter/material.dart';
import 'package:gallery/data/entity/resp_tag.dart';
import 'package:gallery/data/model/ImagePageModel.dart';

import '../component/item_image.dart';
import '../data/api/client.dart';
import '../data/entity/resp_image.dart';
import '../screen/routes.dart';

class ImageByTag extends StatefulWidget {
  final Tag tag;

  const ImageByTag({Key? key, required this.tag}) : super(key: key);

  @override
  _ImageByTagState createState() => _ImageByTagState();
}

class _ImageByTagState extends State<ImageByTag> {
  List<ImageEntity> items = [];
  late ScrollController _scrollController;

  bool hasMore = true;
  int page = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.offset >
          _scrollController.position.maxScrollExtent - 200) {
        getData();
      }
    });
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("#" + widget.tag.name!),
        ),
        body: Builder(builder: (BuildContext context) {
          if (items.isNotEmpty) {
            return RefreshIndicator(
                child: CustomScrollView(
                  scrollDirection: Axis.vertical,
                  controller: _scrollController,
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.all(12),
                      sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) => ItemImage(
                              imageModel: items[index],
                              onTap: () {
                                print('on tap $index');
                                Navigator.of(context).pushNamed(
                                    Routes.image_full_screen.name,
                                    arguments: {
                                      "model": ImagePageModel(items, page, hasMore),
                                      "index": index
                                    });
                              },
                            ),
                            childCount: items.length,
                          ),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  mainAxisExtent: 300)),
                    ),
                    SliverToBoxAdapter(
                      child: hasMore
                          ? Container()
                          : Container(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                "已经到底了哦~",
                                textAlign: TextAlign.center,
                              ),
                            ),
                    )
                  ],
                ),
                onRefresh: _onRefresh);
          }

          return Center(
            child: Text("loading"),
          );
        }));
  }

  Future<void> _onRefresh() async {
    page = 0;
    getData();
  }

  void getData() async {
    Client().imagesByTagId(widget.tag.id!, page, 10).then((value) {
      if (page == 0) {
        items.clear();
      }
      items.addAll(value.data!.content!);
      hasMore = !value.data!.last!;
      page++;
      setState(() {});
    });
  }
}
