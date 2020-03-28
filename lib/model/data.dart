// 该文件存放业务层对应的数据结构

class Book {
  final int id;
  final String name;
  final String desc; // 简介
  final String imgUrl;
  final double price;
  String _category;

  Book({
    this.id,
    this.name,
    this.desc,
    this.imgUrl,
    this.price,
  });

  Book.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        desc = json["desc"],
        imgUrl = json["imgUrl"],
        price = json["price"] ?? 0.0,
        _category = json["category"];

  BookCategory getCategory() => BookCategory.values.firstWhere(
        (category) => category.toString() == _category,
        orElse: () => BookCategory.unknown,
      );
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

class User {
  final int id;
  final String avatar;
  final String name;
  final String phoneNumber;

  const User(
    this.id,
    this.avatar,
    this.name,
    this.phoneNumber,
  ) : assert(id != null);

  User.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        avatar = json["avatar"],
        name = json["name"],
        phoneNumber = json["phoneNumber"];
}

/// 把用户发布的每一条信息（租书、换书）视为一个"产品"
class Product {
  final int id;
  final Book book;
  final User user;
  final bool favorite; // 收藏
  final ProductType productType; // 产品类型

  Product(
    this.id,
    this.book,
    this.user,
    this.favorite,
    this.productType,
  );

  Product.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        book = Book.fromJson(json["book"]),
        user = User.fromJson(json["user"]),
        favorite = json["favorite"] ?? false,
        productType =
            json["productType"] == "swap" ? ProductType.swap : ProductType.rent;

  String getTypeLabel() => productType == ProductType.swap ? "换" : "租";
}

/// 商品类型，目前支持：交换、出租
enum ProductType { swap, rent }
