import 'package:canteen/Models/menu_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuTemp extends StatefulWidget {
  const MenuTemp({super.key});

  @override
  State<MenuTemp> createState() => _MenuTempState();
}

class _MenuTempState extends State<MenuTemp> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MenuProvider>(
      builder: (context, value, child) {
        return ListView.builder(
          itemCount: value.getItemList.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(
                value.getItemList[index]['name'],
                style: const TextStyle(
                    fontFamily: 'Times New Roman',
                    fontSize: 20,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                '₹${value.getItemList[index]['price']}',
                style: const TextStyle(
                    fontFamily: 'Times New Roman',
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w300,
                    color: Colors.black54),
              ),
            ),
          );
        },
        );
      },
    );
  }
}
