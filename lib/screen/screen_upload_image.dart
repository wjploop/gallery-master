import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ScreenUploadImage extends StatefulWidget {
  const ScreenUploadImage({Key? key}) : super(key: key);

  @override
  State<ScreenUploadImage> createState() => _ScreenUploadImageState();
}

class _ScreenUploadImageState extends State<ScreenUploadImage> {
  late ImagePicker _picker;

  List<String> paths = [];

  @override
  void initState() {
    super.initState();
    _picker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("上传壁纸"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 12,
          ),
          SizedBox(
            height: 200,
            child: ReorderableListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 12),
                scrollDirection: Axis.horizontal,
                itemExtent: 120,
                itemCount: paths.length < 9 ? paths.length + 1 : paths.length,
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                      var item = paths.removeAt(oldIndex);
                      paths.insert(newIndex, item);
                    }
                  });
                },
                itemBuilder: (context, index) {
                  if (paths.length < 9 && index == paths.length) {
                    return Container(
                      key: ValueKey("add"),
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () async {
                          var files = await _picker.pickMultiImage();
                          if (files != null && files.isNotEmpty) {
                            files.map((e) => e.path).forEach((path) {
                              setState(() {
                                paths.add(path);
                              });
                            });
                          }
                        },
                        icon: Container(color: Theme.of(context).primaryColor, width: double.maxFinite, height: double.maxFinite, child: Icon(Icons.add)),
                        color: Colors.white,
                        iconSize: 60,
                      ),
                    );
                  } else {
                    return Container(
                      key: ValueKey(paths[index]),
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Image.file(
                        File(paths[index]),
                        fit: BoxFit.fitWidth,
                      ),
                    );
                  }
                }),
          ),
          SizedBox(
            height: 400,
            child: ReorderableListView.builder(
                scrollDirection: Axis.vertical,
                itemExtent: 100,
                itemBuilder: (context, index) => Container(
                      color: Colors.green,
                      height: double.maxFinite,
                      width: double.maxFinite,
                      key: ValueKey(index),
                      child: Text("index $index"),
                    ),
                itemCount: 10,
                onReorder: (o, n) {}),
          )
        ],
      ),
    );
  }
}
