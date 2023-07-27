import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cart_stepper/cart_stepper.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  static int total = 0;
  @override
  Widget build(BuildContext context) {
    final docRef = firestore.collection('Cart').doc(_auth.currentUser?.email);
    return Container(
      child: Column(
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
                  List cartItems = snapshot.data?.get('items');
                  List cartPrice = snapshot.data?.get('prices');
                  print(cartItems);
                  if (cartItems.isEmpty) {
                    return const Text('Cart is empty.');
                  }
                  return ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      total += int.parse(cartPrice[index]);
                      return Card(
                        child: ListTile(
                          title: Text(cartItems[index]),
                          subtitle: Text('₹' + cartPrice[index]),
                          // trailing:
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Text('Total=₹${total}'),
          TextButton(onPressed: () {}, child: Text('Proceed To Pay'))
        ],
      ),
    );
  }
}
