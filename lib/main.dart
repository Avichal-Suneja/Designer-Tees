import 'package:designer_tee/Wrapper.dart';
import 'package:designer_tee/models/User.dart';
import 'package:designer_tee/pages/Order.dart';
import 'package:designer_tee/utility/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:designer_tee/pages/Information.dart';
import 'package:designer_tee/pages/Cart.dart';
import 'package:provider/provider.dart';

void main() async {

  // INITIALIZING FIREBASE
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // GETTING THE VALUE OF FIREBASE USER FROM THE STREAM
  runApp(StreamProvider<MyUser>.value(
    value: AuthService().user,
    child: MaterialApp(
      home: Wrapper(),
      routes: {
        '/Home' : (context) => Wrapper(),
        '/Information' : (context) => Information(),
        '/Cart' : (context) => Cart(),
        '/Order' : (context) => Order()
      },
    ),
  ));
}

