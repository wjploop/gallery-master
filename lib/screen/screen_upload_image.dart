import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery/data/entity/resp_category.dart';
import 'package:image_picker/image_picker.dart';

import '../data/api/client.dart';

class ScreenUploadImage extends StatefulWidget {
  const ScreenUploadImage({Key? key}) : super(key: key);

  @override
  State<ScreenUploadImage> createState() => _ScreenUploadImageState();
}

class _ScreenUploadImageState extends State<ScreenUploadImage> {
  late ImagePicker _picker;

  List<String> paths = [];

  CategoryModel? currentCategory;

  List<CategoryModel> categories = [];

  late FixedExtentScrollController _fixedExtentScrollController;

  var pickerPos = 0;

  List<String> tags = [];

  @override
  void initState() {
    super.initState();

    Client().categories().then((value) => categories.addAll(value.data!));
    _picker = ImagePicker();
    _fixedExtentScrollController = FixedExtentScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _fixedExtentScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("上传壁纸"),
      ),
      body: Builder(builder: (context) {
        return Column(
          children: [
            SizedBox(
              height: 12,
            ),
            SizedBox(
              height: 200,
              child: CustomScrollView(
                scrollDirection: Axis.horizontal,
                slivers: [
                  SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                    return Dismissible(
                      key: Key(paths[index]),
                      direction: DismissDirection.down,
                      onDismissed: (dir) {
                        setState(() {
                          paths.removeAt(index);
                        });
                      },
                      background: Container(
                        color: Colors.red,
                        child: Icon(Icons.delete),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        width: 120,
                        child: Image.file(
                          File(paths[index]),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    );
                  }, childCount: paths.length)),
                  SliverToBoxAdapter(
                    child: Visibility(
                      visible: paths.length < 9,
                      child: Container(
                        width: 120,
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
                      ),
                    ),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Text(
                    "已选${paths.length}张，最多可选9张上传",
                    style: TextStyle(fontSize: 10),
                  )),
            ),
            MyDivider(),
            ListTile(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) => Wrap(
                          children: [
                            ListTile(
                              leading: Text("壁纸分类"),
                              trailing: TextButton(
                                onPressed: () {
                                  setState(() {
                                    currentCategory = categories[pickerPos];
                                  });
                                  Navigator.pop(context);
                                },
                                child: Text("确定"),
                              ),
                            ),
                            SizedBox(
                                height: 300,
                                child: CupertinoPicker(
                                    itemExtent: 35,
                                    onSelectedItemChanged: (pos) {
                                      pickerPos = pos;
                                    },
                                    children: categories
                                        .map((e) => Text(
                                              e.name!,
                                            ))
                                        .toList())),
                          ],
                        ));
              },
              leading: Icon(Icons.category),
              title: Text("壁纸分类"),
              trailing: Wrap(
                children: [
                  Text("${currentCategory == null ? "" : currentCategory!.name}"),
                  Icon(Icons.keyboard_arrow_right),
                ],
              ),
            ),
            MyDivider(),
            ListTile(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        alignment: Alignment.bottomCenter,
                        child: Material(
                          child: Wrap(
                            children: [
                              ListTile(
                                leading: Text("标签"),
                                trailing: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("确定"),
                                ),
                              ),
                              tagsWidget(),
                              TextField(
                                onSubmitted: (str) {
                                  setState(() {
                                    tags.add(str);
                                  });
                                },
                                autofocus: true,
                                decoration: InputDecoration(hintText: "多行标签请用换行分割"),
                              )
                            ],
                          ),
                        ),
                      );
                    });
              },
              leading: Icon(Icons.tag),
              title: Text("添加标签"),
              trailing: Icon(Icons.keyboard_arrow_right),
              subtitle: tagsWidget(),
            )
          ],
        );
      }),
    );
  }

  Widget tagsWidget() {
    return Wrap(
      children: tags
          .map((e) => TextButton(
              onPressed: () {
                setState(() {
                  tags.remove(e);
                });
              },
              child: Row(
                children: [Text(e), Icon(Icons.close)],
              )))
          .toList(),
    );
  }
}

class MyDivider extends StatelessWidget {
  const MyDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      indent: 15,
      endIndent: 15,
    );
  }
}
