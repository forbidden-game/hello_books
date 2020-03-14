import 'package:flutter/material.dart';

import 'pages/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '租书吧',
      theme: ThemeData(
        primaryColor: Colors.blue,
        cardColor: Colors.white,
        buttonColor: Colors.lightBlue,
        dividerColor: Color(0xFFE8E8E8),
        textTheme: TextTheme(
          headline: TextStyle(
            color: Color(0xFF222222),
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
          // Card 标题
          title: TextStyle(
            color: Color(0xFF222222),
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
          // Card 副标题
          subtitle: TextStyle(
            color: Color(0xFF999999),
            fontSize: 13.0,
            fontWeight: FontWeight.normal,
          ),
          // Card 内容
          body1: TextStyle(
            color: Color(0xFF222222),
            fontSize: 13.0,
            fontWeight: FontWeight.normal,
          ),
          // Card 副内容
          body2: TextStyle(
            color: Color(0xFF999999),
            fontSize: 13.0,
            fontWeight: FontWeight.normal,
          ),
          // 明显标签大提示
          display1: TextStyle(
            color: Color(0xFF222222),
            fontSize: 16.0,
            fontWeight: FontWeight.normal,
          ),
          // 明显标签小提示
          display2: TextStyle(
            color: Color(0xFF222222),
            fontSize: 13.0,
            fontWeight: FontWeight.normal,
          ),
          // 不明显标签小提示
          display3: TextStyle(
            color: Color(0xFFCCCCCC),
            fontSize: 12.0,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      home: HomePage(title: "租书吧"),
    );
  }
}
