import 'package:flutter/material.dart';
import 'package:hellobooks/constant/constants.dart';
import 'package:hellobooks/helper/user_helper.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("设置"),
      ),
      body: ListView(children: <Widget>[
        ListTile(
          leading: Icon(Icons.account_box),
          title: Text('修改密码'),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
        ListTile(
          leading: Icon(Icons.account_box),
          title: Text('收货地址'),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
        ListTile(
          onTap: () {
            _alertLogout(context, logoutAction: () async {
              await UserHelper.logOut();
              Navigator.pop<bool>(context, true);
            });
          },
          leading: Icon(Icons.exit_to_app, color: BookColors.alertColor),
          title: Text('退出登录', style: TextStyle(color: BookColors.alertColor)),
        ),
      ]),
    );
  }

  Future<void> _alertLogout(BuildContext context,
      {Function logoutAction}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('确认退出吗？'),
          actions: <Widget>[
            FlatButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('确认'),
              onPressed: () {
                Navigator.pop(context);
                logoutAction();
              },
            ),
          ],
        );
      },
    );
  }
}
