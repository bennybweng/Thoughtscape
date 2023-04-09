import 'package:flutter/material.dart';
import 'package:thoughtscape/components/entry_preview.dart';
import 'package:thoughtscape/pages/calender_page.dart';
import 'package:thoughtscape/pages/create_entry_page.dart';
import 'package:thoughtscape/pages/profile_page.dart';
import 'package:thoughtscape/pages/search_page.dart';

import '../main.dart';
import '../shared/shared_prefs.dart';
import '../types/entry.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

const Color m3BaseColor = Color(0xff6750a4);
const List<Color> colorOptions = [
  m3BaseColor,
  Colors.indigo,
  Colors.blue,
  Colors.teal,
  Colors.green,
  Colors.yellow,
  Colors.orange,
  Colors.deepOrange,
  Colors.pink
];

class _HomePageState extends State<HomePage> {
  List<Entry> entries = [];
  bool _isDismissed = false;
  String sort = "neuste zuerst";
  Color selectedColor = colorOptions[SharedPrefs().getColor()];

  @override
  void initState() {
    reloadEntries();
    super.initState();
  }

  void reloadEntries() {
    setState(() {
      entries = SharedPrefs().getEntries();
      if (sort == "älteste zuerst") {
        entries.sort((a, b) => a.date.compareTo(b.date));
      } else {
        entries.sort((a, b) => b.date.compareTo(a.date));
      }
    });
  }

  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      // Thumb icon when the switch is selected.
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.dark_mode_outlined);
      }
      return const Icon(Icons.light_mode);
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SearchPage(entries: entries,))).then((_) => reloadEntries());
            }, icon: Icon(Icons.search)),
            PopupMenuButton<String>(
                initialValue: sort,
                onSelected: (String newSort) {
                  setState(() {
                    sort = newSort;
                    reloadEntries();
                  });
                },
                icon: const Icon(Icons.tune),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      const PopupMenuItem(
                        value: "neuste zuerst",
                        child: Text("neuste zuerst"),
                      ),
                      const PopupMenuDivider(
                        height: 0,
                      ),
                      const PopupMenuItem(
                        value: "älteste zuerst",
                        child: Text("älteste zuerst"),
                      ),
                    ])
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(child: Text("Thoughtscape")),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text("Settings"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.brightness_6_outlined),
                title: Text("Brightness"),
                trailing: Switch(
                  thumbIcon: thumbIcon,
                  value: Theme.of(context).brightness == Brightness.dark,
                  onChanged: (bool value) {
                    value == true
                        ? MyApp.of(context).changeTheme(ThemeMode.dark)
                        : MyApp.of(context).changeTheme(ThemeMode.light);
                  },
                ),
              ),
              ListTile(
                leading: Icon(Icons.color_lens_outlined),
                title: Text("Color"),
                onTap: () {
                  _colorDialogBuilder(context);
                },
              )
            ],
          ),
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
                            ? Icon(
                                Icons.delete,
                                key: Key("delete"),
                              )
                            : Icon(Icons.delete_forever,
                                key: Key("delete_confirm")),
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

  Future<void> _colorDialogBuilder(BuildContext context) {
    return showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            alignment: Alignment.bottomCenter,
            insetPadding: EdgeInsets.fromLTRB(0, 0, 0, 50),
            child: SizedBox(
                height: 300,
                width: 300,
                child: GridView.count(
                  crossAxisCount: 3,
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(
                      9,
                      (index) => Center(
                          child: IconButton(
                              onPressed: () {
                                MyApp.of(context).changeColor(index);
                                setState(() {
                                  selectedColor = colorOptions[index];
                                });
                              }, icon: Icon(selectedColor == colorOptions[index] ? Icons.circle : Icons.circle_outlined, color: colorOptions[index],)))),
                )),
          );
        });
  }
}
