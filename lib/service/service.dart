import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:hellobooks/model/data.dart';

class ProductServer {
  Future<List<Product>> requestProducts() async {
    BmobQuery bmobQuery = BmobQuery();
    var products = await bmobQuery.queryObjectsByTableName("product");
    var productList = products.map((e) => Product.fromJson(e)).toList();
    return productList;
  }
}
