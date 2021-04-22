import 'package:chat_app/screens/chat.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/login.dart';
import 'package:chat_app/screens/registration.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

DatabaseReference usersRef =
    FirebaseDatabase.instance.reference().child("users");

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lets Chat',
      theme: ThemeData(
        primaryColor: Colors.grey[200],
      ),
      initialRoute: MyHomePage.idScreen,
      routes: {
        MyHomePage.idScreen: (context) => MyHomePage(),
        Registration.idScreen: (context) => Registration(),
        Login.idScreen: (context) => Login(),
        Chat.idScreen: (context) => Chat(),
      },
    );
  }
}
