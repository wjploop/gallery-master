import 'package:flutter/material.dart';
import 'package:gallery/util/logger.dart';

class SearchTextFiled extends StatefulWidget {
  final bool enable;


  final ValueChanged<String>? onSubmitted;

  final TextEditingController? editingController;

  const SearchTextFiled({Key? key, required this.enable, this.onSubmitted, this.editingController}) : super(key: key);

  @override
  State<SearchTextFiled> createState() => _SearchTextFiledState();
}

class _SearchTextFiledState extends State<SearchTextFiled> {
  TextEditingController? _editingController;

  bool showDeleteIcon = false;



  @override
  void initState() {
    super.initState();

    logger.i("search textFiled init && ${widget.editingController}");

    _editingController = widget.editingController;
    if (_editingController != null) {
      _editingController!.addListener(() {
        setState(() {
          showDeleteIcon = _editingController!.text.isNotEmpty;
        });
      });
    }
  }

  @override
  void dispose() {
    _editingController = null;
    logger.i("SearchTextFiled dispose && ${widget.editingController}");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        height: 36,
        child: TextField(
          enabled: widget.enable,
          onSubmitted: widget.onSubmitted,
          textAlignVertical: TextAlignVertical.center,
          textInputAction: TextInputAction.search,
          controller: _editingController,
          style: TextStyle(color: Colors.white70),
          cursorColor: Colors.white70,
          autofocus: true,
          decoration: InputDecoration(
              filled: true,
              fillColor: Theme.of(context).primaryColorDark,
              border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(30))),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: Theme.of(context).iconTheme.color,
              ),
              contentPadding: EdgeInsets.zero,
              hintText: "搜索",
              hintStyle: TextStyle(color: Colors.white24),
              suffixIcon: AnimatedOpacity(
                  opacity: showDeleteIcon ? 1 : 0,
                  duration: Duration(milliseconds: 200),
                  child: GestureDetector(
                      onTap: () {
                        _editingController?.clear();
                      },
                      child: Icon(
                        Icons.highlight_remove,
                        color: Theme.of(context).iconTheme.color,
                      ))),
              focusedBorder: null),
        ),
      ),
    );
  }
}
