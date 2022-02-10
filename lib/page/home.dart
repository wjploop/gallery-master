import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gallery/data/api/api.dart';
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
  }

  void initData() async {
    var dio = Dio();
    var api = Api(dio);
    api.categories().then((value) => logger.i(value));
    api.tags().then((value) => logger.i(value));
    api.images().then((value) => logger.i(value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Colors.blue,
        child: Center(
          child: Text("hello"),
        ),
      ),
    );
  }
}
