import 'package:flutter/material.dart';
import 'package:thoughtscape/components/entry_preview.dart';
import 'package:thoughtscape/shared/shared_prefs.dart';
import 'package:thoughtscape/types/entry.dart';

class SearchPage extends StatefulWidget {
  List<Entry> entries;

  SearchPage({Key? key, required this.entries}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  String searchWord = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
              hintText: "Suche in Tagebüchern",
              hintStyle: TextStyle(fontWeight: FontWeight.normal)),
          onChanged: (String value){
            setState(() {
              searchWord = value;
            });
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
        child: ListView(
          children: [
            for (Entry entry in widget.entries)
              if (entry.text.toLowerCase().contains(searchWord.toLowerCase()) || entry.title.toLowerCase().contains(searchWord.toLowerCase()))
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: EntryPreview(entry: entry, reloadEntries: reloadEntries),
                )

          ],
        ),
      ),
    );
  }

  void reloadEntries(){
    setState(() {
      widget.entries = SharedPrefs().getEntries();
      widget.entries.sort((a, b) => b.date.compareTo(a.date));
    });
  }
}
