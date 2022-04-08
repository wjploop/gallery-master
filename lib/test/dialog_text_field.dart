import 'dart:math';

import 'package:flutter/material.dart';

final Color darkBlue = Color.fromARGB(255, 18, 32, 47);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: darkBlue),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: MyWidget(),
        ),
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
          // !!! Important part > to disable default scaffold insets
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text("Appbar Title"),
          ),
          body: Stack(
            children: [
              Scrollbar(
                child: ListView.builder(
                  padding: EdgeInsets.all(0.0),
                  itemCount: 30,
                  itemBuilder: (context, i) {
                    return Container(
                      height: 100,
                      width: double.infinity,
                      color: Colors
                          .primaries[Random().nextInt(Colors.primaries.length)],
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: AnimatedPadding(
                    padding: MediaQuery.of(context).viewInsets,
                    // You can change the duration and curve as per your requirement:
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.decelerate,
                    child: InputField()),
              )
            ],
          )),
    );
  }
}

class InputField extends StatefulWidget {
  InputField({Key? key}) : super(key: key);

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Icon(Icons.add_a_photo),
          ),
          Flexible(
            child: TextField(
              style: Theme.of(context).textTheme.bodyText1,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter text...',
              ),
            ),
          ),
          SizedBox(
            width: 60,
            child: Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}