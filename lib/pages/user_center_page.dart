import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hellobooks/helper/user_helper.dart';
import 'package:hellobooks/model/data.dart';
import 'package:hellobooks/service/service.dart';
import 'package:hellobooks/widgets/toast.dart';
import 'package:image_picker/image_picker.dart';

/// 用户个人中心页面
class UserCenterPage extends StatefulWidget {
  @override
  _UserCenterPageState createState() => _UserCenterPageState();
}

class _UserCenterPageState extends State<UserCenterPage> {
  User _curUser;

  @override
  void initState() {
    super.initState();
    _initUser();
  }

  Future<void> _initUser() async {
    var user = await UserHelper.getCurUser();
    setState(() {
      _curUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("个人中心"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: GestureDetector(
                onTap: () {
                  _displayPickImageDialog(context);
                },
                child: CircleAvatar(
                  backgroundImage: NetworkImage(_curUser.avatar?.url ?? ""),
                  backgroundColor: Colors.grey,
                  radius: 50.0,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListTile(
              leading: Icon(Icons.phone),
              title: Text(_curUser.username),
              onTap: () {
                BookToast.toast("手机号暂不支持修改");
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: RaisedButton(
              padding: EdgeInsets.symmetric(
                vertical: 15.0,
                horizontal: 100.0,
              ),
              child: Text("退出", style: TextStyle(fontSize: 16.0)),
              color: Colors.redAccent,
              textColor: Colors.white,
              onPressed: () {
                _alertLogout(context, logoutAction: () async {
                  await UserHelper.logOut();
                  Navigator.pop<bool>(context, true);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _displayPickImageDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('修改头像'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text("拍照"),
                  onTap: () {
                    _getImage(ImageSource.camera);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text("从相册选择"),
                  onTap: () {
                    _getImage(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  /// 从相册或者相机获取图片
  Future<void> _getImage(ImageSource imgSource) async {
    BookToast.toast("头像上传中...", isLong: true);
    var image = await ImagePicker.pickImage(source: imgSource);
    await _updateAvatar(image);
  }

  /// TODO 有 bug，更新完用户头像后应该更新所有已发布产品表中的 User 信息（以 json 格式保存）
  Future<void> _updateAvatar(File image) async {
    var userServer = UserServer();
    try {
      var bmobFile = await userServer.uploadAvatar(image);
      _curUser.avatar = bmobFile;
      await UserHelper.saveUser(_curUser);
      setState(() {});
      BookToast.toast("头像更新成功");
    } catch (e) {
      BookToast.toast("头像更新失败");
    }
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
