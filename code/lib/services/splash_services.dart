import 'package:flutter/material.dart';
import 'package:udhar/screens/login_screen.dart';

class SplashServices {

  void splash(BuildContext context) async{
    await Future.delayed(Duration(seconds: 3));
    Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => LoginScreen(title: "LOGIN",)));
  }
}
