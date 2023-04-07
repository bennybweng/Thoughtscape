import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thoughtscape/components/mood_dialog.dart';
import 'package:thoughtscape/types/entry.dart';

import '../shared/shared_prefs.dart';

class CreateEntryPage extends StatefulWidget {

  final Entry? entry;

  const CreateEntryPage({Key? key, this.entry}) : super(key: key);

  @override
  State<CreateEntryPage> createState() => _CreateEntryPageState();
}

class _CreateEntryPageState extends State<CreateEntryPage> {
  DateTime date = DateUtils.dateOnly(DateTime.now());
  String title = "";
  String text = "";
  Mood mood = Mood("neutral");

  @override
  void initState() {
    date = widget.entry == null ? DateUtils.dateOnly(DateTime.now()) : widget.entry!.date;
    title = widget.entry == null ? "" : widget.entry!.title;
    text = widget.entry == null ? "" : widget.entry!.text;
    mood = widget.entry == null ? Mood("neutral") : widget.entry!.mood;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ElevatedButton(onPressed: () {
              if (widget.entry == null) {
                if(SharedPrefs().saveEntry(Entry(date: date, title: title, text: text, mood: mood))){
                  Navigator.pop(context);
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Entry with same date and title already exists"), duration: Duration(milliseconds: 800),));
                }
              }else {
                if(SharedPrefs().editEntry(widget.entry!, Entry(date: date, title: title, text: text, mood: mood))){
                  Navigator.pop(context, Entry(date: date, title: title, text: text, mood: mood));
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Entry with same date and title already exists"), duration: Duration(milliseconds: 800),));
                }
              }
            }, child: Text("Speichern")),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () async {
                    date = await showDatePicker(
                            helpText: "",
                            context: context,
                            initialDate: date,
                            firstDate: DateTime(DateTime.now().year - 100),
                            lastDate: DateTime(DateTime.now().year + 100)) ??
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
                SizedBox(
                    height: 60,
                    width: 60,
                    child: IconButton(onPressed: () async {
                      String newMood = await _dialogBuilder(context) ?? "neutral";
                      setState(() {
                        mood = Mood(newMood);
                      });
                    }, icon: mood.toImage()))
              ],
            ),
            TextFormField(
              initialValue: widget.entry == null ? "" : widget.entry!.title,
              onChanged: (String str) {
                title = str;
              },
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: "Titel"),
            ),
            TextFormField(
              initialValue: widget.entry == null ? "" : widget.entry!.text,
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

  Future<String?> _dialogBuilder(BuildContext context){
    return showDialog<String>(context: context, builder: (BuildContext context){
      return const MoodDialog();
    });
  }
}
