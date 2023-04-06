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
  bool _isDismissed = false;

  @override
  void initState() {
    reloadEntries();
    super.initState();
  }

  void reloadEntries() {
    setState(() {
      entries = SharedPrefs().getEntries();
      entries.sort((a, b) => b.date.compareTo(a.date));
    });
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
            for (Entry entry in entries)
              Dismissible(
                onUpdate: (DismissUpdateDetails details) {
                  if (details.reached) {
                    setState(() {
                      _isDismissed = true;
                    });
                  } else {
                    setState(() {
                      _isDismissed = false;
                    });
                  }
                },
                direction: DismissDirection.startToEnd,
                background: Container(
                  color: Colors.red,
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AnimatedSwitcher(
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return ScaleTransition(
                              scale: animation, child: child);
                        },
                        duration: const Duration(milliseconds: 300),
                        child: !_isDismissed
                            ? Icon(Icons.delete, key: Key("delete"),)
                            : Icon(Icons.delete_forever, key: Key("delete_confirm")),
                      ),
                    ],
                  ),
                ),
                key: Key(entry.title + entry.date.toIso8601String()),
                onDismissed: (direction) {
                  setState(() {
                    _isDismissed = true;
                    entries.remove(entry);
                    SharedPrefs().deleteEntry(entry);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("${entry.title} gelöscht"),
                      duration: const Duration(milliseconds: 1500),
                      action: SnackBarAction(
                          label: "Undo",
                          onPressed: () => setState(() {
                                SharedPrefs().saveEntry(entry);
                                reloadEntries();
                              })),
                    ));
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: EntryPreview(
                    entry: entry,
                    reloadEntries: reloadEntries,
                  ),
                ),
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
                      ).then((value) => reloadEntries());
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
