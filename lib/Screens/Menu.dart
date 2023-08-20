import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Menu').snapshots(),
        builder: (context, menuSnapshot) {
          if (menuSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (menuSnapshot.hasError) {
            return const Center(
              child: Text(
                  'There is an issue with the server\nPlease try again later'),
            );
          } else if (!menuSnapshot.hasData || menuSnapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No items available'),
            );
          } else {
            return FutureBuilder<DocumentSnapshot>(
              future: firestore
                  .collection('Cart')
                  .doc(_auth.currentUser?.email)
                  .get(),
              builder: (context, cartSnapshot) {
                if (cartSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (cartSnapshot.hasError) {
                  return const Center(
                    child: Text(
                        'There is an issue with the server\nPlease try again later'),
                  );
                } else {
                  var cartData =
                      cartSnapshot.data?.data() as Map<String, dynamic>? ?? {};
                  var itemList = (cartData['itemList'] as List<dynamic>?) ?? [];
                  // print('total:'+cartData['total'].toString());
                  return ListView.builder(
                    itemCount: menuSnapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      var cart = firestore
                          .collection('Cart')
                          .doc(_auth.currentUser?.email);
                      var menuDoc = menuSnapshot.data?.docs[index];
                      var itemName = menuDoc?['name'];
                      var itemPrice = menuDoc?['price'];

                      var isPresentInCart =
                          itemList.any((item) => item['itemName'] == itemName);

                      return Card(
                        child: ListTile(
                          title: Text(menuDoc?['name'],
                            style:const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                              )
                          ),
                          subtitle: Text("₹${menuDoc?['price']}",
                            style:const TextStyle(
                              fontSize: 16,
                              )
                          ),
                          trailing: IconButton(
                            onPressed: () async {
                              int total=cartData['total'];
                              if (isPresentInCart) {
                                // Item is already in the cart, you can handle this case here
                                // For example, show a snackbar or alert
                                setState(() {
                                  itemList.removeWhere((element) =>
                                      element['itemName'] == itemName);
                                total -= int.parse(itemPrice);
                                });
                              } else {
                                // Item is not in the cart, you can add it to the cart here
                                // For example, update the cart in Firestore
                                setState(() {
                                  total += int.parse(itemPrice);
                                  itemList.add({
                                    'itemName': itemName,
                                    'itemPrice': itemPrice,
                                    'quantity': 1
                                  });
                                });
                              }
                              cart.update({'itemList': itemList,'total':total});
                            },
                            icon:
                                isPresentInCart ? const Icon(Icons.done,color: Colors.green,size:30,) : const Icon(Icons.add,color: Colors.black,size:30),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
