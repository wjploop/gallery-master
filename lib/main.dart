import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery/data/model/image_map_model.dart';
import 'package:gallery/page/home.dart';
import 'package:gallery/screen/routes.dart';
import 'package:gallery/screen/screen_image_by_tag.dart';
import 'package:gallery/screen/screen_image_full.dart';
import 'package:provider/provider.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));

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
      routes: {
        Routes.image_by_tag.name: (context) => ScreenImageByTag(),
        Routes.image_full_screen.name: (context) => ScreenFullImage()
      },
    );
  }
}
