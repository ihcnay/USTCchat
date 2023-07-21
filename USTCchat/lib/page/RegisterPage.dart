import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ustcchat/module/User.dart';

late String Username = '';
late String Password = '';
late String Confirm_password = '';
int id_counter = 1;

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.blue,
      ),
      body: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const SizedBox(height: 60),
            buildUsernameField(), // 输入账号
            const SizedBox(height: 30),
            buildPasswordTextField(context), // 输入密码
            const SizedBox(height: 60),
            buildConfirmPasswordTextField(context), //确认密码
            const SizedBox(height: 40),
            buildOKbutton(context), // 确定按钮
          ],
        ),
      ),
    );
  }

  Widget buildTitle(String title) {
    return Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          title,
          style: const TextStyle(fontSize: 40),
        ));
  }

  Widget buildUsernameField() {
    return TextFormField(
        decoration: const InputDecoration(labelText: '账号'),
        onChanged: (v) => Username = v,
        validator: (v) {
          if (v!.isEmpty) {
            return '请输入账号';
          }
        });
  }

  Widget buildPasswordTextField(BuildContext context) {
    return TextFormField(
        decoration: const InputDecoration(labelText: '密码'),
        onChanged: (v) => Password = v,
        validator: (v) {
          if (v!.isEmpty) {
            return '请输入密码';
          }
        });
  }

  Widget buildConfirmPasswordTextField(BuildContext context) {
    return TextFormField(
        decoration: const InputDecoration(labelText: '确认密码'),
        onChanged: (v) => Confirm_password = v,
        validator: (v) {
          if (v!.isEmpty) {
            return '请再次输入密码';
          }
        });
  }

  Widget buildOKbutton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45,
        width: 270,
        child: ElevatedButton(
          style: ButtonStyle(
              // 设置圆角
              shape: MaterialStateProperty.all(const StadiumBorder(
                  side: BorderSide(style: BorderStyle.none)))),
          child: Text('注册',
              style: Theme.of(context).primaryTextTheme.headlineSmall),
          onPressed: () async {
            if (!isOK(Username, Password, Confirm_password)) {
            } else {
              User new_user = User(
                  userid: id_counter, username: Username, password: Password);
              id_counter++;
              await insertUser(new_user);
              Fluttertoast.showToast(
                  msg: "账号创建成功!即将跳转",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black45,
                  textColor: Colors.white,
                  fontSize: 16.0);
              Timer(const Duration(seconds: 3), () {
                Navigator.pop(context);           //延时执行的代码
              });
            }
          },
        ),
      ),
    );
  }

  //检查账号密码是否合理
  bool isOK(String username, String password, String confirm_password) {
    //todo:检查合理性
    if (username == "") {
      Fluttertoast.showToast(
          msg: "账号不能为空",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black45,
          textColor: Colors.white,
          fontSize: 16.0);
      return false;
    } else if (password == '') {
      Fluttertoast.showToast(
          msg: "密码不能为空",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black45,
          textColor: Colors.white,
          fontSize: 16.0);
      return false;
    } else if (confirm_password == '') {
      Fluttertoast.showToast(
          msg: "请输入确认密码",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black45,
          textColor: Colors.white,
          fontSize: 16.0);
      return false;
    } else if (password != confirm_password) {
      Fluttertoast.showToast(
          msg: "密码和确认密码不匹配",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black45,
          textColor: Colors.white,
          fontSize: 16.0);
      return false;
    }
    return true;
  }
}
