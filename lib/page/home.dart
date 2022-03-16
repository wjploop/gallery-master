import 'package:flutter/material.dart';
import 'package:gallery/data/api/client.dart';
import 'package:gallery/data/entity/resp_category.dart';
import 'package:gallery/data/model/device.dart';
import 'package:gallery/data/model/image_map_model.dart';
import 'package:gallery/page/photo_grid.dart';
import 'package:provider/provider.dart';

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
    return DefaultTabController(
        length: categories.length,
        child: Scaffold(
          appBar: AppBar(
              title: Text("萝卜壁纸"),
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
                  (e) => PhotoGrid(
                      category: e, model: context.read<ImagePageMapModel>()
                      .getModel(e.id!)),
                )
                .toList(),
          ),
        ));
  }
}
