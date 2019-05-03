import 'package:flutter/material.dart';
import 'package:pro/data/constants.dart' as constants;

class ChatMessage extends StatelessWidget {
  final String content;
  final String name;
  final String senderID;
  final String avatar;

  ChatMessage({
    this.content,
    this.name,
    this.senderID,
    this.avatar
  });

  Map<String,dynamic> toMap(){
    var map = new Map<String, dynamic>();
    map[constants.messageContent] = content;
    map[constants.messageSender] = name;
    map[constants.messagSenderID] = senderID;
    map[constants.messageAvatar] = avatar;
    map['sent'] = DateTime.now().millisecondsSinceEpoch;

    return map;
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: new CircleAvatar(
              child: new Image.network(avatar),
              ),
          ),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(name, style: Theme.of(context).textTheme.subhead),
              new Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: new Text(" " + content, style: TextStyle(color: Colors.black54),),

              )
            ],
          )
        ],
      )
    );
  }
  
}