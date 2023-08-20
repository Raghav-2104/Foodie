import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
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
              } else if (!snapshot.hasData) {
                return const Center(
                  child: Text("No Data Found"),
                );
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
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      child: ExpansionTile(
                        textColor: Colors.blue,
                        collapsedTextColor: Colors.black,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        collapsedShape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        backgroundColor: Colors.grey[300],
                        collapsedBackgroundColor: Colors.grey[300],
                        title: Text(
                          invoiceDocs[index].id,
                          style: const TextStyle(
                            fontFamily: 'Times New Roman',
                            letterSpacing: 1
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Order Date:  ${data['TimeStamp'].toString().substring(0, 16)}',
                              style: const TextStyle(
                                  fontSize: 18, fontFamily: 'Times New Roman'),
                            ),
                          ),
                          Text(
                            'Total Amount: ₹ ${data['total']}',
                            style: const TextStyle(
                                fontSize: 18, fontFamily: 'Times New Roman'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: List.generate(data['itemList'].length,
                                  (itemIndex) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16, right: 5,top: 5,bottom: 5),
                                        child: Text(
                                          '${data['itemList'][itemIndex]['itemName']}  :',
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'Times New Roman'),
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                      child: Text(
                                        '${data['itemList'][itemIndex]['quantity']}',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Times New Roman'),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
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
