import 'package:designer_tee/models/Cart.dart';
import 'package:designer_tee/models/User.dart';
import 'package:designer_tee/utility/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService
{
  // INITIALIZING FIREBASE AUTH OBJECT AND THEIR RESPECTIVE CART
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Cart cart;

  // CONVERT FIREBASE USER TO LOCAL MODEL USER
  MyUser _convertUser(User user){
    return user!=null? MyUser(uid: user.uid, isEmailVerified: !user.isAnonymous) : null;
  }

  // STREAM TO DETECT ANY AUTH CHANGES
  Stream<MyUser> get user {
    return _auth.authStateChanges().map(_convertUser);
  }

  // SIGN INTO FIREBASE ANONYMOUSLY
  Future signInAnon() async {
    try{
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return _convertUser(user);
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  // REGISTER WITH FIREBASE USING EMAIL AND PASSWORD
  Future registerWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;

      // Creating new Document for user in Firebase
      await DataBaseService(uid: user.uid).updateUserData(cart);
      return _convertUser(user);
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  // SIGN IN WITH FIREBASE USING EMAIL AND PASSWORD
  Future signInWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return _convertUser(user);
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  // SIGN-OUT
  Future signOut() async {
    try{
      return await _auth.signOut();
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

}