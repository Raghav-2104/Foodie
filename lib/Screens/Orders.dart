import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        const Text('Your Orders'),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Orders')
                .doc(_auth.currentUser?.email)
                .collection('Invoice')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Text("Error:${snapshot.error}");
              } else {
                final invoiceDocs = snapshot.data!.docs;
                for (var invoiceDoc in invoiceDocs) {
                  Map<String, dynamic> data =
                      invoiceDoc.data() as Map<String, dynamic>;

                  if (data != null) {
                    print(data);
                    // Access individual fields in the 'data' map
                  }
                }
                return ListView.builder(
                  itemCount: invoiceDocs.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> data =
                        invoiceDocs[index].data() as Map<String, dynamic>;
                    return ExpansionTile(
                      title: Text(invoiceDocs[index].id),
                      children: [
                        Text('Order Date:  ${data['TimeStamp'].toString().substring(0,16)}'),
                        Text('Total Amount: ₹${data['total']}'),
                        Column(
                          children: List.generate(data['itemList'].length,
                              (itemIndex) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: Text(data['itemList'][itemIndex]
                                            ['itemName']
                                        .toString())),
                                Text(
                                    ':${data['itemList'][itemIndex]['quantity']}'),
                              ],
                            );
                          }),
                        ),
                      ],
                    );
                  },
                );
              }
            },
          ),
        )
      ],
    ));
  }
}
