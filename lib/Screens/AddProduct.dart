import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../Keys/Unsplash.dart';

const accessKey = Unsplash.UnSplashACCESSKEY;

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _price = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isLoading = false;

  getData(String query) async {
    String url =
        'https://api.unsplash.com/search/photos?query=$query&client_id=$accessKey';
    var response = await Dio().get(url);
    var link = await response.data['results'][0]['urls']['small'];
    // Download the image from the link
    var response2 = await Dio()
        .get(link, options: Options(responseType: ResponseType.bytes));
    var imageData = response2.data;
    // Save the image to Firebase Storage
    var storageRef = FirebaseStorage.instance.ref().child('images/$query.jpg');
    var uploadTask = storageRef.putData(imageData);
    await uploadTask
        .whenComplete(() => print('Image uploaded to Firebase Storage'));
  }

  final FirebaseStorage storageRef = FirebaseStorage.instance;
  getImageFromFireStorage(String name) async {
    await getData(name);
    var ref = storageRef.ref().child('images/$name.jpg');
    var url = await ref.getDownloadURL();
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
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
                          onPressed: () async {
                            var image = await getImageFromFireStorage(_name.text);
                            
                            firestore
                                .collection('Menu')
                                .doc(_name.text)
                                .set({
                              'name': _name.text,
                              'price': _price.text,
                              'image': image
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
          child: const Icon( Icons.add)
        ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: firestore.collection('Menu').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
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
                        subtitle: Text('₹ ${snapshot.data!.docs[index]['price']}'),
                        trailing: IconButton(
                          onPressed: () {
                            firestore
                                .collection('Menu')
                                .doc(snapshot.data!.docs[index]['name'])
                                .delete();
                          },
                          icon: const Icon(Icons.delete),
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
