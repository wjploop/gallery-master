import 'package:flutter/material.dart';
import 'package:gallery/data/api/client.dart';
import 'package:gallery/data/entity/resp_category.dart';
import 'package:gallery/data/model/device.dart';
import 'package:gallery/data/model/image_map_model.dart';
import 'package:gallery/page/photo_grid.dart';
import 'package:gallery/screen/routes.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../util/logger.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    initData();
  }

  List<CategoryModel> categories = [];

  var lastTime = DateTime.now();


  void initData() async {
    var client = Client();

    client.categories().then((value) {
      logger.i(value.data);
      setState(() {
        categories.addAll(value.data!);
      });
    });

    client.tags().then((value) => {logger.i(value.data)});
  }

  @override
  Widget build(BuildContext context) {
    Device().init(context);
    return WillPopScope(
      onWillPop: () async{
        var current = DateTime.now();
        if(current.difference(lastTime).inSeconds < 2) {
          return true;
        }
        showTopSnackBar(context, CustomSnackBar.info(message: "再次返回退出萝卜壁纸"));
        lastTime = current;

        return false;
      },
      child: DefaultTabController(
          length: categories.length,
          child: Scaffold(
            appBar: AppBar(
                leading: Image.asset("assets/images/carrot.png"),
                centerTitle: true,
                title: Hero(
                  tag: "search",

                  child: GestureDetector(
                    onTap: (){
                      Navigator.of(context).pushNamed(Routes.image_by_search.name);
                    },
                    child: Material(
                      color: Colors.transparent,
                      child: SizedBox(
                        height: 36,
                        child: TextField(
                          textAlignVertical: TextAlignVertical.center,
                          style: TextStyle(color: Colors.white70),
                          cursorColor: Colors.white70,
                          enabled: false,
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
                              hintStyle: TextStyle(fontSize :14,color: Colors.white24),
                              focusedBorder: null),
                        ),
                      ),
                    ),
                  ),
                ),
                actions: [Container(padding: EdgeInsets.symmetric(horizontal: 20), child: Icon(Icons.menu_rounded))],
                bottom: TabBar(
                  isScrollable: true,
                  tabs: categories
                      .map((e) => Tab(
                            text: e.name,
                          ))
                      .toList(),
                )),
            body: TabBarView(
              children: categories
                  .map(
                    (e) => PhotoGrid(category: e, model: context.read<ImagePageMapModel>().getModel(e.id!)),
                  )
                  .toList(),
            ),
          )),
    );
  }
}
