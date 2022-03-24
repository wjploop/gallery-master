import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gallery/data/entity/resp_upgrade.dart';
import 'package:gallery/util/logger.dart';
import 'package:path_provider/path_provider.dart';

import '../api/client.dart';

class Upgrader extends StatefulWidget {
  final Widget child;

  const Upgrader({Key? key, required this.child}) : super(key: key);

  @override
  _UpgraderState createState() => _UpgraderState();
}

class _UpgraderState extends State<Upgrader> {
  bool startDownload = false;
  double downloadValue = 0;

  @override
  void initState() {
    super.initState();
    Client().appVersion().then((value) {
      logger.i("show version $value");
      Version version = value.data!;
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text("有新版本更新"),
            content: Row(
              children: [Text("新版本:${version.versionName}"), Text("通知:${version.notice}")],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("忽略")),
              TextButton(
                  onPressed: () async {
                    logger.i("apk url : ${version.apkUrl}");
                    var path = (await getTemporaryDirectory()).path + "/" + "app_${version.versionCode}.apk";
                    setState(() {
                      startDownload = true;
                    });
                    await Client().shareDio.downloadUri(Uri.parse(version.apkUrl!), path,options: Options(
                      contentType: ContentType.binary.mimeType,
                      headers: {

                      }
                    ), onReceiveProgress: (count, total) {
                      logger.i("download process $count / $total");
                      double process = count / total;
                      setState(() {
                        downloadValue = process;
                      });
                    },);
                  },
                  child: Text("更新")),
              Visibility(
                  visible: startDownload,
                  child: LinearProgressIndicator(
                    value: downloadValue,
                  ))
            ],
          );
        }),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.child,
    );
  }
}