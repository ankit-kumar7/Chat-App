import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _controller = TextEditingController();
  var _newMessage = "";

  void _storedMessage()async
  {
    final user =  FirebaseAuth.instance.currentUser;

    // ignore: deprecated_member_use
    final userData = await Firestore.instance.collection('user').doc(user.uid).get();
    // ignore: deprecated_member_use
    Firestore.instance.collection('chat').add({
      'text':_newMessage,
      'createdAt':Timestamp.now(),
      'userId':user.uid,
      'userName':userData['username'],
      'imageUrl':userData['imageUrl'],
    });
    _controller.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top:10.0,bottom: 8.0),
      margin: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                border:OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                labelText: "type message"
              ),
              onChanged: (value)
              {
                setState(() {
                  _newMessage = value;
                  if(_newMessage.isEmpty)
                    {
                      FocusScope.of(context).unfocus();
                    }
                });
              },
            ),
          ),
          SizedBox(
            width: 10,
          ),
          FloatingActionButton(
            child: Icon(Icons.send),
            backgroundColor:_newMessage.isEmpty? Colors.white12: Theme.of(context).primaryColor,
            onPressed:()
            {
              if(_newMessage.isEmpty)
                return null;
              else
                _storedMessage();
            },
          ),
        ],
      ),
    );
  }
}
