import 'package:flutter/material.dart';

class TagInputPage extends StatelessWidget {
  const TagInputPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: 300,
        child: AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: Duration(milliseconds: 100),
          curve: Curves.decelerate,
          child: Container(
            color: Colors.black12,
            height: 200,
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
                  // tagsWidget(),
                  TextField(
                    onSubmitted: (str) {
                      // setState(() {
                      //   tags.add(str);
                      // });
                    },
                    autofocus: true,
                    decoration: InputDecoration(hintText: "多行标签请用换行分割"),
                  ),
                  Text("${WidgetsBinding.instance!.window.viewInsets.bottom}")
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
