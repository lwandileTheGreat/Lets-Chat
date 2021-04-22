import 'package:chat_app/main.dart';
import 'package:chat_app/screens/chat.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/progressDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:string_validator/string_validator.dart';

class Login extends StatelessWidget {
  static const String idScreen = "login";
  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController passwordTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Let's Chat",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Hero(
              tag: 'logo',
              child: Container(
                child: Image.asset("assets/logo.png"),
              ),
            ),
          ),
          SizedBox(
            height: 40.0,
          ),
          TextField(
            controller: emailTextEditingController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "Enter Your Email",
              border: const OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 40.0,
          ),
          TextField(
            controller: passwordTextEditingController,
            autocorrect: false,
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Enter Your Password",
              border: const OutlineInputBorder(),
            ),
          ),
          CustomButton(
              text: "Login",
              callback: () {
                print("Clicked");
                if (!isEmail(
                  emailTextEditingController.text.toString(),
                )) {
                  displayToastMessage("Email Address is not valid.", context);
                } else if (passwordTextEditingController.text.isEmpty) {
                  displayToastMessage("Please enter a password.", context);
                } else {
                  loginUser(context);
                }
              }),
        ],
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void loginUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(message: "Please wait😊...");
        });

    final User firebaseUser = (await _firebaseAuth
            .signInWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((errmsg) {
      Navigator.pop(context);
      displayToastMessage("Error: " + errmsg.toString(), context);
    }))
        .user;
    if (firebaseUser != null) //User
    {
      usersRef.child(firebaseUser.uid).once().then((DataSnapshot snap) {
        if (snap.value != null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Chat(
                  user: firebaseUser,
                ),
              ));

          displayToastMessage(
              "Congratulations, your have logged in successfully😊.", context);
        } else {
          Navigator.pop(context);
          _firebaseAuth.signOut();
          displayToastMessage(
              "No records exists for this user. Please create new account.",
              context);
        }
      });
    } else {
      Navigator.pop(context);
      displayToastMessage("Error occured, cannot be signed in", context);
    }
  }
}

displayToastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}
