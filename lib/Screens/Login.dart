import 'package:canteen/Screens/ForgetPassword.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:canteen/Authentication/auth.dart';
import 'Home.dart';
import 'Register.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginCustomer extends StatefulWidget {
  final Function onTap;
  LoginCustomer({required this.onTap});

  @override
  State<LoginCustomer> createState() => _LoginCustomerState();
}

class _LoginCustomerState extends State<LoginCustomer> {
  final _formKey = GlobalKey<FormState>();
  final Auth _auth = Auth();
  FirebaseAuth auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;
  Future googleLogin() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;
    _user = googleUser;
    print(googleUser.email);

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pop(context);
      FirebaseFirestore.instance.collection('users').doc(_user?.email).set({
        'Email': user.email,
        'Name': user.displayName,
        'Phone Number':'Please Update Your Phone Number',
        'photo': user.photoUrl,
      });
      FirebaseFirestore.instance
          .collection('Cart')
          .doc(auth.currentUser?.email)
          .set({'itemList': [], 'total': 0});

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const Home();
      }));
    } catch (e) {
      print(e.toString());
    }
    // return const HomePage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          'Foodie',
          style: TextStyle(
              color: Colors.red,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              fontFamily: 'Times New Roman'),
        ),
        elevation: 3.0,
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const CircleAvatar(
              backgroundImage: AssetImage('assets/logo2.png'),
              radius: 125,
            ),
            const SizedBox(
              height: 20,
            ),
            //Email TextField
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: TextFormField(
                key: ValueKey(email),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter A Username';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  setState(() {
                    email = value!;
                  });
                },
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  fillColor: Colors.grey[50],
                  filled: true,
                  hintText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  prefixIconColor: Colors.black,
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            //Password TextField
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: TextFormField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  fillColor: Colors.grey[50],
                  filled: true,
                  hintText: 'Password',
                  prefixIcon: const Icon(
                    Icons.password_rounded,
                  ),
                  prefixIconColor: Colors.black,
                ),
                obscureText: true,
                key: ValueKey(password),
                validator: (value) {
                  if (value!.length < 8) {
                    return 'Password too short';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  setState(() {
                    password = value!;
                  });
                },
              ),
            ),

            //Login Button
            Padding(
              padding: const EdgeInsets.only(left: 60, top: 20),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      _formKey.currentState!.save();
                      if (_formKey.currentState!.validate()) {
                        dynamic result = await _auth.signInWithEmailAndPassword(
                            email, password);
                        if (result != null) {
                          Navigator.pop(context);
                          FirebaseFirestore.instance
                              .collection('Cart')
                              .doc(auth.currentUser?.email)
                              .set({'itemList': [], 'total': 0});
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Home()));
                        } else {
                          // ignore: use_build_context_synchronously
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                  title: const Text('Error'),
                                  content: const Text('Invalid Credentials'),
                                  actions: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 30),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ),
                                  ],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ));
                            },
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 20,
                  ),

                  //Forget Password Button

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ForgetPassword()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Forget Password',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //Register Button
            const SizedBox(
              height: 5,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              // child: CupertinoButton(
              //   onPressed: googleAuth,
              //   color: Colors.black,
              //   child: const Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Image(
              //         image: AssetImage('assets/google.png'),
              //         height: 50,
              //         width: 50,
              //       ),
              //       SizedBox(
              //         width: 5,
              //       ),
              //       Text(
              //         'Login with Google',
              //         style: TextStyle(
              //             fontSize: 20,
              //             fontWeight: FontWeight.w500,
              //             color: (Colors.red)),
              //       ),
              //     ],
              //   ),
              // ),
              child: GestureDetector(
                onTap: googleLogin,
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage('assets/google.png'),
                        height: 50,
                        width: 50,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Login with Google',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: (Colors.red)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                const Padding(padding: EdgeInsets.symmetric(horizontal: 50)),
                const Text(
                  'Not a User?',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                GestureDetector(
                  onTap: () {
                    // widget.toggleView();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Registration(
                                  onTap: widget.onTap,
                                )));
                  },
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
