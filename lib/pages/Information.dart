import 'package:designer_tee/models/Cart.dart';
import 'package:designer_tee/models/Shirt.dart';
import 'package:designer_tee/models/User.dart';
import 'package:designer_tee/pages/Home.dart';
import 'package:designer_tee/utility/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class Information extends StatefulWidget {
  @override
  _InformationState createState() => _InformationState();
}

class _InformationState extends State<Information> {

  // INITIALIZING LOCAL VARIABLES
  Map data = {};
  String size = "NotSet";

  // THE MAIN BUILD FUNCTION
  @override
  Widget build(BuildContext context) {

    // GETTING SHIRT DATA FROM THE HOME SCREEN AND STORING IT IN A NEW OBJECT
    data = ModalRoute.of(context).settings.arguments;
    MyUser user = Provider.of<MyUser>(context);
    DataBaseService _db = new DataBaseService(uid: user.uid);
    Shirt shirt = new Shirt(id: data['id'], name: data['name'], image: data['image'], quantity: data['quantity'],
                            price: data['price']);

    return Scaffold(
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
          )
      ),

      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32.0, 32.0, 32.0, 16.0),
              child: Image(
                image: NetworkImage(data['image']),
                width: 400.0,
                height: 800.0,
                alignment: Alignment.topCenter,
              ),
            ),
          ),

          Expanded(
            child: Column(
              children: [
                Text(
                  '${data["name"]}',
                  style: TextStyle(
                    fontFamily: 'roboto',
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  'Price: Rs. ${data["price"]}',
                  style: TextStyle(
                      fontSize: 28.0,
                      fontFamily: 'roboto'
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: size=='small'? Colors.red : Colors.blue[50],
                      radius: 20,
                      child: TextButton(
                        child: Text(
                          'S',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            size = 'small';
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 10.0),
                    CircleAvatar(
                      backgroundColor: size=='medium'? Colors.red: Colors.blue[100],
                      radius: 20,
                      child: TextButton(
                        child: Text(
                          'M',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            size = 'medium';
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 10.0),
                    CircleAvatar(
                      backgroundColor: size=='large'? Colors.red : Colors.blue[200],
                      radius: 20,
                      child: TextButton(
                        child: Text(
                          'L',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            size = 'large';
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Text(
                  '${data['quantity']} pieces left in stock',
                  style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.red,
                    fontFamily: 'roboto'
                  ),
                ),
                SizedBox(height: 32.0),
                SizedBox(
                  height: 80.0,
                  width: 320.0,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      Cart cart;
                      if(size == 'NotSet'){
                        Fluttertoast.showToast(
                          msg: 'Please Select a Size First',
                          toastLength: Toast.LENGTH_SHORT,
                        );
                      }
                      else{
                        shirt.size = size;
                        if(!(shirt.id.toLowerCase().contains('small') || shirt.id.toLowerCase().contains('medium') || shirt.id.toLowerCase().contains('large')))
                          shirt.id = (shirt.id + shirt.size);
                        try{
                          cart = await _db.getUserCart();
                        }
                        catch(e){
                          cart = new Cart();
                        }
                        cart.addToCart(shirt);
                        await _db.updateUserData(cart);
                        Fluttertoast.showToast(
                          msg: 'Added to your Cart',
                          toastLength: Toast.LENGTH_SHORT,
                        );
                        print("Added to cart");
                      }
                    },
                    icon: Icon(
                      Icons.add_shopping_cart,
                      size: 36.0,
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                    ),
                    label: Text(
                      "Add to cart",
                      style: TextStyle(
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.all(8.0),
        child: SafeArea(
          child: Transform.scale(
            scale: 1.5,
            child: FloatingActionButton(
              onPressed: (){
                Navigator.pushNamed(context, '/Cart');
              },
              backgroundColor: Colors.green,
              child: Icon(
                Icons.shopping_cart_sharp,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
