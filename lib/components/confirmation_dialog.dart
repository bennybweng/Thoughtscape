import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {

  final String message;

  const ConfirmationDialog({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsPadding: EdgeInsets.fromLTRB(0, 0, 8, 3),
      content: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Text(message, style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),),
      ),
      actions: [
        TextButton(onPressed: (){
          Navigator.pop(context, false);
        }, child: const Text("Cancel", style: TextStyle(fontSize: 15))),
        TextButton(onPressed: (){
          Navigator.pop(context, true);
        }, child: const Text("OK", style: TextStyle(fontSize: 15))),
      ],
    );
  }
}
