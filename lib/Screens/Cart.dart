import 'package:canteen/Screens/Orders.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Cart extends StatefulWidget {
  late bool isLoading;
  Cart({super.key, this.isLoading = false});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  static var total = 0;
  void press() {
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const OrderPage()));
  }

  void order() async {
    setState(() {
      widget.isLoading = true;
    });
    print('Ordering');
    print(_auth.currentUser?.email);
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final cartRef = firestore.collection('Cart').doc(_auth.currentUser?.email);
    var cart;
    await cartRef.get().then((DocumentSnapshot) {
      cart = DocumentSnapshot.data() as Map<String, dynamic>;
    });

    try {
    // Get the current order number
    final invoiceNumberRef = firestore
        .collection('InvoiceNumber')
        .doc(_auth.currentUser!.email)
        .collection('OrderNums')
        .doc('currentNumber');

    final orderNumberDoc = await invoiceNumberRef.get();
    int currentNumber = orderNumberDoc.exists ? orderNumberDoc.data()!['number'] : 0;

    // Increment the order number
    final nextNumber = currentNumber + 1;
    await invoiceNumberRef.set({'number': nextNumber});

    // Create the invoice with the incremented number
    firestore
        .collection('Orders')
        .doc(_auth.currentUser?.email)
        .collection('Invoice')
        .doc('Order: $nextNumber') // Use the incremented number as the document ID
        .set({
      'total': cart['total'],
      'itemList': cart['itemList'],
      'TimeStamp': DateTime.now().toString(),
    });
    
    print('Invoice created with order number: $nextNumber');

    // Clear the cart
    firestore
        .collection('Cart')
        .doc(_auth.currentUser?.email)
        .update({'itemList': [], 'total': 0});
    print('Cart Cleared');
  } catch (e) {
    print('error: $e');
  }

  setState(() {
    widget.isLoading = false;
  });

  Fluttertoast.showToast(
    msg: 'Order Created Successfully',
  );
  }

  @override
  Widget build(BuildContext context) {
    final docRef = firestore.collection('Cart').doc(_auth.currentUser?.email);

    return widget.isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: [
              Expanded(
                child: FutureBuilder<DocumentSnapshot>(
                  future: docRef.get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Text("Error:${snapshot.error}");
                    } else {
                      List cartItems = snapshot.data?.get('itemList');
                      if (cartItems.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.yellow[200],
                              ),
                              child: const Padding(
                                padding:  EdgeInsets.all(8.0),
                                child:  Text(
                                  'Delicious Food Is Waiting To Enter In Your Cart 😍',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'Times New Roman', fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      total = snapshot.data?.get('total');
                      return Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: cartItems.length,
                              itemBuilder: (context, index) {
                                // print(cartItems[index]);
                                return Card(
                                  color: Colors.blue[100],
                                  child: ListTile(
                                    leading: const CircleAvatar(
                                      backgroundImage:AssetImage('assets/nachos.png'),
                                    ),
                                    title: Text(
                                      cartItems[index]['itemName'],
                                      style: const TextStyle(
                                          fontFamily: 'Times New Roman',
                                          fontSize: 20,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    subtitle: Text(
                                      '₹ ${cartItems[index]['itemPrice']}',
                                      style: const TextStyle(
                                          fontFamily: 'Times New Roman',
                                          fontSize: 16,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black87),
                                    ),
                                    //add quantity stepper
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.remove,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              if (cartItems[index]['quantity'] >
                                                  1) {
                                                cartItems[index]['quantity']--;
                                                total = total -
                                                    int.parse(cartItems[index]
                                                        ['itemPrice']);
                                                docRef.update({
                                                  'itemList': cartItems,
                                                  'total': total
                                                });
                                              } else {
                                                total = total -
                                                    int.parse(cartItems[index]
                                                        ['itemPrice']);
                                                cartItems.removeAt(index);
                                                docRef.update({
                                                  'itemList': cartItems,
                                                  'total': total
                                                });
                                              }
                                            });
                                          },
                                        ),
                                        Text(
                                          cartItems[index]['quantity']
                                              .toString(),
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.add,
                                            color: Colors.green,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              cartItems[index]['quantity']++;
                                              total = total +
                                                  int.parse(cartItems[index]
                                                      ['itemPrice']);
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
                            ),
                          ),
                          Center(
                              child: Text(
                            'Total=₹$total',
                            style: const TextStyle(
                                fontFamily: 'Times New Roman',
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 2),
                          )),
                          Center(
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black),
                                  onPressed: order,
                                  child: const Text(
                                    'Proceed To Pay',
                                    style: TextStyle(
                                      fontFamily: 'Times New Roman',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1.5,
                                      // color: Colors.red
                                    ),
                                  )))
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          );
  }
}
