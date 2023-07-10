//消息的数据类型

class Message{
  static const String TYPE_USER = "user";
  static const String TYPE_SYSTEM = "system";
  static const String TYPE_ME = "me";

  late final String from;           //消息来源
  late final String msg;            //文本内容
  late final String meme;           //表情

  Message(this.from,this.msg,this.meme);

  //将消息Json序列化
  Message.fromJson(Map<String,dynamic>json)
    :from = json['type'],
     msg = json['msg'],
     meme = json['meme'];

  Map<String,dynamic>toJson() => <String,dynamic>{
    'type':from,
    'msg':msg,
    'meme':meme
  };


}