import 'dart:convert';

import 'package:flutter/material.dart';
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

  bool editEntry(Entry oldEntry, Entry newEntry){
    if (entryExists(newEntry) && (oldEntry.title != newEntry.title || oldEntry.date != newEntry.date)) {
      return false;
    }
    deleteEntry(oldEntry);
    String key = entryPrefix + newEntry.title + newEntry.date.toIso8601String();
    _sharedPrefs.setString(key, jsonEncode(newEntry.toJson()));
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

  ThemeMode getBrightness(){
    return _sharedPrefs.getBool("Brightness") == null ? ThemeMode.system : (_sharedPrefs.getBool("Brightness")! ? ThemeMode.light : ThemeMode.dark);
  }

  int getColor(){
    return _sharedPrefs.getInt("Color") ?? 0;
  }

  void setBrightness(ThemeMode themeMode){
    _sharedPrefs.setBool("Brightness", themeMode == ThemeMode.light ? true : false);
  }

  void setColor(int color){
    _sharedPrefs.setInt("Color", color);
  }

  bool getLock(){
    return _sharedPrefs.getBool("Lock") ?? false;
  }

  void setLock(bool value){
    _sharedPrefs.setBool("Lock", value);
  }

}