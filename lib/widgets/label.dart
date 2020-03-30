import 'package:flutter/material.dart';

/// 用于显示一些带背景的标签
class Label extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final double fontSize;

  Label(
    this.label, {
    Key key,
    this.backgroundColor = Colors.red,
    this.fontSize = 10.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 2.0),
      child: Text(
        label,
        style: TextStyle(color: Colors.white, fontSize: fontSize),
      ),
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(2.0))),
    );
  }
}
