import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:thoughtscape/components/entry_preview.dart';
import 'package:thoughtscape/pages/calender_page.dart';
import 'package:thoughtscape/pages/create_entry_page.dart';
import 'package:thoughtscape/pages/profile_page.dart';
import 'package:thoughtscape/pages/search_page.dart';
import 'package:document_file_save_plus/document_file_save_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:thoughtscape/pages/settings_page.dart';

import '../main.dart';
import '../shared/shared_prefs.dart';
import '../types/entry.dart';
import 'confirm_page.dart';

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
  bool lock = SharedPrefs().getLock();
  String shareValue = "";

  @override
  void initState() {
    reloadEntries();
    super.initState();
    shareValue = "txt";
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

  final WidgetStateProperty<Icon?> brightnessIcon =
      WidgetStateProperty.resolveWith<Icon?>(
    (Set<WidgetState> states) {
      // Thumb icon when the switch is selected.
      if (states.contains(WidgetState.selected)) {
        return const Icon(Icons.dark_mode_outlined);
      }
      return const Icon(Icons.light_mode);
    },
  );

  final WidgetStateProperty<Icon?> lockIcon =
      WidgetStateProperty.resolveWith<Icon?>(
    (Set<WidgetState> states) {
      // Thumb icon when the switch is selected.
      if (states.contains(WidgetState.selected)) {
        return const Icon(Icons.lock);
      }
      return const Icon(Icons.lock_open);
    },
  );

  Future<String> get _localPath async {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }

  Future<File> get _localJson async {
    final path = await _localPath;
    return File('$path/entries.json');
  }

  Future<File> get _localTxt async {
    final path = await _localPath;
    return File('$path/entries.txt');
  }

  Future<void> saveJson() async {
    final file = await _localJson;
    Map<String, dynamic> output = {
      "entries": [for (Entry entry in entries) entry.toJson()]
    };
    await file.writeAsString(jsonEncode(output));
    await Share.shareXFiles([XFile(file.path)]);
  }

  Future<void> saveTxt() async {
    final file = await _localTxt;
    String output = "";
    for (Entry entry in entries) {
      output +=
          "${entry.date.day.toString().padLeft(2, "0")}-${entry.date.month.toString().padLeft(2, "0")}-${entry.date.year}\n\n";
      output += "${entry.title}\n\n";
      output += "${entry.text}\n\n";
      output += "mood: ${entry.mood.info}\n";
      output += "----- \n";
    }
    await file.writeAsString(jsonEncode(output));
    await Share.shareXFiles([XFile(file.path)]);
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
                          builder: (BuildContext context) => SearchPage(
                                entries: entries,
                              ))).then((_) => reloadEntries());
                },
                icon: Icon(Icons.search)),
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
              const DrawerHeader(
                padding: EdgeInsets.fromLTRB(16, 4, 16, 8),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/header.png"),
                        fit: BoxFit.cover)),
                child: Text("Thoughtscape",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    )),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text("Settings"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => SettingsPage()));
                },
              ),
              ListTile(
                leading: Icon(Icons.lock),
                title: Text("Lock"),
                trailing: Switch(
                  thumbIcon: lockIcon,
                  onChanged: (bool value) {
                    setState(() {
                      lock = value;
                    });
                    SharedPrefs().setLock(value);
                  },
                  value: lock,
                ),
              ),
              ListTile(
                leading: Icon(Icons.brightness_6_outlined),
                title: Text("Brightness"),
                trailing: Switch(
                  thumbIcon: brightnessIcon,
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
              ),
              ListTile(
                leading: Icon(Icons.download),
                title: Text("Download"),
                onTap: () async {
                  String output = "";
                  for (Entry entry in entries) {
                    output += "${entry.date.toIso8601String()}\n";
                    output += "${entry.title}\n";
                    output += "${entry.text}\n";
                    output += "${entry.mood.info}\n";
                    output += "----- \n";
                  }
                  await DocumentFileSavePlus().saveFile(
                      Uint8List.fromList(utf8.encode(output)),
                      "entries.txt",
                      "text/plain");
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("Downloaded")));
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text("Export"),
                onTap: () async {
                  Map<String, dynamic> output = {
                    "entries": [for (Entry entry in entries) entry.toJson()]
                  };
                  print(jsonEncode(output));
                  await DocumentFileSavePlus().saveFile(
                      Uint8List.fromList(utf8.encode(jsonEncode(output))),
                      "entries_${DateTime.now().toIso8601String()}.json",
                      "application/json");
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("Downloaded")));
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.ios_share),
                title: Text("Import"),
                onTap: () async {
                  final result = await FilePicker.platform.pickFiles(
                      type: FileType.custom, allowedExtensions: ['json']);
                  if (result == null) return;
                  final file = File(result.files.first.path!);
                  final contents = await file.readAsString();
                  if (context.mounted) {
                    print(contents);
                    List<Entry> newEntries = [];
                    final json = jsonDecode(contents);
                    final entriesJson = json['entries'] ?? [];
                    for (Map<String, dynamic> jsonEntry in entriesJson) {
                      newEntries.add(Entry.fromJson(jsonEntry));
                    }
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => ConfirmPage(
                                  entries: newEntries,
                                ))).then((_) async {
                      if (_ ?? false == true) {
                        Map<String, dynamic> output = {
                          "entries": [
                            for (Entry entry in entries) entry.toJson()
                          ]
                        };
                        await DocumentFileSavePlus().saveFile(
                            Uint8List.fromList(utf8.encode(jsonEncode(output))),
                            "backup_${DateTime.now().toIso8601String()}.json",
                            "application/json");
                        if (context.mounted) {
                          SharedPrefs().removeAllEntries();
                          for (Entry entry in newEntries) {
                            SharedPrefs().saveEntry(entry);
                          }
                          reloadEntries();
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Imported")));
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Import cancelled")));
                      }
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.cloud_upload),
                title: const Text("Sync"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => SettingsPage()));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.reply,
                  textDirection: TextDirection.rtl,
                ),
                title: const Text("Share"),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(builder: (context, setState){
                          return AlertDialog(
                            title: Text("Share as"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                RadioListTile(
                                  title: Text(".txt"),
                                    value: "txt",
                                    groupValue: shareValue,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        shareValue = newValue!;
                                      });
                                    }),
                                RadioListTile(
                                  title: Text(".json"),
                                    value: "json",
                                    groupValue: shareValue,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        shareValue = newValue!;
                                      });
                                    })
                              ],
                            ),
                            actions: [
                              TextButton(
                                child: Text('CANCEL'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              //Ok Button
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  if (shareValue == "txt") {
                                    saveTxt();
                                  }else{
                                    saveJson();
                                  }
                                },
                              ),
                            ],
                          );
                        });
                      });
                },
              ),
              const AboutListTile(
                icon: Icon(Icons.info),
                applicationName: "Thoughtscape",
                applicationVersion: "1.0",
                aboutBoxChildren: [
                  Text(
                      "Thoughtscape is a digital diary app designed to help you capture and explore your inner thoughts and experiences.")
                ],
              ),
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
                      duration: const Duration(milliseconds: 2500),
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
              ),
            SizedBox(
              height: 50,
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
                    ).then((_) => reloadEntries());
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
                              },
                              icon: Icon(
                                selectedColor == colorOptions[index]
                                    ? Icons.circle
                                    : Icons.circle_outlined,
                                color: colorOptions[index],
                              )))),
                )),
          );
        });
  }
}
