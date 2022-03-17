import 'package:flutter/material.dart';

class FadeRoute<T> extends MaterialPageRoute<T>{
  FadeRoute({required RouteSettings settings, required WidgetBuilder builder}) : super(builder: builder,settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(opacity: animation,child: child);
    // return child;
  }
}