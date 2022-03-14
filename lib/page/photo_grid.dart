import 'package:flutter/material.dart';
import 'package:gallery/component/item_image.dart';
import 'package:gallery/data/api/client.dart';
import 'package:gallery/data/entity/resp_category.dart';
import 'package:gallery/data/model/ImagePageModel.dart';
import 'package:gallery/util/logger.dart';

import '../screen/routes.dart';

class PhotoGrid extends StatefulWidget {
  final CategoryModel category;

  final ImagePageModel model;

  const PhotoGrid({Key? key, required this.category, required this.model})
      : super(key: key);

  @override
  _PhotoGridState createState() => _PhotoGridState();
}

class _PhotoGridState extends State<PhotoGrid>
    with AutomaticKeepAliveClientMixin {
  bool loading = false;

  late ImagePageModel model;

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    model = widget.model;
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.offset >
          _scrollController.position.maxScrollExtent - 200) {
        getData();
      }
    });
    getData();
  }

  Future getData() async {
    if (loading || !widget.model.hasMore) {
      return;
    }
    loading = true;
    logger.i("get page ${widget.model.page}");
    Client().images(widget.category.id!, widget.model.page++).then((value) {
      loading = false;
      var page = value.data;
      setState(() {
        widget.model.items.addAll(page!.content!);
        widget.model.hasMore = !page.last!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.model.items.isNotEmpty) {
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
                        imageModel: model.items[index],
                        onTap: () {
                          print('on tap $index');
                          Navigator.of(context).pushNamed(
                              Routes.image_full_screen.name,
                              arguments: {
                                'model': widget.model,
                                "index": index
                              });
                        },
                      ),
                      childCount: model.items.length,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        mainAxisExtent: 300)),
              ),
              SliverToBoxAdapter(
                child: model.hasMore
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
  }

  Future<void> _onRefresh() async {
    model.page = 0;
    getData();
  }

  @override
  bool get wantKeepAlive => true;
}
