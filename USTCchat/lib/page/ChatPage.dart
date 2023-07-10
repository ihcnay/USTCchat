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

  Widget getInputPanel() {
    return Container(
      padding: const EdgeInsets.fromLTRB(4, 4, 0, 0),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Flexible(
                  child: TextField(
                autofocus: true,
                controller: _msgController,
              )),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.face),
                  iconSize: 32,
                  color: Colors.grey.shade600),
              const SizedBox(width: 12, height: 0),
              IconButton(
                onPressed: () {
                  widget._sendMsg(_msgController.text, "");
                  _msgController.clear();
                },
                icon: const Icon(Icons.send),
                iconSize: 32,
                color: Colors.grey.shade600,
              )
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
