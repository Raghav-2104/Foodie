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
  Set<String> selectedItems = Set<String>();
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
                  return Card(
                      child: ListTile(
                    title: Text(doc?['name']),
                    subtitle: Text(doc?['price']),
                    trailing: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (isAdded) {
                            selectedItems.remove(itemName);
                            cart.set({'items': selectedItems});
                            print(selectedItems);
                          } else {
                            selectedItems.add(itemName);
                            print(selectedItems);
                            cart.set({'items': selectedItems});
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
