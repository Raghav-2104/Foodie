import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _price = TextEditingController();
  // TextEditingController _quantity = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {

    return Container(
      child: Column(
        children: [
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Add Product'),
                          content: SingleChildScrollView(
                            child: Column(
                              children: [
                                TextField(
                                  decoration: const InputDecoration(
                                    labelText: 'Product Name',
                                  ),
                                  keyboardType: TextInputType.text,
                                  controller: _name,
                                ),
                                TextField(
                                  decoration: const InputDecoration(
                                    labelText: 'Product Price',
                                  ),
                                  keyboardType: TextInputType.number,
                                  controller: _price,
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            Padding(
                              padding: const EdgeInsets.only(right: 30),
                              child: ElevatedButton(
                                onPressed: () {
                                  firestore
                                      .collection('Menu')
                                      .doc(_name.text)
                                      .set({
                                    'name': _name.text,
                                    'price': _price.text,
                                    // 'quantity': _quantity.text,
                                  });
                                  _name.clear();
                                  _price.clear();
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 30),
                              child: ElevatedButton(
                                onPressed: () {
                                  _name.clear();
                                  _price.clear();
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel'),
                              ),
                            )
                          ],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        );
                      });
                },
                child: Text('Add Product'),
              ),
            ],
          ),
          StreamBuilder<QuerySnapshot>(
            stream: firestore.collection('Menu').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Expanded(
                    child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(snapshot.data!.docs[index]['name']),
                        subtitle: Text("₹"+snapshot.data!.docs[index]['price']),
                        trailing: IconButton(
                          onPressed: () {
                            firestore
                                .collection('Menu')
                                .doc(snapshot.data!.docs[index]['name'])
                                .delete();
                          },
                          icon: Icon(Icons.delete),
                        ),
                      ),
                    );
                  },
                ));
              }
            },
          )
        ],
      ),
    );
  }
}
