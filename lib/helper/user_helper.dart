import 'dart:convert';

import 'package:hellobooks/model/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserHelper {
  // Bmob 在登录成功后保存用户时，key 使用的 user，这里就不适用 user 了
  static const keyUser = "curUser";

  /// 用户是否已经登录
  static Future<bool> get isLogin async => await getCurUser() != null;

  /// 登录，将当前用户序列化后保存
  static Future<void> saveUser(User user) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(keyUser, jsonEncode(user));
  }

  /// 退出，清空本地数据
  static Future<void> logOut() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(keyUser, "");
  }

  /// 通过反序列化本地保存信息，获取当前登录用户实例
  static Future<User> getCurUser() async {
    try {
      var prefs = await SharedPreferences.getInstance();
      var userString = prefs.get(keyUser);
      var user = User.fromJson(jsonDecode(userString));
      return user;
    } catch (e) {
      return null;
    }
  }
}
