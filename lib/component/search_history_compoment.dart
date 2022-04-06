import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:gallery/util/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryWidget extends StatefulWidget {
  final Function onSearch;

  const SearchHistoryWidget({Key? key, required this.onSearch}) : super(key: key);

  @override
  SearchHistoryWidgetState createState() => SearchHistoryWidgetState();
}

class SearchHistoryWidgetState extends State<SearchHistoryWidget> {
  static const String history_key = "sp_history";

  late SharedPreferences prefs;
  List<String> data = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      data = prefs.getStringList(history_key) ?? [];
    });
  }

  @override
  void dispose() {
    var saveData = data.sublist(0, min(100, data.length));
    logger.i("save data $saveData");
    prefs.setStringList(history_key, saveData);
    prefs.commit();
    super.dispose();
  }

  void add(String word) {
    if (data.contains(word)) {
      data.remove(word);
    }
    setState(() {
      data.insert(0, word);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomScrollView(
        slivers: [
          SliverFixedExtentList(
            delegate: SliverChildListDelegate(data
                .map((e) => ListTile(
                      onTap: () {
                        widget.onSearch(e);
                      },
                      leading: Icon(Icons.history),
                      title: Text(e),
                      trailing: IconButton(
                          onPressed: () {
                            setState(() {
                              data.remove(e);
                            });
                          },
                          icon: Icon(Icons.clear)),
                    ))
                .toList()),
            itemExtent: 35,
          ),
          SliverVisibility(
              visible: data.isNotEmpty,
              sliver: SliverToBoxAdapter(
                
                child: KeyboardVisibilityProvider(
                  child: Builder(
                    builder: (context)=>
                     GestureDetector(
                        onTap: () async {
                          FocusScope.of(context).unfocus();
                          // show dialog until keyboard fully hide
                          while(KeyboardVisibilityProvider.isKeyboardVisible(context)) {
                           await Future.delayed(Duration(milliseconds: 50));
                          }
                          showCupertinoDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    content: Text("历史记录清除之后无法恢复，是否清除全部记录"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("取消")),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            setState(() {
                                              data.clear();
                                            });
                                          },
                                          child: Text("清除")),
                                    ],
                                  ));
                        },
                        child: Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Center(child: Text("清除全部历史记录")))),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}

