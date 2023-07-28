import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  static var total = 0;
  @override
  Widget build(BuildContext context) {
    final docRef = firestore.collection('Cart').doc(_auth.currentUser?.email);

    print('total=${total}');
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<DocumentSnapshot>(
            stream: docRef.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Text("Error:${snapshot.error}");
              } else {
                List cartItems = snapshot.data?.get('itemList');
                if (cartItems.isEmpty) {
                  return const Text('Cart is empty.');
                }
                print(snapshot.data?.get('total'));
                total = snapshot.data?.get('total');
                return ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    print(cartItems[index]);
                    return Card(
                      child: ListTile(
                          title: Text(cartItems[index]['itemName']),
                          subtitle: Text('₹' + cartItems[index]['itemPrice']),
                        //add quantity stepper
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  if (cartItems[index]['quantity'] > 1) {
                                    cartItems[index]['quantity']--;
                                    total = total -
                                        int.parse(
                                            cartItems[index]['itemPrice']);
                                    docRef.update({
                                      'itemList': cartItems,
                                      'total': total
                                    });
                                  }
                                  else{
                                    total = total -
                                        int.parse(
                                            cartItems[index]['itemPrice']);
                                    cartItems.removeAt(index);
                                    docRef.update(
                                        {'itemList': cartItems, 'total': total});
                                  }
                                });
                              },
                            ),
                            Text(cartItems[index]['quantity'].toString()),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  cartItems[index]['quantity']++;
                                  total = total +
                                      int.parse(cartItems[index]['itemPrice']);
                                  docRef.update({
                                    'itemList': cartItems,
                                    'total': total
                                  });
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
        Center(child: Text('Total=₹$total')),
        Center(
            child:
                TextButton(onPressed: () {}, child: Text('Proceed To Pay')))
      ],
    );
  }
}
