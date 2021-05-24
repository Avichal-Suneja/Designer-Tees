import 'package:designer_tee/authenticate/authenticate.dart';
import 'package:designer_tee/models/User.dart';
import 'package:designer_tee/pages/Home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context)  {

    // CHECKING WHETHER USER IS LOGGED IN OR NOT AND DISPLAYING APPROPRIATE WIDGETS IN ACCORDANCE
      final user = Provider.of<MyUser>(context);
      if(user==null)
        return Authenticate();
      else
        return Home();

  }
}
