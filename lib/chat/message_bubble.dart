import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(this.message,this.userId,this.userName,this.userImageUrl);
  final String message;
  final String userId;
  final String userName;
  final String userImageUrl;

  bool isMe()
  {
    final user = FirebaseAuth.instance.currentUser;
    if (user.uid == userId)
      return true;
    else
      return false;
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: isMe() ? MainAxisAlignment.end:MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isMe() ? Colors.grey[600]:Theme.of(context).accentColor,
                borderRadius: BorderRadius.circular(15),
              ),
              width: 120,
              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
              margin: EdgeInsets.symmetric(horizontal: 25,vertical: isMe()?5:15),
              child: Text(message,
              style: TextStyle(
                color: Theme.of(context).accentTextTheme.headline1.color,
              ),),
            ),
          ],
        ),
        if(!isMe())
        Positioned(
          top: -10,
          child: CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(userImageUrl)
          ),
        ),
        if(!isMe())
        Positioned(
          left: 55,
          top: -5,
          //bottom: MediaQuery.of(context).size.height,
          child: Text(userName),
        ),
      ],
      overflow:Overflow.visible,
    );
  }
}
