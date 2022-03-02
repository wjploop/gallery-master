import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gallery/data/api/api.dart';
import 'package:gallery/data/api/client.dart';
import 'package:gallery/data/model/category.dart';
import 'package:gallery/page/photo_grid.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();

    logger.i("hello");
    initData();
  }

  List<Category> categories = [];

  void initData() async {
    // var dio = Dio();
    // var api = Api(dio);
    // api.categories().then((value) => logger.i(value));
    // api.tags().then((value) => logger.i(value));
    // api.images().then((value) => logger.i(value));
    var client = Client();

    client.categories().then((value) {
      logger.i(value.data);
      setState(() {
        categories.addAll(value.data);
      });
    });

    client.tags().then((value) => {logger.i(value.data)});

    client.images().then((value) => {logger.i(value.data)});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: categories.length,
        child: Scaffold(
          appBar: AppBar(
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
                .map((e) => Container(
                        child: PhotoGrid(
                      category: e,
                    )))
                .toList(),
          ),
        ));
  }
}
