import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery/component/my_cache_image.dart';
import 'package:gallery/data/constant/wallpaper_type.dart';
import 'package:gallery/data/model/ImagePageModel.dart';
import 'package:gallery/data/model/device.dart';
import 'package:gallery/data/model/my_cache_manger.dart';
import 'package:gallery/util/logger.dart';
import 'package:my_plugin/my_plugin.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
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


  bool showDetail = false;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: widget.initialPage);
    logger.i("photo page init");
    getTags(widget.initialPage);
  }

  void getTags(int index) {
    // Client().tagsByImageId(widget.model.items[index].id!).then((value) {
    //   if (mounted) {
    //     setState(() {
    //       tags.clear();
    //       tags.addAll(value.data!);
    //       logger.i("get tags $tags");
    //     });
    //   }
    // });
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
                          borderRadius: BorderRadius.all(Radius.circular(Device().screenInfo.connerRadius / Device().devicePixelRatio)),
                          child: MyCacheImage(
                            url: items[index].originUrl!,
                          )),
                    ),
                    Visibility(
                      visible: showDetail,
                      child: Stack(alignment: Alignment.bottomLeft, children: [
                        Positioned(
                          right: 0,
                          bottom: 200,
                          child: Column(
                            children: [
                              // buildRightButton(Image.asset("assets/images/collect_white.png"), "喜欢", () async {
                              //
                              // }),
                              buildRightButton(Image.asset("assets/images/share.png",color:Colors.white), "分享", () async {
                                var f = await MyCacheManager().getSingleFile(items[index].originUrl!);
                                MyPlugin.share(f.path);
                              }),
                              buildRightButton(Image.asset("assets/images/download.png",color: Colors.white,), "下载", () async {
                                var f = await MyCacheManager().getSingleFile(items[index].originUrl!);
                                var status = await Permission.storage.status;
                                if (status.isDenied) {
                                  status = await Permission.storage.request();
                                }
                                logger.i("check read storage status $status");
                                if (status.isGranted) {
                                  if (await File("/sdcard/Pictures/${f.basename}").exists()) {
                                    showTopSnackBar(context, GestureDetector(onTap: MyPlugin.openGallery, child: CustomSnackBar.info(message: "该图片已经存在于图库了哦，点击进入系统图库查看")));
                                    return;
                                  }
                                  logger.i("start insert ${f.path}");
                                  await MyPlugin.insertPictureToSystemGallery(f.path, f.basename);
                                  logger.i("insert ${f.path} to system gallery");
                                  showTopSnackBar(context, GestureDetector(onTap: MyPlugin.openGallery, child: CustomSnackBar.success(message: "下载成功，点击进入系统图库查看")));
                                } else {
                                  showTopSnackBar(context, CustomSnackBar.error(message: "未能获取到存储权限，无法下载图片哦，请手动授予【存储权限】"));
                                }
                              }),
                            ],
                          ),
                        ),
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
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))),
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
                                                        buildButton("assets/images/screen_home.png", "设为桌面", () async {
                                                          var f = await MyCacheManager().getSingleFile(items[index].originUrl!);
                                                          var res = await MyPlugin.setWallpaper(f.path, WallpaperType.system.index);
                                                          if(res) {
                                                            showTopSnackBar(context, CustomSnackBar.success(message: "设置桌面成功"));
                                                          }else{
                                                            showTopSnackBar(context, CustomSnackBar.error(message: "设置桌面失败"));
                                                          }
                                                        }),
                                                        buildButton("assets/images/screen_locked.png", "设为锁屏", () async {
                                                          var f = await MyCacheManager().getSingleFile(items[index].originUrl!);
                                                          var res = await MyPlugin.setWallpaper(f.path, WallpaperType.lock.index);
                                                          if(res) {
                                                            showTopSnackBar(context, CustomSnackBar.success(message: "设为锁屏成功"));
                                                          }else{
                                                            showTopSnackBar(context, CustomSnackBar.error(message: "设为锁屏失败"));
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
                                    children: items[index].tags
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

  Widget buildButton(String assetIcon, String text, VoidCallback onPress) {
    return Material(
      shape: CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () async {
          onPress();
          Navigator.of(context).pop();
        },
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                width: 40,
                  child: Image.asset(assetIcon)),
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

  Widget buildRightButton(Widget icon, String text, VoidCallback onPress) {
    return Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
      color: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () async {
          onPress();
        },
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                width: 35,
                  child: icon),
              SizedBox(
                height: 6,
              ),
              Text(text,style: TextStyle(color: Colors.white),)
            ],
          ),
        ),
      ),
    );
  }
}
