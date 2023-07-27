import 'package:flutter/material.dart';

class PopUpBox extends StatelessWidget {
  String title;
  String content;
  void Function()? onPressed;
  PopUpBox(this.content, this.title, this.onPressed, {super.key});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                onPressed?.call();
              },
              child: const Text('OK'),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ));
  }
}
