import 'package:flutter/material.dart';
import 'package:gallery/component/item_image.dart';
import 'package:gallery/data/api/client.dart';
import 'package:gallery/data/model/resp_category.dart';
import 'package:gallery/data/model/resp_image.dart';

class PhotoGrid extends StatefulWidget {
  final CategoryModel category;

  const PhotoGrid({Key? key, required this.category}) : super(key: key);

  @override
  _PhotoGridState createState() => _PhotoGridState();
}

class _PhotoGridState extends State<PhotoGrid>
    with AutomaticKeepAliveClientMixin {
  List<ImageModel> items = [];
  int p = 0;
  bool hasMore = true;
  bool loading = false;

  late PageController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = PageController();
    _scrollController.addListener(() {
      if (_scrollController.page == items.length - 3) {
        getData();
      }
    });
    getData();
  }

  Future getData() async {
    if (loading) {
      return;
    }
    Client().images(widget.category.id!, p++).then((value) {
      var page = value.data;
      setState(() {
        items.addAll(page!.content!);
        hasMore = !page.last!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (items.isNotEmpty) {
      return RefreshIndicator(
          child: PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: items.length,
              controller: _scrollController,
              itemBuilder: (context, index) {
                return ItemImage(imageModel:
                items[index]);
              }),
          onRefresh: _onRefresh);
    }

    return Center(
      child: Text("loading"),
    );
  }

  Future<void> _onRefresh() async {
    p = 0;
    getData();
  }

  @override
  bool get wantKeepAlive => true;
}
