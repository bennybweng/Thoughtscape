import 'package:flutter/material.dart';
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

  factory Entry.fromJson(Map<String, dynamic> json) {
    return Entry(
      date: DateTime.parse(json['creationDate'] ?? DateTime(2023).toIso8601String()),
      title: json['title'] ?? "",
      text: json['text'] ?? "",
      mood: Mood(json['mood'] ?? "neutral")
    );
  }
}

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
      case "wink":
        return Image.asset("assets/wink.png");
      case "happy1":
        return Image.asset("assets/happy1.png");
      case "happy2":
        return Image.asset("assets/happy2.png");
      case "sad1":
        return Image.asset("assets/sad1.png");
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

}
