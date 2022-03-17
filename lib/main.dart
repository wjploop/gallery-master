import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:gallery/data/model/image_map_model.dart';
import 'package:gallery/page/home.dart';
import 'package:gallery/route/fade_route.dart';
import 'package:gallery/screen/routes.dart';
import 'package:gallery/screen/screen_image_by_tag.dart';
import 'package:gallery/screen/screen_image_full.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  CachedNetworkImage.logLevel = CacheManagerLogLevel.verbose;

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
        // Routes.image_full_screen.name: (context) => ScreenFullImage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == Routes.image_full_screen.name) {
          return FadeRoute(settings: settings, builder: (context) => ScreenFullImage());
        }
      },
    );
  }
}
