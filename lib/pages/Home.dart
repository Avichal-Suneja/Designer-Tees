import 'package:designer_tee/models/Cart.dart';
import 'package:designer_tee/pages/Loading.dart';
import 'package:designer_tee/utility/auth.dart';
import 'package:designer_tee/utility/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:designer_tee/models/Shirt.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

  class _HomeState extends State<Home> {

    // INITIALIZING LOCAL VARIABLES AND DATABASE/AUTH OBJECTS
    List<Shirt> shirts;
    bool loading = true;
    final DataBaseService _db = new DataBaseService(uid: '101');
    final AuthService _auth = new AuthService();


    // GETTING ALL SHIRTS TO DISPLAY AS SOON AS THE HOME PAGE LOADS
    void initState(){
      super.initState();
      getAllShirts();
    }


  // ASYNC FUNCTION TO GET THE SHIRT LIST FROM FIREBASE
  void getAllShirts() async {
    shirts = await _db.getAllShirts();
    setState(() {
      loading = false;
    });
  }

  // THE MAIN BUILD FUNCTION
  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.cyan[200],
        centerTitle: false,
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
        actions: [
          TextButton.icon(
            icon: Icon(
              Icons.logout,
              color: Colors.black,
            ),
            label: Text(
              'Logout',
              style: TextStyle(
                color: Colors.black
              ),
            ),
            onPressed: () async {
              await _auth.signOut();
            },
          )
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image(
                image: NetworkImage('https://2o9wno13nlvr6bc7g3r74r0h-wpengine.netdna-ssl.com/wp-content/uploads/2015/04/banner-e-commerce1.png'),
              ),
            ),
          ),

          SizedBox(height: 16.0),

          Expanded(
            child: ListView.builder(
              itemCount: shirts.length,
              itemBuilder: (context,index) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(
                              shirts[index].image,
                              width:  100.0,
                              height: 200.0,
                              alignment: Alignment.centerLeft,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "${shirts[index].name}",
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontFamily: 'roboto',
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                "Rs. ${shirts[index].price}",
                                style: TextStyle(
                                  fontSize: 18.0,
                                )
                              ),
                              SizedBox(height: 20.0),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/Information', arguments: {
                                    "name" : shirts[index].name,
                                    "id" : shirts[index].id,
                                    "image" : shirts[index].image,
                                    "quantity" : shirts[index].quantity,
                                    "price" : shirts[index].price,
                                  });
                                },
                                child: Text(
                                  'Show more',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  )
                                ),
                                style: ButtonStyle(

                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  ),
                );
              },
            ),
          )
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
