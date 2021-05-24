import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:designer_tee/models/Address.dart';
import 'package:designer_tee/models/Cart.dart';
import 'package:designer_tee/models/Shirt.dart';

class DataBaseService
{
  // UID TO LINK DATABASE OBJECT WITH A UNIQUE USER
  final String uid;
  DataBaseService({this.uid});

  List<Shirt> allShirts = []; // List of all the shirts in firebase


  // CONVERT FIREBASE SHIRT TO LOCAL SHIRT OBJECT
  Shirt _convertToShirt(dynamic record) {
    return Shirt(id: record.get('id'), name: record.get('name'), price: record.get('price'),
    quantity: record.get('quantity'), image: record.get('image'));
  }


  // COLLECTION REFERENCES TO FIRE-STORE STORAGE
  final CollectionReference cartCollection = FirebaseFirestore.instance.collection('carts');
  final CollectionReference shirtCollection = FirebaseFirestore.instance.collection('shirts');
  final CollectionReference addressCollection = FirebaseFirestore.instance.collection('addresses');
  final CollectionReference orderCollection = FirebaseFirestore.instance.collection('orders');


  // UPDATE USER CART IN THE DATABASE
  Future updateUserData(Cart cart) async {
    return await cartCollection.doc(uid).set({'shirts': cart.giveShirtsMap(), 'amount':cart.amount});
  }


  // GET ALL THE SHIRTS TO DISPLAY FROM FIRE-STORE
  Future getAllShirts() async {
    await shirtCollection.get().then((querySnapshot) {
      for(int i=0; i<querySnapshot.docs.length; i++){
        allShirts.add(_convertToShirt(querySnapshot.docs[i]));
      }
    });
    return allShirts;
  }


  // GET A STREAM OF USER CART IN CASE IT UPDATES
  Stream<QuerySnapshot> get carts {
    return cartCollection.snapshots();
  }


  // GET LOCAL CART OBJECT OF USER WITH PARTICULAR UID
  Future<Cart> getUserCart() async {
    DocumentSnapshot cart = await cartCollection.doc(uid).get();
    Cart myCart = new Cart();
    myCart.shirts = myCart.mapToShirt(cart.get('shirts'));
    myCart.amount = cart.get('amount');
    return myCart;
  }


  // EMPTY THE USER CART ONCE THEY PLACE THE ORDER
  Future emptyUserCart() async {
    return await cartCollection.doc(uid).set({'shirts': {}, 'amount':{}});
  }


  // UPDATE THE ADDRESS OF A SIGNED IN USER
  Future updateUserAddress(Address address) async {
    return await addressCollection.doc(uid).set({
      'pinCode' : address.pinCode,
      'state' : address.state,
      'city' : address.city,
      'address' : address.address,
      'phoneNumber' : address.phoneNumber,
    });
  }


  // CREATE AN ORDER DOCUMENT IN THE FIRE-STORE
  Future placeOrder(Cart cart, Address address) async {
    return await orderCollection.doc(uid).set({
      'order' : cart.amount,
      'pinCode' : address.pinCode,
      'state' : address.state,
      'city' : address.city,
      'address' : address.address,
      'phoneNumber' : address.phoneNumber,
    });
  }


  // GET ADDRESS OF A USER IF THEY SAVED IT EARLIER
  Future<Address> getUserAddress() async {
    DocumentSnapshot address = await addressCollection.doc(uid).get();
    return Address(pinCode: address.get('pinCode'), state: address.get('state'), city: address.get('city'),
        address: address.get('address'), phoneNumber: address.get('phoneNumber'));
  }
}