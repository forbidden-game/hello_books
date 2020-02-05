import 'package:flutter/material.dart';

/// 首页
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
      body: ListView.builder(
        itemCount: 30,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.book),
            title: Text("《深入理解计算机系统》第$index版"),
            subtitle: Text("卡内基-梅隆、北京大学、清华大学、上海交通大学等国内外众多知名高校选用指定教材。"),
            trailing: Icon(Icons.arrow_forward_ios),
            contentPadding: EdgeInsets.all(10),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _launchPublishPage,
        tooltip: '发布',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
