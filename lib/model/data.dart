import 'package:data_plugin/bmob/table/bmob_object.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';

class Book extends BmobObject {
  final String name;
  final String desc; // 简介
  final String imgUrl;
  final int price; // 价格简单处理，直接设置为 int 类型
  final String category;

  Book({this.name, this.desc, this.imgUrl, this.price, this.category})
      : super();

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      name: json["name"],
      desc: json["desc"],
      imgUrl: json["imgUrl"],
      price: json["price"],
      category: json["category"],
    )..objectId = json['objectId'];
  }

  BookCategory get bookCategory => BookCategory.values.firstWhere(
        (category) => category.toString() == this.category,
        orElse: () => BookCategory.unknown,
      );

  @override
  Map getParams() {
    // TODO toJson()
    return null;
  }
}

/// 书目分类
enum BookCategory {
  computer,
  philosophy,
  economics,
  literature,
  art,
  science,
  unknown
}

class User extends BmobUser {
  final String avatar;

  User({this.avatar}) : super();

  factory User.fromJson(Map<String, dynamic> json) {
    return User(avatar: json["avatar"])
      ..objectId = json['objectId']
      ..username = json["username"];
  }

  @override
  Map getParams() {
    // TODO toJson()
    return null;
  }
}

/// 把用户发布的每一条信息（租书、换书）视为一个"产品"
/// 看上去 Bmob 的查询功能比较弱，除非写云函数，这里采用比较 low 的方式：
/// 避免表的联合查询，一个表中保存比较多的信息，获取到数据后再转为对应的 User 和 Book 对象
class Product extends BmobObject {
  final String bookId;
  final String userId;
  final String type;
  User _user;
  Book _book;

  Product({this.bookId, this.userId, this.type}) : super(); // 产品类型

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        bookId: json["bookId"], userId: json["userId"], type: json["type"])
      ..objectId = json["objectId"]
      .._user = (User(avatar: json["userAvatar"])
        ..objectId = json["userId"]
        ..username = json["userName"])
      .._book = (Book(
          name: json["bookName"],
          imgUrl: json["bookImgUrl"],
          price: json["bookPrice"],
          category: json["bookCategory"])
        ..objectId = json["bookId"]);
  }

  String getTypeLabel() => type == ProductType.swap.toString() ? "换" : "租";

  User get user => _user;

  set user(User value) {
    _user = value;
  }

  Book get book => _book;

  set book(Book value) {
    _book = value;
  }

  @override
  Map getParams() {
    // TODO: toJson()
    return null;
  }
}

/// 商品类型，目前支持：交换、出租
enum ProductType { swap, rent }
