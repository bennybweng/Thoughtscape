import 'package:flutter/material.dart';
import 'package:thoughtscape/shared/shared_prefs.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  String shareValue = SharedPrefs().getStatisticsStyle();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings"),),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.data_usage),
            title: Text("Statistics Style"),
            onTap: (){
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(builder: (context, setState){
                      return AlertDialog(
                        title: Text("Statistics Style"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            RadioListTile(
                                title: Text("simple"),
                                value: "simple",
                                groupValue: shareValue,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    shareValue = newValue!;
                                  });
                                }),
                            RadioListTile(
                                title: Text("colorful"),
                                value: "colorful",
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
                              SharedPrefs().setStatisticsStyle(shareValue);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    });
                  });
            },
          )
        ],
      ),
    );
  }
}
