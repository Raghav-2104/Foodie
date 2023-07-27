import 'package:flutter/material.dart';
import '../Authentication/auth.dart';
import '../Widgets/PopUpBox.dart';
import 'Login.dart';
//Errors in Validation
class Registration extends StatefulWidget {
  final Function onTap;
  Registration({required this.onTap});
  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _formKey = GlobalKey<FormState>();
  final Auth _auth = Auth();
  String name = '';
  String email = '';
  String phoneNumber = '';
  String password = '';
  String confirm = '';
  void pressed() {
    print('In Func');
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginCustomer(onTap: widget.onTap,)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          'Registration',
          style: TextStyle(
            fontSize: 20,
            color: Colors.red[900],
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            //Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: TextFormField(
                // key: _formKey,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  filled: true,
                  fillColor: Colors.grey[300],
                  hintText: 'Name',
                ),
                enableSuggestions: true,
                validator: (value) {
                  if (name.isEmpty) {
                    return 'Enter your name';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: TextFormField(
                // key: _formKey,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  filled: true,
                  fillColor: Colors.grey[300],
                  hintText: 'VES Email',
                ),
                enableSuggestions: true,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (email.isEmpty || !email.contains('@ves.ac.in')) {
                    return 'Enter your VES email';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: TextFormField(
                // key: _formKey,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  filled: true,
                  fillColor: Colors.grey[300],
                  hintText: 'Phone Number',
                ),
                keyboardType: TextInputType.phone,
                enableSuggestions: true,
                validator: (value) {
                  if (phoneNumber.isEmpty) {
                    return 'Enter your Mobile Number';
                  } else if (phoneNumber.length != 10) {
                    return 'Enter correct Mobile Number';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  setState(() {
                    phoneNumber = value;
                  });
                },
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: TextFormField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  filled: true,
                  fillColor: Colors.grey[300],
                  hintText: 'Password',
                ),
                enableSuggestions: true,
                validator: (value) {
                  if (password.isEmpty) {
                    return 'Enter a password';
                  } else if (password.length < 8) {
                    return 'Password too short';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: TextFormField(
                // key: _formKey,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  filled: true,
                  fillColor: Colors.grey[300],
                  hintText: 'Confirm Password',
                ),
                enableSuggestions: true,
                validator: (value) {
                  if (confirm.isEmpty) {
                    return 'Please enter password again';
                  } else if (confirm != password) {
                    return "Password doesn't matched";
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  setState(() {
                    confirm = value;
                  });
                },
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    dynamic result = await _auth.registerWithEmailAndPassword(
                        email, password);
                    if (result != null) {
                      print(result);
                      // ignore: use_build_context_synchronously
                      showDialog(
                          context: context,
                          builder: ((context) {
                            return PopUpBox(
                                'Registration Successful', 'Congrats', () {
                              pressed();
                            });
                          }));
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.red[900],
                ),
                child: const Text('Register'))
          ],
        ),
      ),
    );
  }
}
