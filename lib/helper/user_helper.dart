import 'dart:convert';

import 'package:hellobooks/model/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserHelper {
  // Bmob 在登录成功后保存用户时，key 使用的 user，这里就不适用 user 了
  static const keyUser = "curUser";
  static const keyHobbies = "hobbies";
  static const keyFavorites = "favorites";

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

  /// 把用户对图书的偏爱保存起来
  static Future<void> hobby(String bookCategory, int increase) async {
    var prefs = await SharedPreferences.getInstance();
    var curHobbiesMap = await getHobbies();
    curHobbiesMap[bookCategory] = (curHobbiesMap[bookCategory] ?? 0) + increase;
    await prefs.setString(keyHobbies, jsonEncode(curHobbiesMap));
  }

  /// 把用户对图书取消偏爱保存起来
  static Future<void> unHobby(String bookCategory, int decrease) async {
    var prefs = await SharedPreferences.getInstance();
    var curHobbiesMap = await getHobbies();
    var oldValue = curHobbiesMap[bookCategory] ?? 0;
    curHobbiesMap[bookCategory] = oldValue > decrease ? oldValue - decrease : 0;
    await prefs.setString(keyHobbies, jsonEncode(curHobbiesMap));
  }

  /// 获取当前用户的读书偏好
  static Future<Map<String, dynamic>> getHobbies() async {
    try {
      var prefs = await SharedPreferences.getInstance();
      var hobbies = prefs.get(keyHobbies);
      var hobbiesMap = jsonDecode(hobbies);
      return hobbiesMap;
    } catch (e) {
      return {};
    }
  }

  /// 保存用户收藏
  static Future<void> favorite(String productId) async {
    var prefs = await SharedPreferences.getInstance();
    var curFavorites = await getFavorites();
    curFavorites.add(productId);
    await prefs.setString(keyFavorites, jsonEncode(curFavorites));
  }

  /// 取消收藏
  static Future<void> unFavorite(String productId) async {
    var prefs = await SharedPreferences.getInstance();
    var curFavorites = await getFavorites();
    curFavorites.remove(productId);
    await prefs.setString(keyFavorites, jsonEncode(curFavorites));
  }

  /// 获取当前的所有收藏
  /// TODO 应该用 Set 而不是 List
  static Future<List<dynamic>> getFavorites() async {
    try {
      var prefs = await SharedPreferences.getInstance();
      var favorites = prefs.get(keyFavorites);
      var favoritesMap = jsonDecode(favorites);
      return favoritesMap;
    } catch (e) {
      return [];
    }
  }
}
