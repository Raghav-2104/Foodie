import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> itemList = [];
  @override
  Widget build(BuildContext context) {
    var cart = firestore.collection('Cart').doc(_auth.currentUser?.email);
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Menu').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error:${snapshot.error}');
          } else {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      var doc = snapshot.data?.docs[index];
                      var itemName = doc?['name'];
                      var itemPrice = doc?['price'];
                      bool isPresentInCart = false;

                      return Card(
                        child: ListTile(
                        title: Text(doc?['name']),
                        subtitle: Text(doc?['price']),
                        trailing: ElevatedButton(
                          onPressed: () async {
                            var cartSnapshot = await cart.get();
                            if (cartSnapshot.exists) {
                              var itemList = cartSnapshot.data()?['itemList']
                                  as List<dynamic>;
                              int total = cartSnapshot.data()?['total'];

                              for (var item in itemList) {
                                if (item['itemName'] == itemName) {
                                  // Item is already in the cart
                                  isPresentInCart =!isPresentInCart;
                                  break;
                                }
                              }

                              if (isPresentInCart) {
                                print('Item is already in the cart!');
                                setState(() {
                                  isPresentInCart =!isPresentInCart;
                                });
                                total -= int.parse(itemPrice);
                                itemList.removeWhere((element) =>
                                    element['itemName'] == itemName);
                                cart.update({
                                  'itemList':itemList,
                                  'total':total
                                });
                                // print(itemList);
                                // print(cartSnapshot.data()?['itemList'][0]['itemName']);
                              } else {
                                print(
                                    'Item is not in the cart. Add it to the cart!');
                                setState(() {
                                  isPresentInCart = true;
                                });
                                itemList.add({
                                  'itemName': itemName,
                                  'itemPrice': itemPrice,
                                  'quantity': 1
                                });
                                total += int.parse(itemPrice);
                                cart.update(
                                    {'itemList': itemList, 'total': total});
                              }
                            } else {
                              print('Cart document does not exist!');
                            }
                            print('isPresentInCart' + isPresentInCart.toString());
                          },
                          child:isPresentInCart==true?Icon(Icons.remove):Icon(Icons.add)
                        ),
                      ));
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
