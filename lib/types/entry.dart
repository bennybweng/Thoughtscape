import 'package:flutter/material.dart';

import '../shared/shared_prefs.dart';
class Entry {
  DateTime date;
  String title;
  String text;
  Mood mood;

  Entry({required this.date, required this.title, required this.text, required this.mood});

  Map<String, dynamic> toJson() {

    return {
      "title": title,
      "creationDate": date.toIso8601String(),
      "text" : text,
      "mood": mood.info
    };
  }

  /*bool equalEntry(Entry entry){
    return date == entry.date && title == entry.title;
  }*/

  @override
  bool operator ==(Object other){
    if (other is Entry) {
      return date == other.date && title == other.title;
    }
    return false;
  }

  factory Entry.fromJson(Map<String, dynamic> json) {
    return Entry(
      date: DateTime.parse(json['creationDate'] ?? DateTime(2023).toIso8601String()),
      title: json['title'] ?? "",
      text: json['text'] ?? "",
      mood: Mood(json['mood'] ?? "neutral")
    );
  }

  @override
  int get hashCode => Object.hash(date, title);

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

class Mood{

  String info;

  Mood(this.info);

  Image toImage(){
    switch(info) {
      case "neutral":
        return Image.asset("assets/neutral.png");
      case "angry":
        return Image.asset("assets/angry.png");
      case "love":
        return Image.asset("assets/love.png");
      case "happy1":
        return Image.asset("assets/happy1.png");
      case "happy2":
        return Image.asset("assets/happy2.png");
      case "sad2":
        return Image.asset("assets/sad2.png");
      case "sad3":
        return Image.asset("assets/sad3.png");
      case "sad4":
        return Image.asset("assets/sad4.png");
      default:
        return Image.asset("assets/neutral.png");
    }


  }

  Color toColor(){
    Color base = colorOptions[SharedPrefs().getColor()];
    switch(info) {
      case "neutral":
        return base;
      case "angry":
        return base.withOpacity(0.9);
      case "love":
        return base.withOpacity(0.8);
      case "happy1":
        return base.withOpacity(0.7);
      case "happy2":
        return base.withOpacity(0.6);
      case "sad2":
        return base.withOpacity(0.5);
      case "sad3":
        return base.withOpacity(0.4);
      case "sad4":
        return base.withOpacity(0.3);
      default:
        return base;
    }
  }


  Color toColor2(){
    switch(info) {
      case "neutral":
        return Color(0xff6750a4);
      case "angry":
        return Colors.deepOrange;
      case "love":
        return Colors.pink;
      case "happy1":
        return Colors.green;
      case "happy2":
        return Colors.orange;
      case "sad2":
        return Colors.teal;
      case "sad3":
        return Colors.blue;
      case "sad4":
        return Colors.indigo;
      default:
        return Color(0xFFFC952D);
    }
  }

  Color toColor3(){
    switch(info) {
      case "neutral":
        return Color(0xff6750a4);
      case "angry":
        return Color(0xe56750a4);
      case "love":
        return Color(0xcc6750a4);
      case "happy1":
        return Color(0xb36750a4);
      case "happy2":
        return Color(0x996750a4);
      case "sad2":
        return Color(0x806750a4);
      case "sad3":
        return Color(0x666750a4);
      case "sad4":
        return Color(0x4d6750a4);
      default:
        return Color(0xff6750a4);
    }
  }





}
