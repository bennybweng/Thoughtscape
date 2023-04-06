import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thoughtscape/components/confirmation_dialog.dart';
import 'package:thoughtscape/pages/create_entry_page.dart';
import 'package:thoughtscape/shared/shared_prefs.dart';

import '../types/entry.dart';

class DisplayEntryPage extends StatefulWidget {

  Entry entry;

  DisplayEntryPage({Key? key, required this.entry}) : super(key: key);

  @override
  State<DisplayEntryPage> createState() => _DisplayEntryPageState();
}

class _DisplayEntryPageState extends State<DisplayEntryPage> {
  String? option;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => CreateEntryPage(entry: widget.entry,))).then((value) => setState((){widget.entry = value ?? widget.entry;}));
        }, icon: const Icon(Icons.edit)),
        IconButton(onPressed: () async {
          bool confirm = await _dialogBuilder(context) ?? false;
          if(!mounted) return;
          if (confirm) {
            SharedPrefs().deleteEntry(widget.entry);
            Navigator.pop(context);
          }

        }, icon: const Icon(Icons.delete)),
        IconButton(onPressed: (){}, icon: const Icon(Icons.share)),
      ],),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 0, 0),
            child: RichText(text: TextSpan(style: TextStyle(color: Theme.of(context).colorScheme.primary),
                children: [
                  TextSpan(text: widget.entry.date.day.toString().padLeft(2, "0"), style: const TextStyle(fontSize: 35, decoration: TextDecoration.underline)),
                  TextSpan(text: " ${DateFormat.MMM().format(widget.entry.date)}.", style: const TextStyle(fontSize: 30)),
                  TextSpan(text: " ${DateFormat.y().format(widget.entry.date)}", style: const TextStyle(fontSize: 25))
                ])),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 5, 0, 0),
            child: Text(widget.entry.title, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 25)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 5, 12, 0),
            child: Text(widget.entry.text, style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 15)),
          ),
        ],
      ),
    );
  }

  Future<bool?> _dialogBuilder(BuildContext context){
    return showDialog<bool>(context: context, builder: (BuildContext context){
      return const ConfirmationDialog(message: "Möchten Sie diesen Eintrag wirklich löschen?");
    });
  }
}
