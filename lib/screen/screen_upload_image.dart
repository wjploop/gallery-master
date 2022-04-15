import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery/data/entity/resp_category.dart';
import 'package:image_picker/image_picker.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../component/my_tip_dialog.dart';
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

  bool agree = true;

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

  void submit(){
    if(paths.isEmpty) {
      Tip.info(context, "请添加上传的图片");
      return;
    }
    if(currentCategory == null) {
      Tip.info(context, "请为图片选择壁纸分类");
      return;
    }
    if(agree == false) {
      Tip.info(context, "同意《协议》方可上传哦");
      return;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("上传壁纸"),
      ),
      body: Builder(builder: (context) {
        return Stack(
          children: [
            Column(
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
                        "已选图片(${paths.length}/9)",
                        style: TextStyle(fontSize: 10),
                      )),
                ),
                MyDivider(),
                ListTile(
                  onTap: () {
                    showModalBottomSheet(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                        context: context,
                        builder: (context) => Wrap(
                              children: [
                                ListTile(
                                  leading: Text(
                                    "壁纸分类",
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
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
                                MyDivider(),
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
                          print('tags ${tags}');
                          TextEditingController _editingController = TextEditingController();

                          List<String> copyTags = List.from(tags);
                          return StatefulBuilder(
                            builder: (context, _setState) => WillPopScope(
                              onWillPop: () async {
                                FocusScope.of(context).unfocus();
                                if (FocusScope.of(context).hasFocus) {
                                  await Future.delayed(Duration(milliseconds: 200));
                                }
                                return true;
                              },
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: AnimatedPadding(
                                  padding: MediaQuery.of(context).viewInsets,
                                  duration: Duration(milliseconds: 100),
                                  child: Material(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                                    child: Wrap(
                                      children: [
                                        Stack(
                                          children: [
                                            Positioned.fill(
                                              child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 16),
                                                    child: Wrap(
                                                      crossAxisAlignment: WrapCrossAlignment.center,
                                                      children: [
                                                        Text(
                                                          "标签",
                                                          style: Theme.of(context).textTheme.titleMedium,
                                                        ),
                                                        SizedBox(
                                                          width: 15,
                                                        ),
                                                        Text(
                                                          "已添加（${copyTags.length}/5）",
                                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                                                        )
                                                      ],
                                                    ),
                                                  )),
                                            ),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Padding(
                                                padding: const EdgeInsets.only(right: 8.0),
                                                child: TextButton(
                                                    onPressed: () async {
                                                      FocusScope.of(context).unfocus();
                                                      if (FocusScope.of(context).hasFocus) {
                                                        // await Future.delayed(Duration(milliseconds: 100));
                                                      }
                                                      setState(() {
                                                        tags = List.from(copyTags);
                                                      });
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text("确定")),
                                              ),
                                            ),
                                          ],
                                        ),
                                        MyDivider(),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: TagsWidget(
                                              tags: copyTags,
                                              onTap: (tag) {
                                                _setState(() {
                                                  copyTags.remove(tag);
                                                });
                                              }),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                          child: TextField(
                                            controller: _editingController,
                                            textInputAction: TextInputAction.next,
                                            onEditingComplete: () {
                                              _setState(() {
                                                if (copyTags.length < 5) {
                                                  copyTags.add(_editingController.text);
                                                  _editingController.clear();
                                                } else {
                                                  showTopSnackBar(context, CustomSnackBar.info(message: "最多可以添加5个标签"));
                                                }
                                              });
                                            },
                                            autofocus: true,
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(8),
                                            ],
                                            decoration: InputDecoration(
                                              hintText: "多行标签请用换行分割",
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                  },
                  leading: Icon(Icons.tag),
                  title: Text("添加标签"),
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
                SizedBox(
                  height: 4,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TagsWidget(
                          tags: tags,
                          onTap: (tag) {
                            setState(() {
                              tags.remove(tag);
                            });
                          })),
                ),
              ],
            ),
            Positioned.fill(
                child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: 30),
                child: Wrap(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Checkbox(
                            visualDensity: VisualDensity.compact,
                            shape: CircleBorder(),
                            value: agree,
                            onChanged: (b) {
                              setState(() {
                                agree = b ?? false;
                              });
                            },
                          ),
                          Text("我已同意并阅读 "),
                          Text(
                            "协议",
                            style: TextStyle(color: Theme.of(context).primaryColor),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: submit,
                      child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 30),
                          width: double.maxFinite,
                          height: 40,
                          decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.all(Radius.circular(16))),
                          child: Center(child: Text("提交审核",style: TextStyle(color: Colors.white,fontSize: 18),),)),
                    ),
                  ],
                ),
              ),
            ))
          ],
        );
      }),
    );
  }
}

class TagsWidget extends StatelessWidget {
  final List<String> tags;

  final ValueChanged<String> onTap;

  const TagsWidget({Key? key, required this.tags, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      alignment: WrapAlignment.start,
      children: tags
          .map((e) => Chip(
                backgroundColor: Theme.of(context).primaryColor,
                visualDensity: VisualDensity.compact,
                label: Text(
                  e,
                  style: TextStyle(color: Colors.white),
                ),
                deleteIcon: Icon(
                  Icons.close,
                  size: 14,
                  color: Colors.white,
                ),
                onDeleted: () {
                  onTap(e);
                },
              ))
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
