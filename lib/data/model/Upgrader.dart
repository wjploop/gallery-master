import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gallery/data/entity/resp_upgrade.dart';
import 'package:gallery/data/model/device.dart';
import 'package:gallery/util/logger.dart';
import 'package:my_plugin/my_plugin.dart';
import 'package:path_provider/path_provider.dart';

import '../api/client.dart';

class Upgrader extends StatefulWidget {
  final Widget child;

  const Upgrader({Key? key, required this.child}) : super(key: key);

  @override
  _UpgraderState createState() => _UpgraderState();
}

class _UpgraderState extends State<Upgrader> {
  double downloadValue = 0;

  UpgradeStatus status = UpgradeStatus.showUpdate;

  var apkPath = "";

  @override
  void initState() {
    super.initState();
    Client().appVersion().then((value) {
      logger.i("version data: $value");
      Version version = value.data!;
      status = UpgradeStatus.showUpdate;

      int currentVersionCode = int.parse(Device().packageInfo.buildNumber);
      logger.i("version current: $currentVersionCode , server version: ${version.versionCode}");
      if (version.versionCode! <= currentVersionCode) {
        return;
      }
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: AlertDialog(
              title: Text(
                "发现新版本",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              content: Wrap(
                children: [
                  Column(
                    children: [
                      Visibility(visible: status == UpgradeStatus.showUpdate, child: Text("${version.notice?.replaceAll("\\n", "\n")},")),
                      Visibility(
                        visible: status.index >= UpgradeStatus.downloading.index,
                        child: Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Stack(
                            children: [
                              Visibility(
                                  visible: status == UpgradeStatus.downloading,
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Text("下载中，请稍候~"),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        LinearProgressIndicator(
                                          value: downloadValue,
                                        ),
                                      ],
                                    ),
                                  )),
                              Visibility(visible: status == UpgradeStatus.completed_downloaded, child: Text("下载完成啦～"))
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              actions: [
                Visibility(
                  visible: status == UpgradeStatus.showUpdate && !version.forceUpgrade!,
                  child: TextButton(
                    child: Text("下次"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Visibility(
                  visible: status == UpgradeStatus.showUpdate,
                  child: TextButton(
                    child: Text("急速更新"),
                    onPressed: () async {
                      logger.i("apk url : ${version.apkUrl}");
                      apkPath = (await getTemporaryDirectory()).path + "/" + "app_${version.versionCode}.apk";
                      setState(() {
                        status = UpgradeStatus.downloading;
                      });
                      await Client().shareDio.downloadUri(
                        Uri.parse(version.apkUrl!),
                        apkPath,
                        options: Options(),
                        onReceiveProgress: (count, total) {
                          logger.i("download process $count / $total");
                          double process = count / total;
                          setState(() {
                            downloadValue = process;
                          });
                          if (count == total) {
                            status = UpgradeStatus.completed_downloaded;
                          }
                        },
                      );
                    },
                  ),
                ),
                Visibility(
                    visible: status == UpgradeStatus.completed_downloaded,
                    child: TextButton(
                      child: Text("开始安装"),
                      onPressed: () {
                        MyPlugin.installApp(apkPath);
                      },
                    ))
              ],
            ),
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

enum UpgradeStatus {
  showUpdate,
  downloading,
  completed_downloaded,
}
