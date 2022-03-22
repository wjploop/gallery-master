import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery/data/model/image_map_model.dart';
import 'package:gallery/page/home.dart';
import 'package:gallery/route/fade_route.dart';
import 'package:gallery/screen/routes.dart';
import 'package:gallery/screen/screen_image_by_search.dart';
import 'package:gallery/screen/screen_image_by_tag.dart';
import 'package:gallery/screen/screen_image_full.dart';
import 'package:gallery/util/logger.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

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

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        secondaryHeaderColor: Colors.orange,
        iconTheme: IconThemeData(color: Colors.white70)
      ),
      home: Home(),
      routes: {
        Routes.image_by_tag.name: (context) => ScreenImageByTag(),
        // Routes.image_by_search.name: (context) => ScreenImageBySearch(),
        // Routes.image_full_screen.name: (context) => ScreenFullImage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == Routes.image_full_screen.name) {
          return FadeRoute(settings: settings, builder: (context) => ScreenFullImage());
        }else if(settings.name == Routes.image_by_search.name) {
          return FadeRoute(settings: settings, builder: (context) => ScreenImageBySearch());
        }
      },
    );
  }
}
