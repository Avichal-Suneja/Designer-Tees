import 'package:designer_tee/authenticate/register.dart';
import 'package:designer_tee/authenticate/signIn.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  // INITIALLY SHOW THE SIGN-IN PAGE
  bool showSignIn = true;

  // SWITCH BETWEEN SIGN-IN AND REGISTER PAGES
  void toggleView(){
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  // THE MAIN BUILD FUNCTION
  @override
  Widget build(BuildContext context) {
    if(showSignIn){
      return SignIn(toggleView: toggleView);
    }
    else{
      return Register(toggleView: toggleView);
    }
  }
}
