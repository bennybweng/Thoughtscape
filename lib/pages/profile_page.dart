import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:thoughtscape/shared/shared_prefs.dart';
import 'package:thoughtscape/types/entry.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  List<String> moods = [
    "neutral",
    "angry",
    "love",
    "wink",
    "happy1",
    "happy2",
    "sad1",
    "sad2",
    "sad3",
    "sad4"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: PieChart(PieChartData(sections: [
        for(String mood in moods)
          if (countMoods()[moods.indexOf(mood)] != 0)
            PieChartSectionData(value: countMoods()[moods.indexOf(mood)].toDouble(), title: mood)

      ]))),
    );
  }

  List<int> countMoods() {

    List<int> count = List.generate(moods.length, (index) => 0);
    List<Entry> entries = SharedPrefs().getEntries();
    for (Entry entry in entries) {
      for (String mood in moods) {
        if (mood == entry.mood.info) {
          count[moods.indexOf(mood)] += 1;
          continue;
        }
      }
    }
    return count;
  }
}
