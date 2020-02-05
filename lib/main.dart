import 'package:flutter/material.dart';

import 'pages/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '租书吧',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: "租书吧"),
    );
  }
}
