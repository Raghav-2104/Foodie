import 'package:canteen/Widgets/ProfileCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Profile extends StatefulWidget {
  Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? userData;

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    final docRef = firestore.collection("users").doc(user?.email);

    return FutureBuilder<DocumentSnapshot>(
      future: docRef.get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error getting document: ${snapshot.error}');
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Text('Document does not exist');
        }

        var data = snapshot.data!.data() as Map<String, dynamic>;
        userData = data;
        print(userData!['photo']);
        return Container(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Center(
                child: CircleAvatar(
                  backgroundImage: userData!['photo'] != null
                      ? NetworkImage(userData!['photo']) as ImageProvider<Object>?
                      : AssetImage('assets/man.png'),
                  backgroundColor: Colors.red,
                  radius: 80,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ProfileCard(
                title: 'Name',
                data: userData!['Name'],
                onProfileDataChanged: (title, newData) {
                  setState(() {
                    userData![title] = newData;
                  });
                },
              ),
              Card(
                // color: Colors.grey[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: const Text(
                    'Email :',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.blueGrey),
                  ),
                  subtitle: Text(
                    userData!['Email'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black,
                        letterSpacing: 1),
                  ),
                ),
              ),
              ProfileCard(
                title: 'Phone Number',
                data: userData!['Phone Number'],
                onProfileDataChanged: (title, newData) {
                  setState(() {
                    userData![title] = newData;
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

