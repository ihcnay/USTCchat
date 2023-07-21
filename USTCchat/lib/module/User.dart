//用户数据类型

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

late final Database database;

late final path;

//初始化数据库
Future<int> Init_data_base() async {
  print('createing databse');
  path = join(await getDatabasesPath(), 'user_database.db');
  database = await openDatabase(
    path,
    version: 1,
  );
  database.execute('CREATE TABLE users(userid INTEGER, username TEXT PRIMARY KEY, password TEXT)');
  print("Successfully created a database");
  return 1;
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
  print("inserting data");
  final db = await database;

  db.insert(
    'users',
    user.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
  print("insert succeed");
}
//获取包含所有用户的列表
Future<List<User>> users() async {
  final db = database;
  final List<Map<String, dynamic>> maps = await db.query('users');

  return List.generate(maps.length, (i) {
    return User(
      userid: maps[i]['userid'],
      username: maps[i]['username'],
      password: maps[i]['password'],
    );
  });
}

//读取数据库元素,id为-1表示未找到
Future<User> getUser(String username) async {
  List<User> alluser = await users();
  var result = [];
  for (var item in alluser){
    if(item.username == username) {
      return item;
    }
  }
  return User(userid: -1, username: "username", password: "password");
}

//todo:修改数据库元素(必须已经存在)
Future<void> changePassword(String username, String password) async {}

//检验账号是否创建且密码是否正确,0表示存在且匹配,-1表示存在但不匹配,-2表示不存在
Future<int> isMatch(String username,String password) async {
  User user = await getUser(username);
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
