import 'package:flutter/material.dart';

class BookSnackBar {
  static void showSnackBar(BuildContext context, String message) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
