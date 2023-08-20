import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Menu2 extends StatefulWidget {
  const Menu2({Key? key});

  @override
  State<Menu2> createState() => _Menu2State();
}

class _Menu2State extends State<Menu2> {
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
                          title: Text(menuDoc?['name']),
                          subtitle: Text(menuDoc?['price']),
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
                                Icon(isPresentInCart ? Icons.check : Icons.add),
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
