import 'package:chat_app/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // ignore: deprecated_member_use
      stream:Firestore.instance.collection('chat').orderBy('createdAt',descending: true).snapshots(),
      builder: (context,chatSnapshot){
        if(chatSnapshot.connectionState == ConnectionState.waiting)
          {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        final chatDocs = chatSnapshot.data.docs;
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (context,index) => MessageBubble(
              chatDocs[index]['text'],
              chatDocs[index]['userId'],
              chatDocs[index]['userName'],
              chatDocs[index]['imageUrl']),
        );
      });
  }
}
