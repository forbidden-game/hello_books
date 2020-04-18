import 'package:data_plugin/bmob/bmob.dart';
import 'package:flutter/material.dart';
import 'package:hellobooks/pages/user_center_page.dart';
import 'constant/constants.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/publish_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Bmob.init("https://api2.bmob.cn", "74f5b87c766b555aa8c54a64e8d0b342",
        "67d52147a92f3a55c40765ff86f355c7");
    return MaterialApp(
      title: '租书吧',
      theme: ThemeData(
        primaryColor: Colors.blue,
        cardColor: Colors.white,
        buttonColor: Colors.lightBlue,
        dividerColor: BookColors.dividerColor,
        textTheme: TextTheme(
          headline: TextStyle(
            color: BookColors.textBlack,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
          // 单列表标题
          title: TextStyle(
            color: BookColors.textBlack,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
          // 单列表副标题
          subtitle: TextStyle(
            color: BookColors.textGrey,
            fontSize: 13.0,
            fontWeight: FontWeight.normal,
          ),
          // 页面内容
          body1: TextStyle(
            color: BookColors.textBlack,
            fontSize: 13.0,
            fontWeight: FontWeight.normal,
          ),
          // 页面副内容
          body2: TextStyle(
            color: BookColors.textGrey,
            fontSize: 13.0,
            fontWeight: FontWeight.normal,
          ),
          // Card 标题
          display1: TextStyle(
            color: BookColors.textBlack,
            fontSize: 13.0,
            fontWeight: FontWeight.normal,
          ),
          // Card 副标题
          display2: TextStyle(
            color: BookColors.textGrey,
            fontSize: 12.0,
            fontWeight: FontWeight.normal,
          ),
          // Hint 提示
          display3: TextStyle(
            color: BookColors.hintColor,
            fontSize: 12.0,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      home: HomePage(title: "租书吧"),
      routes: {
        'loginRoute': (BuildContext context) => LoginPage(),
        'publishRoute': (BuildContext context) => PublishPage(),
        'userCenterRoute': (BuildContext context) => UserCenterPage(),
      },
    );
  }
}
