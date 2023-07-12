import 'package:flutter/material.dart';

import '../components/MessageComponent.dart';
import '../module/Message.dart';

class ChatPage extends StatefulWidget {
  late final List<Message> _messages;
  late final Function(String msgText, String meme) _sendMsg;

  ChatPage(this._messages, this._sendMsg);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late TextEditingController _msgController;
  bool memeShown = false;

  @override
  void initState() {
    super.initState();
    _msgController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _msgController.dispose();
  }

  Widget getMemeComponent() {
    return Container(
      height: 200,
      child: SingleChildScrollView(
        child: Wrap(
          spacing: 16,
          runSpacing: 4,
          children: <Widget>[createMemeIcon("image/TestImage.jpg")],
        ),
      ),
    );
  }

  Widget createMemeIcon(String imageRes) {
    return GestureDetector(
      onTap: () {
        widget._sendMsg("", imageRes);
      },
      child: Image.asset(imageRes, width: 100, height: 100),
    );
  }

  Widget getInputPanel() {
    return Container(
      padding: const EdgeInsets.fromLTRB(4, 4, 0, 0),
      color: Colors.grey.shade300,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Flexible(
                  child: TextField(
                cursorColor: Colors.cyan,
                autofocus: true,
                controller: _msgController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(181, 255, 255, 255)
                    ),
              )),
              IconButton(                                    //表情按键
                  onPressed: () {},
                  icon: const Icon(Icons.face),
                  iconSize: 32,
                  color: Colors.purple.shade600),
              const SizedBox(width: 12, height: 0),
              IconButton(                                     //发送按键
                onPressed: () {
                  if (_msgController.text != "") {
                    widget._sendMsg(_msgController.text, "");
                    _msgController.clear();
                  }
                },
                icon: const Icon(Icons.send),
                iconSize: 32,
                color: Colors.lightBlueAccent,
              ),
              if (memeShown) getMemeComponent()
            ],
          )
        ],
      ),
    );
  }

  Widget getListView() {
    return ListView.builder(
      reverse: true,
      itemBuilder: (_, int index) {
        Message msg = widget._messages[index];
        return MessageComponent(msg);
      },
      itemCount: widget._messages.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: Column(children: <Widget>[
          Flexible(
            child:
                Padding(padding: const EdgeInsets.all(8), child: getListView()),
          ),
          getInputPanel()
        ]),
      ),
    );
  }
}
