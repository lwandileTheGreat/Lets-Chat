import 'package:chat_app/screens/chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:string_validator/string_validator.dart';
import 'home_screen.dart';
import 'package:chat_app/main.dart';

class Registration extends StatelessWidget {
  static const String idScreen = "register";

  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController passwordTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Lets Chat",
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
              text: "Register",
              callback: () {
                print("Clicked");
                if (!isEmail(
                  emailTextEditingController.text.toString(),
                )) {
                  displayToastMessage("Email Address is not valid.", context);
                } else if (passwordTextEditingController.text.length < 8) {
                  displayToastMessage(
                      "Password must be at least 8 characters.", context);
                } else {
                  registerNewUser(context);
                }
              }),
        ],
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void registerNewUser(BuildContext context) async {
    final User firebaseUser = (await _firebaseAuth
            .createUserWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((errmsg) {
      Navigator.pop(context);
      displayToastMessage("Error: " + errmsg.toString(), context);
    }))
        .user;

    if (firebaseUser != null) {
//save user info
      Map userDataMap = {
        "email": emailTextEditingController.text.trim(),
      };

      usersRef.child(firebaseUser.uid).set(userDataMap);

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Chat(
              user: firebaseUser,
            ),
          ));
      displayToastMessage(
          "Congratulations, your account has been created😊.", context);
    } else {
      //error occured
      Navigator.pop(context);
      displayToastMessage("New user account has not been created.", context);
    }
  }
}

displayToastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}
