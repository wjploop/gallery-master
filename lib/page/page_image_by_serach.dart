import 'package:flutter/material.dart';
import 'package:gallery/data/model/ImagePageModel.dart';

import '../component/item_image.dart';
import '../data/api/client.dart';
import '../data/entity/resp_image.dart';
import '../screen/routes.dart';
import '../util/logger.dart';

class ImageBySearchPage extends StatefulWidget {
  const ImageBySearchPage({Key? key}) : super(key: key);

  @override
  _ImageBySearchPageState createState() => _ImageBySearchPageState();
}

class _ImageBySearchPageState extends State<ImageBySearchPage> {
  var search = "";

  List<ImageEntity> items = [];
  late ScrollController _scrollController;

  bool hasMore = true;
  int page = 0;

  late TextEditingController _editingController;
  bool showDelete = false;

  SearchStatus status = SearchStatus.init;

  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.offset > _scrollController.position.maxScrollExtent - 200) {
        getData();
      }
    });

    _editingController = TextEditingController();

    _editingController.addListener(() {
      setState(() {
        showDelete = _editingController.text.isNotEmpty;
      });
    });

    _focusNode = FocusNode();

    logger.i("init state");
  }

  @override
  void dispose() {
    super.dispose();
    logger.i("depose");
    debugPrint("hello");
  }

  static int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Focus(
            onFocusChange: (focus) {
              logger.i("focus $focus");
            },
            child: Hero(
                tag: "search",

                flightShuttleBuilder: (flightContext, animation, flightDirection, fromHeroContext, toHeroContext) {
                  logger.i("anim status :" + animation.status.toString());
                  animation.addStatusListener((status) {
                    if (status == AnimationStatus.completed) {
                      _focusNode.requestFocus();
                    }
                   });
                  return  Center(
                    child: Material(
                      color: Colors.transparent,
                      child: SizedBox(
                        height: 36,
                        child: TextField(
                          textAlignVertical: TextAlignVertical.center,
                          textInputAction: TextInputAction.search,
                          controller: _editingController,
                          style: TextStyle(color: Colors.white70),
                          cursorColor: Colors.white70,
                          autofocus: false,
                          enabled: false,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Theme.of(context).primaryColorDark,
                              border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(30))),
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              contentPadding: EdgeInsets.zero,
                              hintText: "搜索",
                              hintStyle: TextStyle(fontSize :14,color: Colors.white24),
                              suffixIcon: AnimatedOpacity(
                                  opacity: showDelete ? 1 : 0,
                                  duration: Duration(milliseconds: 200),
                                  child: GestureDetector(
                                      onTap: () {
                                        _editingController.clear();
                                      },
                                      child: Icon(
                                        Icons.highlight_remove,
                                        color: Theme.of(context).iconTheme.color,
                                      ))),
                              focusedBorder: null),
                        ),
                      ),
                    ),
                  );
                },
                child: Builder(builder: (context) {
                  logger.i("build ${++count}");
                  return Center(
                    child: Material(
                      color: Colors.transparent,
                      child: SizedBox(
                        height: 36,
                        child: TextField(
                          focusNode: _focusNode,
                          onSubmitted: (str) {
                            page = 0;
                            getData();
                          },
                          onChanged: (str) {},
                          textAlignVertical: TextAlignVertical.center,
                          textInputAction: TextInputAction.search,
                          controller: _editingController,
                          style: TextStyle(color: Colors.white70),
                          cursorColor: Colors.white70,
                          autofocus: false,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Theme.of(context).primaryColorDark,
                              border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(30))),
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              contentPadding: EdgeInsets.zero,
                              hintText: "搜索",
                              hintStyle: TextStyle(color: Colors.white24),
                              suffixIcon: AnimatedOpacity(
                                  opacity: showDelete ? 1 : 0,
                                  duration: Duration(milliseconds: 200),
                                  child: GestureDetector(
                                      onTap: () {
                                        _editingController.clear();
                                      },
                                      child: Icon(
                                        Icons.highlight_remove,
                                        color: Theme.of(context).iconTheme.color,
                                      ))),
                              focusedBorder: null),
                        ),
                      ),
                    ),
                  );
                })),
          ),
        ),
        body: Builder(builder: (BuildContext context) {
          switch (status) {
            case SearchStatus.init:
              return Center(
                child: Text("init"),
              );
            case SearchStatus.searching:
              return Center(
                child: Text("searching"),
              );
            case SearchStatus.no_result:
              return Center(
                child: Text("no result"),
              );
            case SearchStatus.show_data:
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
                                  Navigator.of(context).pushNamed(Routes.image_full_screen.name, arguments: {"model": ImagePageModel(items, page, hasMore), "index": index});
                                },
                              ),
                              childCount: items.length,
                            ),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 6, crossAxisSpacing: 6, mainAxisExtent: 200)),
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
        }));
  }

  Future<void> _onRefresh() async {
    page = 0;
    getData();
  }

  var lastSearch = "";

  void getData() async {
    setState(() {
      if(page == 0) {
        if(lastSearch != _editingController.text.trim()) {
          status = SearchStatus.searching;
        }
      }
    });
    Client().imageBySearch(_editingController.text.trim(), page, 15).then((value) {
      if (page == 0) {
        lastSearch = _editingController.text.trim();
        items.clear();
        status = value.data!.content!.isEmpty ? SearchStatus.no_result : SearchStatus.show_data;
      }else{
        status = SearchStatus.show_data;
      }
      items.addAll(value.data!.content!);
      hasMore = !value.data!.last!;
      page++;
      setState(() {});
    });
  }
}

enum SearchStatus {
  init,
  searching,
  show_data,
  no_result,
}
