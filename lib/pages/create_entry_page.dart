import 'package:flutter/material.dart';

class CreateEntryPage extends StatefulWidget {
  const CreateEntryPage({Key? key}) : super(key: key);

  @override
  State<CreateEntryPage> createState() => _CreateEntryPageState();
}

class _CreateEntryPageState extends State<CreateEntryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text("Entry Page"),),
    );
  }
}
