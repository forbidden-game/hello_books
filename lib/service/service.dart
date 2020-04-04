import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:hellobooks/model/data.dart';

/// 产品 Server 类，主要用于产品相关的接口请求
class ProductServer {
  /// 产品对应的数据库表名
  static const String tableName = "product";

  Future<List<Product>> requestProducts() async {
    var bmobQuery = BmobQuery();
    var products = await bmobQuery.queryObjectsByTableName(tableName);
    var productList = products.map((e) => Product.fromJson(e)).toList();
    return productList;
  }
}

/// 用户相关 Server 类，用于用户登录注册相关接口请求
class UserServer {
  /// 用户对应的数据库表名
  static const String tableName = "_User";

  Future<BmobUser> login(String userName, String pwd) async {
    var originUser = User()
      ..username = userName
      ..password = pwd;
    var bmobUser = await originUser.login();
    return bmobUser;
  }

  Future<User> getUser(String userId) async {
    var bmobQuery = BmobQuery();
    var jsonMap = await bmobQuery.queryUser(userId);
    var user = User.fromJson(jsonMap);
    return user;
  }
}
