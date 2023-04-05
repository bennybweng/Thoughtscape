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
      date: DateTime.parse(json['creationDate']),
      title: json['title'],
      text: json['text'],
      mood: Mood("neutral")
    );
  }
}

class Mood{

  String info;

  Mood(this.info);

}
