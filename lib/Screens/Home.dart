import 'package:canteen/Screens/AddProduct.dart';
import 'package:canteen/Screens/Cart.dart';
import 'package:canteen/Screens/Login.dart';
import 'package:canteen/Screens/Orders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'Menu.dart';
import 'Profile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLogin = true;

  void toggleScreen() {
    setState(() {
      isLogin = !isLogin;
    });
  }
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int index = 0;
  List<Widget> pages = [const Menu(),const Cart(), Profile(),const OrderPage(),const AdminPage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: const Text('Food Order'),
          actions: [
            IconButton(
              onPressed: () {
                _auth.signOut();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => LoginCustomer(onTap:toggleScreen ,)));
              },
              icon: const Icon(Icons.logout),
            )
          ],
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        body: SafeArea(child: pages[index]),
        bottomNavigationBar: Container(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: GNav(
              onTabChange: (value) {
                setState(() {
                  index = value;
                });
              },
              padding: const EdgeInsets.all(8),
              tabs: [
                const GButton(icon: (Icons.menu), text: 'Menu'),
                const GButton(icon: (Icons.shopping_cart), text: 'Cart'),
                const GButton(icon: (Icons.person), text: 'Profile'),
                const GButton(icon: (Icons.request_page_outlined), text: 'Your Orders'),
                if (_auth.currentUser?.email == 'test@ves.ac.in')
                  const GButton(icon: (Icons.edit), text: 'Edit Menu'),
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
