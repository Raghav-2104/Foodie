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
  static Set<String> selectedItems = Set<String>();
  static Set<String> selectedPrice = Set<String>();
  static List temp = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
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
            return Expanded(
              child: ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  var doc = snapshot.data?.docs[index];
                  var itemName = doc?['name'];
                  var itemPrice = doc?['price'];
                  bool isAdded = selectedItems.contains(itemName);
                  print(doc?.data());
                  return Card(
                      child: ListTile(
                    title: Text(doc?['name']),
                    subtitle: Text(doc?['price']),
                    trailing: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (isAdded) {
                            temp = selectedItems.toList();
                            int indexOfItem = temp.indexOf(itemName);
                            selectedPrice.remove(snapshot.data?.docs[indexOfItem]['price']);
                            selectedItems.remove(itemName);
                            cart.set({'items': selectedItems,'prices':selectedPrice});
                            // print(selectedItems);
                            print(selectedPrice);
                          } else {
                            selectedItems.add(itemName);
                            temp = selectedItems.toList();
                            int indexOfItem = temp.indexOf(itemName);
                            selectedPrice.add(snapshot.data?.docs[indexOfItem]['price']);
                            // print(selectedItems);
                            print(selectedPrice);
                            cart.set({'items': selectedItems,'prices':selectedPrice});
                          }
                        });
                      },
                      child: Icon(isAdded ? Icons.remove : Icons.add),
                    ),
                  ));
                },
              ),
            );
          }
        },
      ),
    );
  }
}
