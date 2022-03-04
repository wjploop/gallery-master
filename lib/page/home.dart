import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gallery/data/api/client.dart';
import 'package:gallery/data/model/resp_category.dart';
import 'package:gallery/page/photo_grid.dart';

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

class A{}

class B extends A{}

void add(Iterable<A> list) {

}
void main(){
  List<B> list = [];
  add(list);
}