import 'dart:ui';
import 'package:chat_app/screen/auth_screen.dart';
import 'package:chat_app/screen/chat_screen.dart';
import 'package:chat_app/screen/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat  Application',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.deepPurpleAccent,
        accentColorBrightness: Brightness.dark,
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Colors.pink,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:StreamBuilder(
          // ignore: deprecated_member_use
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (context,userSnapshot){
            if(userSnapshot.connectionState == ConnectionState.waiting)
              {
                return SplashScreen();
              }
            if(userSnapshot.hasData)
              {
                return ChatScreen();
              }
            else
              {
                return AuthScreen();
              }
          },
      ),
    );
  }
}
