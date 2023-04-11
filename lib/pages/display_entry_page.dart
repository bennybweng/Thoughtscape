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
  late final PageController _controller;
  late List<Entry> entries;
  String? option;

  @override
  void initState() {
    entries = SharedPrefs().getEntries();
    entries.sort((a, b) => b.date.compareTo(a.date));
    _controller = PageController(initialPage: entries.indexOf(widget.entry));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => CreateEntryPage(
                                entry: widget.entry,
                              ))).then((value) => setState(() {
                        widget.entry = value ?? widget.entry;
                        entries = SharedPrefs().getEntries();
                        entries.sort((a, b) => b.date.compareTo(a.date));
                        _controller.jumpToPage(entries.indexOf(widget.entry));
                      }));
                },
                icon: const Icon(Icons.edit)),
            IconButton(
                onPressed: () async {
                  bool confirm = await _dialogBuilder(context) ?? false;
                  if (!mounted) return;
                  if (confirm) {
                    SharedPrefs().deleteEntry(widget.entry);
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.delete)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
          ],
        ),
        body: PageView(
          onPageChanged: (int index) {
            setState(() {
              widget.entry = entries[index];
            });
          },
          controller: _controller,
          children: [
            for (Entry entry in entries)
              ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 8, 0, 0),
                        child: RichText(
                            text: TextSpan(
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                children: [
                              TextSpan(
                                  text:
                                      entry.date.day.toString().padLeft(2, "0"),
                                  style: const TextStyle(
                                      fontSize: 35,
                                      decoration: TextDecoration.underline)),
                              TextSpan(
                                  text:
                                      " ${DateFormat.MMM(Localizations.localeOf(context).toString()).format(entry.date)}.",
                                  style: const TextStyle(fontSize: 30)),
                              TextSpan(
                                  text:
                                      " ${DateFormat.y(Localizations.localeOf(context).toString()).format(entry.date)}",
                                  style: const TextStyle(fontSize: 25))
                            ])),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 12, 0),
                        child: SizedBox(
                            height: 40, width: 40, child: entry.mood.toImage()),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 5, 0, 0),
                    child: Text(entry.title,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 25)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 5, 12, 0),
                    child: Text(entry.text,
                        style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.7),
                            fontSize: 15)),
                  ),
                ],
              ),
          ],
        ));
  }

  Future<bool?> _dialogBuilder(BuildContext context) {
    return showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return const ConfirmationDialog(
              message: "Möchten Sie diesen Eintrag wirklich löschen?");
        });
  }

/*int indexOfEntries(List<Entry> entries, Entry entry){
    for(var i = 0; i < entries.length; i++){

    }
  }*/
}
