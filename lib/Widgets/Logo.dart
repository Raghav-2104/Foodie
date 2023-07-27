import 'package:flutter/material.dart';

class Logo extends StatefulWidget {
  const Logo({super.key});

  @override
  State<Logo> createState() => _LogoState();
}

class _LogoState extends State<Logo> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 60, left: 0),
      child: CircleAvatar(
        backgroundImage: AssetImage('assets/Logo.png'),
        radius: 70,
      ),
    );
  }
}
