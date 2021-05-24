import 'package:designer_tee/models/Cart.dart';

class MyUser
{
  final String uid;
  bool isEmailVerified; // check if the user is registered or a guest
  MyUser({this.uid, this.isEmailVerified});

}