import 'package:flutter/material.dart';
import 'package:gallery/data/model/image_map_model.dart';
import 'package:gallery/page/home.dart';
import 'package:gallery/screen/ImageByTagScreen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    Provider(
      create: (context) => ImagePageMapModel(),
    )
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        secondaryHeaderColor: Colors.orange,
      ),
      home: Home(),
      routes: {ImageByTagScreen.routeName: (context) => ImageByTagScreen()},
    );
  }
}
