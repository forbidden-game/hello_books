import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hellobooks/constant/constants.dart';
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
class _HomePageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: 10,
        padding: const EdgeInsets.all(5.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (context, index) {
          return _BookCard();
        });
  }
}

/// 列表每个卡片 Widget
class _BookCard extends StatelessWidget {
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
                imageUrl:
                    "https://img1.doubanio.com/view/subject/l/public/s29195878.jpg",
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
                "深入理解计算机系统",
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
                    backgroundImage: NetworkImage(
                        "http://5b0988e595225.cdn.sohucs.com/images/20180830/55833f7db8894d88b459588c33da5a19.jpeg"),
                    backgroundColor: Colors.grey,
                    radius: 13.0,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: BookPadding.labelPadding,
                      ),
                      child: Text(
                        "昵称",
                        style: Theme.of(context).textTheme.display2,
                      ),
                    ),
                  ),
                  Label("租"),
                  Text(
                    "￥2.0",
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
