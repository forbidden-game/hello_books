import 'package:data_plugin/bmob/table/bmob_object.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';

/// 书对象，对象需要继承 Bmob 的 BmobObject 对象
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
    ).._fromJson(json);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        "name": name,
        "desc": desc,
        "imgUrl": imgUrl,
        "price": price,
        "category": category,
      }..addAll(_toJson());

  BookCategory get bookCategory => BookCategory.values.firstWhere(
        (category) => category.toString() == this.category,
        orElse: () => BookCategory.unknown,
      );

  @override
  Map getParams() {
    return toJson();
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

/// 用户对象
class User extends BmobUser {
  final String avatar;

  User({this.avatar}) : super();

  factory User.fromJson(Map<String, dynamic> json) {
    return User(avatar: json["avatar"]).._fromJson(json);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        "avatar": avatar,
      }..addAll(_toJson());

  @override
  Map getParams() {
    return toJson();
  }
}

/// 把用户发布的每一条信息（租书、换书）视为一个"产品"
class Product extends BmobObject {
  final String bookId;
  final String userId;
  final String type;
  final User user;
  final Book book;

  Product({this.bookId, this.userId, this.type, this.user, this.book})
      : super();

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      bookId: json["bookId"],
      userId: json["userId"],
      type: json["type"],
      user: User.fromJson(json["user"]),
      book: Book.fromJson(json["book"]),
    ).._fromJson(json);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        "bookId": bookId,
        "userId": userId,
        "type": type,
        "user": user.toJson(),
        "book": book.toJson(),
      }..addAll(_toJson());

  String getTypeLabel() => type == ProductType.swap.toString() ? "换" : "租";

  @override
  Map getParams() {
    // TODO: toJson()
    return null;
  }
}

/// 商品类型，目前支持：交换、出租
enum ProductType { swap, rent }

/// 给 Bmob 基类对象添加扩展方法，以实现 json 序列化与反序列化
extension JsonParsing on BmobObject {
  void _fromJson(Map<String, dynamic> json) {
    objectId = json["objectId"];
    createdAt = json["createdAt"];
    updatedAt = json["updatedAt"];
  }

  Map<String, dynamic> _toJson() => <String, dynamic>{
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'objectId': objectId
      };
}

extension UserJsonParsing on BmobUser {
  void _fromJson(Map<String, dynamic> json) {
    objectId = json["objectId"];
    createdAt = json["createdAt"];
    updatedAt = json["updatedAt"];
    username = json['username'];
    password = json['password'];
    email = json['email'];
    emailVerified = json['emailVerified'];
    mobilePhoneNumber = json['mobilePhoneNumber'];
    mobilePhoneNumberVerified = json['mobilePhoneNumberVerified'];
    sessionToken = json['sessionToken'];
  }

  Map<String, dynamic> _toJson() => <String, dynamic>{
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'objectId': objectId,
        'username': username,
        'password': password,
        'email': email,
        'emailVerified': emailVerified,
        'mobilePhoneNumber': mobilePhoneNumber,
        'mobilePhoneNumberVerified': mobilePhoneNumberVerified,
        'sessionToken': sessionToken
      };
}
