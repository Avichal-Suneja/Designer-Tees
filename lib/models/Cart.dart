import 'package:designer_tee/models/Shirt.dart';

class Cart
{
  List<Shirt> shirts = []; // List of shirts in the cart
  Map amount = {}; // Amount of each shirt

  // ADD A SHIRT TO CART OR INCREASE ITS AMOUNT IF IT ALREADY EXISTS
  void addToCart(Shirt shirt){
    if(amount[shirt.id]==null){
      shirts.add(shirt);
      amount[shirt.id] = 1;
    }
    else{
      amount[shirt.id]+=1;
    }
  }

  // REMOVE A SHIRT FROM CART OR DECREASE ITS AMOUNT IF IT IS GREATER THAN ZERO
  void removeFromCart(Shirt shirt){
    amount[shirt.id]-=1;
    if(amount[shirt.id]<=0){
      shirts.remove(shirt);
      amount.remove(shirt.id);
    }
  }

  // CHECK IF THE CART IS EMPTY
  bool isEmpty(){
    return shirts.length == 0;
  }

  // CONVERT THE LOCAL SHIRT LIST TO MAP TO STORE INTO FIRE-STORE
  Map<String, List<dynamic>> giveShirtsMap(){

    List<String> ids = [];
    for(var shirt in shirts){
      String id = shirt.id;
      ids.add(id);
    }

    List<String> names = shirts.map((shirt) => shirt.name).toList();
    List<int> prices = shirts.map((shirt) => shirt.price).toList();
    List<int> quantities = shirts.map((shirt) => shirt.quantity).toList();
    List<String> images = shirts.map((shirt) => shirt.image).toList();

    return {
      'ids' :  ids,
      'names': names,
      'prices': prices,
      'quantities': quantities,
      'images' : images,
    };
  }

  // CONVERT MAP SHIRTS INTO LOCAL SHIRT OBJECTS
  List<Shirt> mapToShirt(Map shirts){
    List<Shirt> shirtObjects = [];
    for(int i=0; i<shirts['ids'].length; i++){
      Shirt shirt = new Shirt(id: shirts['ids'][i], name: shirts['names'][i], price: shirts['prices'][i],
                              quantity: shirts['quantities'][i], image: shirts['images'][i]);
      shirtObjects.add(shirt);
    }
    return shirtObjects;
  }
}