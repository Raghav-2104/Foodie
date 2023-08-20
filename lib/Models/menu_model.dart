import 'package:canteen/Screens/Menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MenuProvider extends ChangeNotifier {
  //Get Menu from Firebase and store it in a list
  List<Map<String, dynamic>> itemList = [];
  List<Map<String, dynamic>> get getItemList => itemList;
  MenuProvider() {
    getMenu();
    getCartListFromFirestore();
    getTotal();
    // print('Menu Provider\n${itemList}');
  }
  Future<void> getMenu() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var snapshot = await firestore.collection('Menu').get();
    for (var doc in snapshot.docs) {
      itemList.add({'name': doc['name'], 'price': doc['price']});
    }
    notifyListeners();
  }

  //make a cart list
  List<Map<String, dynamic>> cartList = [];
  List<Map<String, dynamic>> get getCartList => cartList;
  //get the item from menu and add it to cart and store it in firestrore
  void getCartItemFromFirestore() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore
        .collection('Cart')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get()
        .then((value) {
      if (value.exists) {
        for (var item in value['itemList']) {
          cartList.add({'name': item['itemName'], 'price': item['itemPrice']});
        }
      }
      // print(getCartList);
      notifyListeners();
    });
  }

  void addToCart(String name, int price) async {
    cartList.add({'name': name, 'price': price});
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore
        .collection('Cart')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .set({'itemList': cartList});
    notifyListeners();
  }

  void deleteFromCart(int index) {
    cartList.removeAt(index);
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore
        .collection('Cart')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .update({'itemList': cartList});
    notifyListeners();
  }

  //get the cart list from firestore
  void getCartListFromFirestore() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var snapshot = await firestore
        .collection('Cart')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get();

    print(snapshot['itemList']);
    for (var doc in snapshot['itemList']) {
      cartList.add({'name': doc['itemName'], 'price': doc['itemPrice']});
    }

    notifyListeners();
  }

  void getTotal() {
    int total = 0;
    for (var item in cartList) {
      total += int.parse(item['price']);
    }
    //Update total in firestore
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore
        .collection('Cart')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .update({'total': total});
  }
}
