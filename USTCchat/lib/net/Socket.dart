import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ustcchat/module/Message.dart';

//基类
class BaseSocketCS {
  var msgStream = StreamController<Message>();

  void init() async {}

  void send(Message msg) {}

  @mustCallSuper
  void dispose() {
    msgStream.close();
  }
}
//BaseSocketCS包含一条信息流msgStream，当Socket接收到信息后会将解析后的信息抛到msgStream
//上，上层业务会订阅这条信息（用来实时显示）

//服务器类
class SocketServer extends BaseSocketCS {
  late ServerSocket serverSocket;     //ServerSocket为Dart提供的服务器通信类，可实现Socket监听
  List<Socket> clients = [];          //连接到当前服务器的客户端
  int port;                           //监听端口号
  SocketServer(this.port);

  @override
  void init() async {
    ServerSocket.bind(InternetAddress.anyIPv4, port).then((bindSocket) {
      serverSocket = bindSocket;
      serverSocket.listen((clientSocket) {
        utf8.decoder.bind(clientSocket).listen((data) {
          msgStream.add(Message.fromJson(json.decode(data)));

        });                           //将二进制数据转换成字符串
        clients.add(clientSocket);
      });
    });
  }

  @override
  void send(Message msg) async {
    for (var client in clients) {
      client.add(utf8.encode(json.encode(msg)));
    }
  }

  @override
  void dispose(){
    super.dispose();
    for(var socket in clients){
      socket.close();
    }
    serverSocket.close();
  }
}


//客户端
class SocketClient extends BaseSocketCS{
  late Socket clientSocket;
  late String address;
  late int port;

  SocketClient(this.address,this.port);

  @override
  void init()async{
    clientSocket = await Socket.connect(address,port);
    utf8.decoder.bind(clientSocket).listen((data) {
      msgStream.add(Message.fromJson(json.decode(data)));
    });
  }

  @override
  void send(Message msg){
    clientSocket.add(utf8.encode(json.encode(msg)));
  }

  @override
  void dispose(){
    super.dispose();
    clientSocket.close();
  }
}