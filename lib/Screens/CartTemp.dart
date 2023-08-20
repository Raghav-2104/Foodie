import 'package:canteen/Models/menu_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartTemp extends StatefulWidget {
  const CartTemp({super.key});

  @override
  State<CartTemp> createState() => _CartTempState();
}

class _CartTempState extends State<CartTemp> {
  @override
  Widget build(BuildContext context) {
    // Provider.of<MenuProvider>(context, listen: false)
    //     .getCartItemFromFirestore();
    return Consumer<MenuProvider>(
      builder: (context, value, child) {
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: value.getCartList.length,
                itemBuilder: (context, index) {
                  // print(value.cartList);
                  print(value.getCartList);
                  return ListTile(
                    title: Text(value.getCartList[index]['name']),
                    subtitle: Text('₹${value.getCartList[index]['price']}'),
                    trailing: IconButton(
                      onPressed: () {
                        Provider.of<MenuProvider>(context,listen: false).deleteFromCart(
                            index);
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  );
                },
              ),
            )
          ],
        );
      },
    );
  }
}