import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Chat"),
        actions: <Widget>[
          DropdownButton(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.exit_to_app),
                        SizedBox(width: 10,),
                        Text("Logout"),
                      ],
                    ),
                  ),
                  value: 'logout',
              ),
            ],
            onChanged: (itemIdentifier){
              if(itemIdentifier == 'logout')
                {
                  FirebaseAuth.instance.signOut();
                }
            },
              ),
        ],
      ),
      body:StreamBuilder(
        stream: FirebaseFirestore.instance.collection('chat/9GRnrzf86je6OHExe3Qs/messages')
            .snapshots(),
        builder: (context, streamSnapshot){
          if(streamSnapshot.connectionState ==ConnectionState.waiting)
            {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          final document = streamSnapshot.data.docs;
           return ListView.builder(
                   itemCount: document.length,
                   itemBuilder: (buildContext ,index)=> Container(
                     padding: EdgeInsets.all(10),
                     child: Text(document[index]['text']),
                   ),
           );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: ()
        {
          FirebaseFirestore.instance.collection('chat/9GRnrzf86je6OHExe3Qs/messages').add({
            'text':"This is added by clicking the plus button!",
          });
        },
      ),
    );
  }
}
