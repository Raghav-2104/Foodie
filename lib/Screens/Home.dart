import 'package:canteen/Screens/Cart.dart';
import 'package:canteen/Screens/Menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'Profile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int index = 0;
  List<Widget> pages = [Menu(), Cart(), Profile()];
  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () async {
                await _auth.signOut();
              },
              icon: const Icon(Icons.logout),
            )
          ],
        ),
        body: pages[index],
        bottomNavigationBar: Container(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: GNav(
              onTabChange: (value) {
                setState(() {
                  index = value;
                  print(index);
                });
              },
              padding: const EdgeInsets.all(8),
              tabs: const [
                GButton(icon: (Icons.menu), text: 'Menu'),
                GButton(icon: (Icons.shopping_cart), text: 'Cart'),
                GButton(icon: (Icons.person), text: 'Profile'),
              ],
              color: Colors.white,
              activeColor: Colors.red,
              gap: 10,
              backgroundColor: Colors.black,
              tabBackgroundColor: Colors.grey.shade800,
            ),
          ),
        ));
  }
}
