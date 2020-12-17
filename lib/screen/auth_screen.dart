import 'package:chat_app/widget/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

final _auth = FirebaseAuth.instance;
var isLoading = false;

  void _submitAuthForm(
      String email,
      String userName,
      String password,
      bool isLogin,
      File userImage
      )async
  {
    try
    {
      setState(() {
        isLoading = true;
      });
      UserCredential _authResult;
      if(!isLogin)
      {
        _authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);
      }
      else
      {
        _authResult = await _auth.createUserWithEmailAndPassword(email: email,  password: password);

        final userImageRef = FirebaseStorage.instance.ref().child('user_image').child(_authResult.user.uid+'.jpg');

        await userImageRef.putFile(userImage);

        final url = await userImageRef.getDownloadURL();

        // ignore: deprecated_member_use
        Firestore.instance.collection('user').doc(_authResult.user.uid).setData({
          'username':userName,
          'email':email,
          'imageUrl':url,
        });
      }
      setState(() {
        isLoading = false;
      });
    } on PlatformException catch(error)
    {
      var message = "An error occurred, Please check your credential.";
      if(error.message != null)
        {
           message = error.message;
        }
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor),
      );
      setState(() {
        isLoading =false;
      });
    }catch(error)
    {
      setState(() {
        isLoading = false;
      });
      print(error);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm,isLoading),
    );
  }
}
