import 'package:flutter/widgets.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class Tip {
  static void info(BuildContext context, String message) {
    showTopSnackBar(context, CustomSnackBar.info(message: message));
  }
  static void error(BuildContext context, String message) {
    showTopSnackBar(context, CustomSnackBar.error(message: message));
  }
  static void success(BuildContext context, String message) {
    showTopSnackBar(context, CustomSnackBar.success(message: message));
  }
}
