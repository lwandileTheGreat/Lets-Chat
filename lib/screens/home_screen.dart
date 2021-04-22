import 'package:chat_app/screens/registration.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class MyHomePage extends StatelessWidget {
  static const String idScreen = "home";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  // padding: EdgeInsets.only(
                  //   left: 12,
                  // ),
                  child: Image.asset(
                    "assets/logo.png",
                    width: 100.0,
                  ),
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              Text(
                "Let's Chat",
                style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(
            height: 50.0,
          ),
          CustomButton(
              text: "Log In",
              callback: () {
                Navigator.of(context).pushNamed(Login.idScreen);
              }),
          Text(
            "Or",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          CustomButton(
              text: "Sign Up",
              callback: () {
                Navigator.of(context).pushNamed(Registration.idScreen);
              }),
          Text(
            "If you have no account with us, why not?😊",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final VoidCallback callback;
  final String text;
  const CustomButton({Key key, this.callback, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Colors.grey,
        elevation: 6.0,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: callback,
          minWidth: 200.0,
          height: 45.0,
          child: Text(text),
        ),
      ),
    );
  }
}
