import 'package:fluttertoast/fluttertoast.dart';

class BookToast {
  static void toast(String message) {
    Fluttertoast.showToast(msg: message);
  }
}
