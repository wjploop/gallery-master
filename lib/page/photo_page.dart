import 'dart:io';

import 'package:action_broadcast/action_broadcast.dart';
import 'package:flutter/material.dart';
import 'package:gallery/component/my_cache_image.dart';
import 'package:gallery/data/model/ImagePageModel.dart';
import 'package:gallery/data/model/device.dart';
import 'package:gallery/data/model/my_cache_manger.dart';
import 'package:gallery/util/logger.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:plugin/plugin.dart';
import 'package:wallpaper/wallpaper.dart';

import '../data/api/client.dart';
import '../data/entity/resp_tag.dart';
import '../screen/routes.dart';

class PhotoPage extends StatefulWidget {
  final ImagePageModel model;
  final int initialPage;

  const PhotoPage({Key? key, required this.model, required this.initialPage}) : super(key: key);

  @override
  _PhotoPageState createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  late PageController _controller;

  List<Tag> tags = [];

  bool showDetail = false;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: widget.initialPage);
    logger.i("photo page init");
    getTags(widget.initialPage);
  }

  void getTags(int index) {
    Client().tagsByImageId(widget.model.items[index].id!).then((value) {
      if (mounted) {
        setState(() {
          tags.clear();
          tags.addAll(value.data!);
          logger.i("get tags $tags");
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    var items = widget.model.items;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: AnimatedOpacity(
            opacity: showDetail ? 1.0 : 0.0,
            duration: Duration(milliseconds: 500),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            )),
      ),
      body: PageView.builder(
          scrollDirection: Axis.vertical,
          controller: _controller,
          itemCount: items.length,
          onPageChanged: (page) {
            getTags(page);
          },
          itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  setState(() {
                    showDetail = !showDetail;
                  });
                },
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: items[index].id!,
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(Device().screenInfo.arcRadius / Device().devicePixelRatio)),
                          child: MyCacheImage(
                            url: items[index].originUrl!,
                          )),
                    ),
                    Visibility(
                      visible: showDetail,
                      child: Stack(alignment: Alignment.bottomLeft, children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 30),
                          width: double.maxFinite,
                          child: Column(
                            verticalDirection: VerticalDirection.up,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return Wrap(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(horizontal: 22, vertical: 20),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "设为壁纸",
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        buildButton(Icons.desktop_mac, "设为桌面", () async {
                                                          Wallpaper.imageDownloadProgress(items[index].originUrl!).listen((event) {
                                                            logger.i(event);
                                                          }).onDone(() {
                                                            Wallpaper.bothScreen();
                                                            logger.i("done");
                                                          });
                                                        }),
                                                        buildButton(Icons.phonelink_lock_rounded, "设为锁屏", () {
                                                          logger.i("device ${Device().width},${Device().height}");
                                                          MyCacheManager().getSingleFile(items[index].originUrl!).then((value) => {logger.i("current file $value")});
                                                        }),
                                                        buildButton(Icons.download_rounded, "下载壁纸", () async {
                                                          var file = File("");
                                                          logger.i("${file.absolute}");
                                                          var f = await MyCacheManager().getSingleFile(items[index].originUrl!);
                                                          logger.i("file ${f.basename}");

                                                          // f.copy(path.join(Device().pictureDir.path, f.basename));

                                                          var status = await Permission.storage.status;
                                                          if (status.isDenied) {
                                                            Permission.storage.request();
                                                          }
                                                          if (status.isGranted) {
                                                            // var picDir = "/sdcard/Pictures/";
                                                            var dir = Directory("/storage/emulated/0/Pictures");
                                                            if (!await dir.exists()) {
                                                              await dir.create();
                                                            }

                                                            var dist = path.join(dir.path, f.basename);
                                                            f.copySync(dist);

                                                            logger.i("copy to $dist");
                                                            Plugin.notify_system_gallery_has_new_picture();
                                                          }
                                                        }),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty.resolveWith((states) => EdgeInsets.symmetric(horizontal: 80, vertical: 12)),
                                      shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20)))),
                                      backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.yellow.shade700)),
                                  child: Text(
                                    "设为壁纸",
                                    style: TextStyle(color: Colors.white),
                                  )),
                              SizedBox(
                                width: double.maxFinite,
                                child: SingleChildScrollView(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 40),
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: tags
                                        .map((e) => Container(
                                              margin: EdgeInsets.symmetric(horizontal: 6),
                                              child: Material(
                                                color: Colors.blueGrey.withOpacity(0.5).withAlpha(120),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(22))),
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).pushNamed(Routes.image_by_tag.name, arguments: e);
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                                    child: Text(
                                                      e.name!,
                                                      style: TextStyle(fontSize: 12, color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              )),
    );
  }

  Widget buildButton(IconData icon, String text, VoidCallback onPress) {
    return Material(
      shape: CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPress,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(icon),
              SizedBox(
                height: 10,
              ),
              Text(text)
            ],
          ),
        ),
      ),
    );
  }
}
