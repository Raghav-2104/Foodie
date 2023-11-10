import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController emailController = TextEditingController();
   var _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  // ignore: unused_field
  bool _isEmailSent = false;
  String _emailError='';
  final String _emailSentSuccess = "Email Sent Successfully";
  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
  }
  void sendEmail() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: emailController.text);
        setState(() {
          _isLoading = false;
          _isEmailSent = true;
        });
        Fluttertoast.showToast(msg: _emailSentSuccess);
      } catch (e) {
        print(e);
        setState(() {
          _isLoading = false;
          _isEmailSent = false;
          _emailError = e.toString();
        });
        Fluttertoast.showToast(msg: _emailError);
      }
    }
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
            key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: TextField(
                      controller: emailController,
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
                  ElevatedButton(
                    onPressed: sendEmail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text('Send Email'),
                  )
                ],
              ),
            ),
    );
  }
}
