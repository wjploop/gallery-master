import 'package:flutter/material.dart';
import 'package:gallery/component/search_history_compoment.dart';
import 'package:gallery/component/search_text_filed.dart';
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
  var searchKey = "";

  List<ImageEntity> items = [];
  late ScrollController _scrollController;

  bool hasMore = true;
  int page = 0;
  bool loading = false;

  late TextEditingController _editingController;
  bool showDelete = false;

  SearchStatus status = SearchStatus.init;


  GlobalKey<SearchHistoryWidgetState> historyKey = GlobalKey();

  // add extra key enable textFiled widget would not unmount on hero animation
  GlobalKey textFieldKey = GlobalKey();


  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      FocusScope.of(context).unfocus();
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


    logger.i("init state");
  }

  @override
  void dispose() {
    super.dispose();
    logger.i("depose");
    debugPrint("hello");
  }


  void search(String str){
    if(str.isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();
    page = 0;
    getData();
    historyKey.currentState?.add(str);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          centerTitle: false,
          title: Hero(
              tag: "search",
              child: SearchTextFiled(
                enable: true,
                key: textFieldKey,
                onSubmitted: (str) {
                  search(str);
                },
                editingController: _editingController,
              )),
          actions: [
            TextButton(
              onPressed: () {
                search(_editingController.text.trim());
              },
              child: Text(
                "搜索",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
        body: Builder(builder: (BuildContext context) {
          switch (status) {
            case SearchStatus.init:
              return SearchHistoryWidget(
                key: historyKey,
                onSearch: (str){
                  setState(() {
                    _editingController.text =str;
                  });
                  search(str);
                },
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
                                  FocusScope.of(context).unfocus();
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

  Future? _future;

  Future getData() async {
    if (page == 0) {
      loading = false;
      hasMore = true;
    }
    if (loading || !hasMore) {
      return;
    }
    loading = true;
    setState(() {
      if (page == 0) {
        if (lastSearch != _editingController.text.trim()) {
          status = SearchStatus.searching;
        }
      }
    });
    _future = Client().imageBySearch(_editingController.text.trim(), page, 15).then((value) {
      logger.i(value);
      if (page == 0) {
        lastSearch = _editingController.text.trim();
        items.clear();
        status = value.data!.content!.isEmpty ? SearchStatus.no_result : SearchStatus.show_data;
      } else {
        status = SearchStatus.show_data;
      }
      items.addAll(value.data!.content!);
      hasMore = !value.data!.last!;
      page++;
      setState(() {});
    }).whenComplete(() {
      loading = false;
    });
  }
}

enum SearchStatus {
  init,
  searching,
  show_data,
  no_result,
}
