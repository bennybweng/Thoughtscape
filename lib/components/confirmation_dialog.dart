import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {

  final String message;

  const ConfirmationDialog({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Text(message, style: TextStyle(fontSize: 20),),
      ),
      actions: [
        TextButton(onPressed: (){
          Navigator.pop(context, false);
        }, child: const Text("Cancel", style: TextStyle(fontSize: 20))),
        TextButton(onPressed: (){
          Navigator.pop(context, true);
        }, child: const Text("OK", style: TextStyle(fontSize: 20))),
      ],
    );
  }
}
