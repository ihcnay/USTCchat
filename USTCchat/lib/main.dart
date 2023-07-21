import 'package:flutter/material.dart';
import 'package:ustcchat/module/User.dart';
import 'package:ustcchat/net/Socket.dart';
import 'package:ustcchat/page/ChatPage.dart';
import 'package:ustcchat/page/LoginPage.dart';
import 'package:ustcchat/page/RegisterPage.dart';
import 'package:ustcchat/page/SettingHomePage.dart';

import 'module/Message.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Init_data_base();
  runApp(const StartApp());
}

class StartApp extends StatelessWidget {
  const StartApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, // 不显示右上角的 debug
        title: 'USTCchat',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // 注册路由表
        routes: {
          "/Init":(context) => const InitApp(),            //初始化路由
          "/Register":(context) => const RegisterPage()
        },
        home:const LoginPage(title: "登录"),
        );
  }
}

//完成账号输入后初始化
class InitApp extends StatefulWidget {
  const InitApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return _InitAppState();
  }
}

class _InitAppState extends State<InitApp> {
  late BaseSocketCS _socketCS;

  final List<Message> _messages = [];

  void createServer(int port) {
    _socketCS = SocketServer(port);
    initSocketCS();
  }

  void createClient(String address, int port) {
    _socketCS = SocketClient(address, port);
    initSocketCS();
  }

  void initSocketCS() {
    _socketCS.init();
    _socketCS.msgStream.stream.listen((msg) {
      debugPrint(msg.toJson().toString());
      setState(() {
        _messages.insert(0, msg);
      });
    });
  }

  void onSendMessage(String msgText, String meme) {
    var msgToUser = Message(Message.TYPE_USER, msgText, meme);
    var msgToMe = Message(Message.TYPE_ME, msgText, meme);
    _socketCS.send(msgToUser);
    setState(() {
      _messages.insert(0, msgToMe);
    });
  }

  void goToChatPage(BuildContext childContext) {
    Navigator.of(childContext).pushReplacement(MaterialPageRoute(
        builder: (context) => ChatPage(_messages, onSendMessage)));
  }

  @override
  void dispose() {
    super.dispose();
    _socketCS.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Socket IM",
      home: SettingHomePage(createServer, createClient, goToChatPage),
    );
  }
}
