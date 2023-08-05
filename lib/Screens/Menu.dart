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
          bool isPresentInCart = false;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
                child: Text(
                    'There is an issue with server \n Please try again Later'));
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
                      var temp = 'Add';
                      return Card(
                          child: ListTile(
                        title: Text(
                          doc?['name'],
                          style: const TextStyle(
                              fontFamily: 'Times New Roman',
                              fontSize: 20,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          '₹${doc?['price']}',
                          style: const TextStyle(
                              fontFamily: 'Times New Roman',
                              fontSize: 16,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w300,
                              color: Colors.black54),
                        ),
                        trailing: ElevatedButton(
                            style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll<Color>(
                                        Colors.black),
                                foregroundColor:
                                    MaterialStatePropertyAll<Color>(
                                        Colors.white),
                                overlayColor: MaterialStatePropertyAll<Color>(
                                    Colors.red)),
                            onPressed: () async {
                              var cartSnapshot = await cart.get();
                              if (cartSnapshot.exists) {
                                var itemList = cartSnapshot.data()?['itemList']
                                    as List<dynamic>;
                                int total = cartSnapshot.data()?['total'];

                                for (var item in itemList) {
                                  if (item['itemName'] == itemName) {
                                    // Item is already in the cart
                                    isPresentInCart = !isPresentInCart;
                                    break;
                                  }
                                }

                                if (isPresentInCart) {
                                  // print('Item is already in the cart!');
                                  setState(() {
                                    print('isPresentInCart' +
                                        isPresentInCart.toString());
                                    isPresentInCart = !isPresentInCart;
                                    print(temp);
                                    temp = 'Remove';
                                    print(temp);
                                  });
                                  total -= int.parse(itemPrice);
                                  itemList.removeWhere((element) =>
                                      element['itemName'] == itemName);
                                  cart.update(
                                      {'itemList': itemList, 'total': total});
                                  // print(itemList);
                                  // print(cartSnapshot.data()?['itemList'][0]['itemName']);
                                } else {
                                  // print(
                                  // 'Item is not in the cart. Add it to the cart!');
                                  setState(() {
                                    print('isPresentInCart' +
                                        isPresentInCart.toString());
                                    isPresentInCart = !isPresentInCart;
                                    print(temp);
                                    temp = 'Add';
                                    print(temp);
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
                            },
                            child: Text(temp)),
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
