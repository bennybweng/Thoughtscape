import 'package:flutter/material.dart';
import 'package:thoughtscape/components/entry_preview.dart';
import 'package:thoughtscape/pages/calender_page.dart';
import 'package:thoughtscape/pages/create_entry_page.dart';
import 'package:thoughtscape/pages/profile_page.dart';

import '../shared/shared_prefs.dart';
import '../types/entry.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Entry> entries = [];

  @override
  void initState() {
    reloadEntries();
    super.initState();
  }

  void reloadEntries() {
    entries = SharedPrefs().getEntries();
    entries.sort((a,b) => b.date.compareTo(a.date));
    print(entries.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Homepage'),
        ),
        body: ListView(
          children: [
            for(Entry entry in entries)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: EntryPreview(entry: entry),
              )
          ],
        ),
        floatingActionButton: SizedBox(
            width: 80,
            height: 80,
            child: FittedBox(
                child: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreateEntryPage()),
                      ).then((value) => {
                            setState(() {
                              reloadEntries();
                            })
                          });
                    },
                    child: const Icon(Icons.add)))),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CalenderPage()),
                    );
                  },
                  icon: Icon(Icons.calendar_month_outlined),
                  iconSize: 40,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfilePage()),
                    );
                  },
                  icon: Icon(Icons.person),
                  iconSize: 40,
                ),
              ],
            ),
          ),
        ));
  }
}
