import 'package:designer_tee/models/Address.dart';
import 'package:designer_tee/models/Cart.dart';
import 'package:designer_tee/models/User.dart';
import 'package:designer_tee/pages/Loading.dart';
import 'package:designer_tee/utility/database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class Order extends StatefulWidget {
  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {


  // LOCAL VARIABLES FOR SAVING USER ADDRESS
  final _formKey = GlobalKey<FormState>();
  String state = '';
  String city = '';
  String pinCode = '';
  String address = '';
  String phoneNumber = '';
  bool addressSaved = false;
  Address savedAddress;
  bool loading = true;
  bool changeAddress = false;

  // CHECK WHETHER THE USER ADDRESS IS ALREADY SAVED OR NOT
  void getAddress(DataBaseService db) async {
    try{
      savedAddress = await db.getUserAddress();
      if(this.mounted){
        setState(() {
          addressSaved = true;
        });
      }
      print("Address Found");
    }
    catch(e){
      print("Address not found");
    }
    finally{
      if(this.mounted){
        setState(() {
          loading = false;
        });
      }
    }
  }

  // THE MAIN BUILD FUNCTION
  @override
  Widget build(BuildContext context) {

    // GETTING USER DATA TO CHECK FOR SAVED ADDRESS
    MyUser user = Provider.of<MyUser>(context);
    DataBaseService _db = new DataBaseService(uid: user.uid);
    changeAddress? print('') : getAddress(_db);

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
            "Designer Tees",
            style: TextStyle(
              color: Colors.black,
              fontSize: 24.0,
              fontFamily: 'orelega',
            ),
          ),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 32.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Center(
              child: Text(
                'Enter your Delivery Address',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),

            Expanded(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 20.0),
                    addressSaved? Center(child: Text('State: '+savedAddress.state, style: TextStyle(fontSize: 18))) : TextFormField(
                      validator: (val) => val.isEmpty? "State can't be empty" : null,
                      decoration: InputDecoration(
                        labelText: 'State',
                        border: UnderlineInputBorder(),
                      ),
                      onChanged: (val) {
                        setState(() {
                          state = val;
                        });
                      },
                    ),
                    SizedBox(height: 20.0),

                    addressSaved? Center(child: Text('City: '+savedAddress.city, style: TextStyle(fontSize: 18))) : TextFormField(
                      validator: (val) => val.isEmpty? "City can't be empty" : null,
                      decoration: InputDecoration(
                        labelText: 'City',
                        border: UnderlineInputBorder(),
                      ),
                      onChanged: (val) {
                        setState(() {
                          city = val;
                        });
                      },
                    ),
                    SizedBox(height: 20.0),

                    addressSaved? Center(child: Text('Pin-Code: '+savedAddress.pinCode,style: TextStyle(fontSize: 18))) : TextFormField(
                      validator: (val) => val.isEmpty? "Pin-Code can't be empty" : null,
                      decoration: InputDecoration(
                        labelText: 'Pin-Code',
                        border: UnderlineInputBorder(),
                      ),
                      onChanged: (val) {
                        setState(() {
                          pinCode = val;
                        });
                      },
                    ),
                    SizedBox(height: 20.0),

                    addressSaved? Center(child: Text('Address: '+savedAddress.address,style: TextStyle(fontSize: 18))) : TextFormField(
                      validator: (val) => val.isEmpty? "Building name /Street number can't be empty" : null,
                      decoration: InputDecoration(
                        labelText: 'Building name /Street Number',
                        border: UnderlineInputBorder(),
                      ),
                      onChanged: (val) {
                        setState(() {
                          address = val;
                        });
                      },
                    ),
                    SizedBox(height: 20.0),

                    addressSaved? Center(child: Text('Mobile No.: '+savedAddress.phoneNumber,style: TextStyle(fontSize: 18))) : TextFormField(
                      validator: (val) => val.isEmpty? "Mobile No. can't be empty" : null,
                      decoration: InputDecoration(
                        labelText: 'Mobile No.',
                        border: UnderlineInputBorder(),
                      ),
                      onChanged: (val) {
                        setState(() {
                          phoneNumber = val;
                        });
                      },
                    ),

                    SizedBox(height: 20.0),
                    ElevatedButton(
                      child: Text("Place Order"),
                      onPressed: () async {
                        if(_formKey.currentState.validate() || addressSaved){
                          Cart cart = await _db.getUserCart();
                          print("GOT cart");
                          Address address1;
                          if(addressSaved)
                            address1 = savedAddress;
                          else
                            address1 = new Address(state: state, city: city, pinCode: pinCode, address: address,
                                                   phoneNumber: phoneNumber);

                          if(user.isEmailVerified){
                            await _db.updateUserAddress(address1);
                            print("Address Updated");
                          }
                          await _db.placeOrder(cart, address1);
                          print("Order Updated");
                          await _db.emptyUserCart();
                          print("Cart Empty");
                          Fluttertoast.showToast(
                            msg: 'Order Placed',
                            toastLength: Toast.LENGTH_SHORT,
                          );
                          Navigator.of(context)
                              .pushNamedAndRemoveUntil('/Home', (Route<dynamic> route) => false);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40),
            !addressSaved? Container() : ElevatedButton(
              child: Text('Change Address'),
              onPressed: () {
                setState(() {
                  addressSaved = false;
                  changeAddress = true;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
