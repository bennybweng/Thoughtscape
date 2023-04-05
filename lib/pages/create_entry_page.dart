import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thoughtscape/types/entry.dart';

import '../shared/shared_prefs.dart';

class CreateEntryPage extends StatefulWidget {
  const CreateEntryPage({Key? key}) : super(key: key);

  @override
  State<CreateEntryPage> createState() => _CreateEntryPageState();
}

class _CreateEntryPageState extends State<CreateEntryPage> {
  DateTime date = DateUtils.dateOnly(DateTime.now());
  String title = "";
  String text = "";
  Mood mood = Mood("neutral");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ElevatedButton(onPressed: () {
              if(SharedPrefs().saveEntry(Entry(date: date, title: title, text: text, mood: mood))){
                Navigator.pop(context);
              }else{
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Entry with same date and title already exists")));
              }
            }, child: Text("Speichern")),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: ListView(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () async {
                  date = await showDatePicker(
                          helpText: "",
                          context: context,
                          initialDate: date,
                          firstDate: DateTime(DateTime.now().year - 100),
                          lastDate: DateTime(2100)) ??
                      date;
                  setState(() {});
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                          "${date.day.toString().padLeft(2, "0")}. ${DateFormat.MMM().format(date)}. ${date.year}"),
                      const Icon(Icons.arrow_drop_down)
                    ],
                  ),
                ),
              ),
            ),
            TextField(
              onChanged: (String str) {
                title = str;
              },
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: "Titel"),
            ),
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onChanged: (String str) {
                text = str;
              },
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Schreiben Sie hier mehr..."),
            ),
          ],
        ),
      ),
    );
  }
}
