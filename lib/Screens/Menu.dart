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
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SearchBar(
            hintText: 'Search for items',
            onChanged: (value) {},
            trailing:[
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search),
              ),]
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Menu').snapshots(),
              builder: (context, menuSnapshot) {
                if (menuSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (menuSnapshot.hasError) {
                  return const Center(
                    child: Text('There is an issue with the server\nPlease try again later'),
                  );
                } else if (!menuSnapshot.hasData || menuSnapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No items available'),
                  );
                } else {
                  return FutureBuilder<DocumentSnapshot>(
                    future: firestore.collection('Cart').doc(_auth.currentUser?.email).get(),
                    builder: (context, cartSnapshot) {
                      if (cartSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (cartSnapshot.hasError) {
                        return const Center(
                          child: Text('There is an issue with the server\nPlease try again later'),
                        );
                      } else {
                        var cartData = cartSnapshot.data?.data() as Map<String, dynamic>? ?? {};
                        var itemList = (cartData['itemList'] as List<dynamic>?) ?? [];
                        var total = cartData['total'];
              
                        return GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // You can adjust the number of columns here
                            mainAxisSpacing: 16.0,
                            crossAxisSpacing: 16.0,
                            childAspectRatio: 0.75, // Adjust the aspect ratio as needed
                          ),
                          itemCount: menuSnapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            var cart = firestore.collection('Cart').doc(_auth.currentUser?.email);
                            var menuDoc = menuSnapshot.data?.docs[index];
                            var itemName = menuDoc?['name'];
                            var itemPrice = menuDoc?['price'];
                            var isPresentInCart = itemList.any((item) => item['itemName'] == itemName);
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                shadowColor: Colors.black,
                                elevation: 2,
                                color: Colors.blue[100],
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Image(image: AssetImage('assets/nachos.png'),height: 120,width: 120,),
                                    const Divider(
                                      height: 20,
                                      thickness: 2,
                                      indent: 20,
                                      endIndent: 20,
                                    ),
                                    Text(menuDoc?['name'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                    Text("₹${menuDoc?['price']}", style: const TextStyle(fontSize: 16)),
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          if (isPresentInCart) {
                                            itemList.removeWhere((element) => element['itemName'] == itemName);
                                            total -= int.parse(itemPrice);
                                          } else {
                                            total += int.parse(itemPrice);
                                            itemList.add({'itemName': itemName, 'itemPrice': itemPrice, 'quantity': 1});
                                          }
                                          cart.update({'itemList': itemList, 'total': total});
                                        });
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: isPresentInCart? MaterialStateProperty.all(Colors.red) : MaterialStateProperty.all(Colors.green),
                                        shadowColor: MaterialStateProperty.all(Colors.white),
                                        foregroundColor: !isPresentInCart? MaterialStateProperty.all(Colors.black):null,
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12.0),
                                            side: const BorderSide(color: Colors.transparent),
                                          ),
                                        ),
                                      ),
                                      child: isPresentInCart? const Text('Remove',style: TextStyle(fontWeight: FontWeight.bold,letterSpacing: 1),) : const Text('Add',style: TextStyle(fontWeight: FontWeight.bold,letterSpacing: 1)),
                                    ),
                                  ],
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
          ),
        ],
      ),
    );
  }
}
