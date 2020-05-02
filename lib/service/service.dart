import 'dart:io';

import 'package:data_plugin/bmob/bmob_file_manager.dart';
import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:data_plugin/bmob/response/bmob_registered.dart';
import 'package:data_plugin/bmob/response/bmob_saved.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:data_plugin/bmob/type/bmob_file.dart';
import 'package:hellobooks/model/data.dart';

/// 产品 Server 类，主要用于产品相关的接口请求
class ProductServer {
  /// 产品对应的数据库表名
  static const String tableName = "Product";

  Future<List<Product>> requestProducts() async {
    var bmobQuery = BmobQuery();
    // 按创建时间倒序(字段前加 - 号)排列
    bmobQuery.setOrder("-createdAt");
    var products = await bmobQuery.queryObjectsByTableName(tableName);
    var productList = products.map((e) => Product.fromJson(e)).toList();
    return productList;
  }

  Future<BmobSaved> uploadProduct(Product product) async {
    var saved = await product.save();
    return saved;
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

  Future<BmobRegistered> register(String userName, String pwd) async {
    var originUser = User()
      ..username = userName
      ..password = pwd;
    var bmobUser = await originUser.register();
    return bmobUser;
  }

  Future<User> getUser(String userId) async {
    var bmobQuery = BmobQuery();
    var jsonMap = await bmobQuery.queryUser(userId);
    var user = User.fromJson(jsonMap);
    return user;
  }

  /// 上传头像
  Future<BmobFile> uploadAvatar(File image) async {
    // 上传文件
    var bmobFile = await BmobFileManager.upload(image);
    return bmobFile;
  }
}

/// 书籍 Server 类，主要用于书籍相关的接口请求
class BookServer {
  /// 书籍对应的数据库表名
  static const String tableName = "Book";

  /// 先把图片上传，成功后可获得图片的 url
  Future<BmobFile> uploadBookPicture(File image) async {
    // 上传文件
    var bmobFile = await BmobFileManager.upload(image);
    return bmobFile;
  }

  /// 插入一条书籍记录
  Future<BmobSaved> uploadBook(Book book) async {
    // 上传文件
    var saved = await book.save();
    return saved;
  }
}
