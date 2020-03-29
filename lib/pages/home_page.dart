import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hellobooks/constant/constants.dart';
import 'package:hellobooks/model/data.dart';
import 'package:hellobooks/service/service.dart';
import 'package:hellobooks/widgets/Label.dart';

/// 首页(包含抽屉效果)
class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _launchPublishPage() {
    // TODO 跳转到发布新的出租信息
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      // 抽屉控件 Drawer: https://api.flutter.dev/flutter/material/Drawer-class.html
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                '用户名',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('订单'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('设置'),
            ),
          ],
        ),
      ),
      body: _HomePageBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _launchPublishPage,
        tooltip: '发布',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

/// 首页 Body 部分
class _HomePageBody extends StatefulWidget {
  @override
  __HomePageBodyState createState() => __HomePageBodyState();
}

class __HomePageBodyState extends State<_HomePageBody> {
  List<Product> _products = [];
  ProductServer _server;

  @override
  void initState() {
    super.initState();
    _server = ProductServer();
    _requestProducts();
  }

  /// 从接口请求列表数据
  Future<void> _requestProducts() async {
    try {
      var productList = await _server.requestProducts();
      setState(() {
        _products = productList;
      });
    } catch (e) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: _products.length,
        padding: const EdgeInsets.all(5.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (context, index) {
          return _BookCard(_products[index]);
        });
  }
}

/// 列表每个卡片 Widget
class _BookCard extends StatelessWidget {
  final Product _product;

  _BookCard(this._product);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        debugPrint("test");
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: CachedNetworkImage(
                imageUrl: _product.book.imgUrl,
                fit: BoxFit.contain,
                placeholder: (context, url) => Image.asset(
                  "res/images/img_loading.gif",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: BookPadding.linePadding,
                horizontal: BookPadding.cardPadding,
              ),
              child: Text(
                _product.book.name,
                style: Theme.of(context).textTheme.display1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: BookPadding.cardPadding,
                right: BookPadding.cardPadding,
                bottom: BookPadding.linePadding,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(_product.user.avatar),
                    backgroundColor: Colors.grey,
                    radius: 13.0,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: BookPadding.labelPadding,
                      ),
                      child: Text(
                        _product.user.username,
                        style: Theme.of(context).textTheme.display2,
                      ),
                    ),
                  ),
                  Label(_product.getTypeLabel()),
                  Text(
                    "${_product.book.price == 0 ? "" : "￥${_product.book.price}"}",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        elevation: 5.0,
      ),
    );
  }
}
