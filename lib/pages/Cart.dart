import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:designer_tee/pages/Loading.dart';
import 'package:designer_tee/utility/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:designer_tee/models/User.dart';
import 'package:designer_tee/models/Cart.dart' as modelCart;

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {

  modelCart.Cart cart = new modelCart.Cart();
  bool loading = true;
  bool emptyCart = false;

  void getCart(DataBaseService db) async {
    try{
      cart =  await db.getUserCart();
    }
    catch(e){
      emptyCart = true;
    }
    if(this.mounted){
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    MyUser user = Provider.of<MyUser>(context);
    DataBaseService _db = new DataBaseService(uid: user.uid);
    getCart(_db);
    int totalPrice = 0;
    for(var shirt in cart.shirts){
      totalPrice+=(shirt.price * cart.amount[shirt.id]);
    }

    return loading? Loading() : StreamProvider<QuerySnapshot>.value(
      value: DataBaseService().carts,
      child: Scaffold(
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
          padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
          child: Column(
            children: [
              Center(
                child: Text(
                  'Cart Information',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              SizedBox(height: 24.0),

              emptyCart? Text('The Cart is Empty!', style: TextStyle(fontSize: 32.0, color: Colors.red)) : Expanded(
                child: ListView.builder(
                  itemCount: cart.shirts.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image(
                            image: NetworkImage(cart.shirts[index].image),
                            width: 50.0,
                            height: 100.0,
                          ),
                          Text(
                            cart.shirts[index].name + '(${cart.shirts[index].id[3].toUpperCase()})',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            'Qty. ' + cart.amount[cart.shirts[index].id].toString(),
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          Text(
                            'Rs. '+'${(cart.amount[cart.shirts[index].id] * cart.shirts[index].price).toString()}',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.green,
                            radius: 15,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.add,
                                size: 20,
                              ),
                              onPressed: () async {
                                cart.addToCart(cart.shirts[index]);
                                await _db.updateUserData(cart);
                                setState(() {});
                              },
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.red,
                            radius: 15,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.exposure_neg_1,
                                size: 20.0,
                              ),
                              onPressed: () async {
                                cart.removeFromCart(cart.shirts[index]);
                                await _db.updateUserData(cart);
                                setState(() {
                                    emptyCart = cart.isEmpty();
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 12.0),

              emptyCart? Container() : Text(
                'Total Price: Rs. ' + totalPrice.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0
                ),
              ),

              SizedBox(height: 16.0),

              emptyCart? Container() : SizedBox(
                width: 152.0,
                height: 50.0,
                child: ElevatedButton.icon(
                  label: Text(
                    'Order Now',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  icon: Icon(Icons.shopping_bag_rounded),
                  onPressed: () {
                    Navigator.pushNamed(context, '/Order');
                  },
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}
