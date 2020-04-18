import 'package:fluttertoast/fluttertoast.dart';

class BookToast {
  static void toast(String message, {bool isLong = false}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: isLong ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
    );
  }
}
