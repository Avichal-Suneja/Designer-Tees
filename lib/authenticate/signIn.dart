import 'package:designer_tee/pages/Loading.dart';
import 'package:designer_tee/utility/auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  // Firebase Authentication
  final AuthService _auth = new AuthService();

  //Form Validation
  final _formKey = GlobalKey<FormState>();

  // TextField values
  String email = '';
  String password = '';
  String error = '';

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading? Loading() : Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
          backgroundColor: Colors.cyan[200],
          centerTitle: true,
          title: TextButton.icon(
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.black,
              size: 24.0,
            ),
            label: Text(
              "Sign In",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24.0,
                fontFamily: 'orelega',
              ),
            ),
          ),
        actions: [
          TextButton.icon(
            icon: Icon(
              Icons.person_add,
              color: Colors.black,
            ),
            label: Text(
              "Register",
              style: TextStyle(
                color: Colors.black
              ),
            ),
            onPressed: () {
              widget.toggleView();
            },
          )
        ],
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 32.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              'Sign in using Email',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 20),
                  TextFormField(
                    validator: (val) => val.isEmpty ? "Email can't be empty" : null,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: UnderlineInputBorder(),
                    ),
                    onChanged: (val) {
                      setState(() {
                        email = val;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    validator: (val) => val.length<6 ? "Enter a password 6+ characters long" : null,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        border: UnderlineInputBorder(),
                    ),
                    obscureText: true,
                    onChanged: (val) {
                      setState(() {
                        password = val;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    child: Text("Sign in"),
                    onPressed: () async {
                      if(_formKey.currentState.validate()){
                        setState(() {
                          loading = true;
                        });
                        dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                        if(result==null){
                          setState(() {
                            error = "Credentials are not valid";
                            loading = false;
                          });
                        }
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Or',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    child: Text('Sign in as guest'),
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });
                      await _auth.signInAnon();
                    },
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    error,
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}
