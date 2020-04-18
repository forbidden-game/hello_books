import 'package:data_plugin/bmob/table/bmob_object.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:data_plugin/bmob/type/bmob_file.dart';

/// 书对象，对象需要继承 Bmob 的 BmobObject 对象
class Book extends BmobObject {
  final String name;
  final String desc; // 简介
  final int price; // 价格简单处理，直接设置为 int 类型
  final String category;
  final BmobFile picture;

  Book({
    this.name,
    this.desc,
    this.price,
    this.category,
    this.picture,
  }) : super();

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      name: json["name"],
      desc: json["desc"],
      price: json["price"],
      category: json["category"],
      picture:
          json["picture"] == null ? null : BmobFile.fromJson(json["picture"]),
    ).._fromJson(json);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        "name": name,
        "desc": desc,
        "price": price,
        "category": category,
        "picture": picture,
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

/// 从图书类型枚举到中文的映射
const _BookCategoryMap = {
  BookCategory.computer: "计算机",
  BookCategory.philosophy: "哲学",
  BookCategory.economics: "经济学",
  BookCategory.literature: "文学",
  BookCategory.art: "艺术",
  BookCategory.science: "自然科学",
  BookCategory.unknown: "其他"
};

/// 通过扩展函数的方式，完成从图书类型枚举到中文间的转换
extension TransferCategory on BookCategory {
  String convertToChinese() => _BookCategoryMap[this];

  BookCategory fromChinese(String chinese) {
    BookCategory category;
    _BookCategoryMap.forEach((key, value) {
      if (value == chinese) {
        category = this;
      }
    });
    return category ?? BookCategory.unknown;
  }
}

/// 用户对象
class User extends BmobUser {
  final BmobFile avatar;

  User({this.avatar}) : super();

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      avatar: json["avatar"] == null ? null : BmobFile.fromJson(json["avatar"]),
    ).._fromJson(json);
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
    return toJson();
  }
}

/// 商品类型，目前支持：交换、出租
enum ProductType { swap, rent }

const _ProductTypeMap = {ProductType.swap: "交换", ProductType.rent: "出租"};

/// 通过扩展函数的方式，完成从商品类型枚举到中文间的转换
extension TransferType on ProductType {
  String convertToChinese() => _ProductTypeMap[this];

  ProductType fromChinese(String chinese) {
    ProductType type;
    _ProductTypeMap.forEach((key, value) {
      if (value == chinese) {
        type = this;
      }
    });
    return type ?? ProductType.swap;
  }
}

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
