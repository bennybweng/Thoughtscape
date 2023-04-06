import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../types/entry.dart';

class SharedPrefs{

  final String entryPrefix = "entry_";
  static late SharedPreferences _sharedPrefs;

  factory SharedPrefs() => SharedPrefs._internal();
  SharedPrefs._internal();


  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }


  bool entryExists(Entry entry){
    return _sharedPrefs.getKeys().where((String key) => key.isNotEmpty && key.startsWith(entryPrefix)).contains(entryPrefix + entry.title + entry.date.toIso8601String());
  }

  bool saveEntry(Entry entry){
    if (entryExists(entry)) {
      return false;
    }
    String key = entryPrefix + entry.title + entry.date.toIso8601String();
    _sharedPrefs.setString(key, jsonEncode(entry.toJson()));
    return true;
  }

  List<Entry> getEntries(){
    List<Entry> entries = [];
    for(String key in _sharedPrefs.getKeys().where((element) => element.startsWith(entryPrefix))){
      final entryJson = _sharedPrefs.getString(key);
      if (entryJson != null) {
        Entry entry = Entry.fromJson(jsonDecode(entryJson));
        entries.add(entry);
      }  
    }
    return entries;
  }

  void deleteEntry(Entry entry){
    _sharedPrefs.remove(entryPrefix + entry.title + entry.date.toIso8601String());
  }


}