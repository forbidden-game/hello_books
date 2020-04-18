import 'package:flutter/material.dart';
import 'package:hellobooks/constant/constants.dart';
import 'package:hellobooks/helper/user_helper.dart';
import 'package:hellobooks/service/service.dart';
import 'package:hellobooks/widgets/toast.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("登录"),
      ),
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(BookPadding.pagePadding),
        child: Container(
          child: _LoginFormWidget((userName, password) {
            _login(userName, password);
          }),
        ),
      ),
    );
  }

  Future<void> _login(String userName, String password) async {
    var server = UserServer();
    try {
      // 登录成功后，将用户信息序列化保存到本地，以后都从本地获取当前用户对象
      var bmobUser = await server.login(userName, password);
      var user = await server.getUser(bmobUser.objectId);
      await UserHelper.saveUser(user);
      Navigator.pop<bool>(context, true);
    } catch (e) {
      BookToast.toast("登录失败 ${e.toString()}");
    }
  }
}

/// 登录表单
class _LoginFormWidget extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController pwdController = TextEditingController();
  final GlobalKey formKey = GlobalKey<FormState>();
  final Function(String, String) onLoginClick;

  _LoginFormWidget(this.onLoginClick);

  @override
  Widget build(BuildContext context) {
    return Form(
      //设置globalKey，用于后面获取FormState
      key: formKey,
      //开启自动校验
      autovalidate: true,
      child: Column(
        children: <Widget>[
          TextFormField(
              autofocus: false,
              keyboardType: TextInputType.number,
              //键盘回车键的样式
              textInputAction: TextInputAction.next,
              controller: nameController,
              decoration: InputDecoration(
                hintText: "用户名",
                icon: Icon(Icons.person),
              ),
              // 校验用户名
              validator: (v) {
                return v.trim().length > 0 ? null : "用户名不能为空";
              }),
          TextFormField(
              autofocus: false,
              controller: pwdController,
              decoration: InputDecoration(
                hintText: "密码",
                icon: Icon(Icons.lock),
              ),
              obscureText: true,
              //校验密码
              validator: (v) {
                return v.trim().length > 5 ? null : "密码不能少于6位";
              }),
          // 登录按钮
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    padding: EdgeInsets.all(15.0),
                    child: Text("登录", style: TextStyle(fontSize: 16.0)),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: () {
                      // 通过_formKey.currentState 获取FormState后，
                      // 调用validate()方法校验用户名密码是否合法，校验通过后再提交数据。
                      if ((formKey.currentState as FormState).validate()) {
                        onLoginClick(nameController.text, pwdController.text);
                      }
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
