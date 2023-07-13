//用户数据类型

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

late final database;

//初始化数据库
void Init_data_base() async {
  database = openDatabase(
    join(await getDatabasesPath(), 'user_database.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE user(userid INTEGER PRIMARY KEY, username TEXT, password TEXT)',
      );
    },
    version: 1,
  );
}

//用户数据类型
class User {
  late final int userid;
  late final String username;
  late final String password;

  User({
    required this.userid,
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'userid': userid,
      'username': username,
      'password': password,
    };
  }

  @override
  String toString() {
    return 'User{userid:$userid,username: $username, password:$password}';
  }
}

//数据库中插入元素
Future<void> insertUser(User user) async {
  final db = await database;

  await db.insert(
    user.username,
    user.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

//读取数据库元素,id为-1表示未找到
Future<User> getUser(String username) async {
  Database db = await database;
  List<Map<String, dynamic>> result = await db.query(username);
  if (result == []) {
    return User(userid: -1, username: "username", password: "password");
  } else {
    return User(
        userid: result[0]['id'],
        username: result[0]['username'],
        password: result[0]['password']);
  }
}

//todo:修改数据库元素(必须已经存在)
Future<void> changePassword(String username, String password) async {}

//检验账号是否创建且密码是否正确,0表示存在且匹配,-1表示存在但不匹配,-2表示不存在
Future<int> isMatch(String username,String password)async{
  User user = getUser(username) as User;
  if(user.userid == -1) {
    return -2;
  }
  else{
    if(user.password != password){
      return -1;
    }
    else{
      return 0;
    }
  }
}
