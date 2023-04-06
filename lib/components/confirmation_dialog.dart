import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {

  final String message;

  const ConfirmationDialog({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(message),
      actions: [
        TextButton(onPressed: (){
          Navigator.pop(context, false);
        }, child: const Text("Cancel")),
        TextButton(onPressed: (){
          Navigator.pop(context, true);
        }, child: const Text("OK")),
      ],
    );
  }
}
