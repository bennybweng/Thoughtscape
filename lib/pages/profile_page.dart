import 'dart:math';

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
    "happy1",
    "happy2",
    "sad2",
    "sad3",
    "sad4"
  ];

  double radius = 100;

  int touchedIndex = -1;

  int touchedIndexWeekdays = -1;

  final shadows = [const Shadow(color: Colors.black, blurRadius: 2)];

  int days = 7;

  int weekday = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          statistics(context),
          streaks(context),
          diagramOne(context),
          diagramWeekdays(context)
        ],
      ),
    );
  }

  Widget statistics(BuildContext context){
    TextStyle numStyle = const TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        width: MediaQuery.of(context).size.width,
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(SharedPrefs().getEntries().length.toString(), style: numStyle,),
                Text(SharedPrefs().getEntries().length == 1 ? "Eintrag" : "Einträge")
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(numWords().toString(), style: numStyle,),
                Text(numWords() == 1 ? "Wort" : "Wörter")
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(numChar().toString(), style: numStyle,),
                Text("Zeichen")
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget streaks(BuildContext context){
    TextStyle numStyle = const TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        width: MediaQuery.of(context).size.width,
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(currentStreak().toString(), style: numStyle,),
                Text("aktuelle Streak")
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(longestStreak().toString(), style: numStyle,),
                Text("längste Streak")
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget diagramOne(BuildContext context){
    List<String> allMoods = existingMoods(days);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 300,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 300,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: PieChart(PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  sections: [
                    for (String mood in allMoods)
                      PieChartSectionData(
                          badgePositionPercentageOffset: .98,
                          badgeWidget: AnimatedContainer(
                              width: touchedIndex ==
                                 allMoods.indexOf(mood)
                                  ? 50 + 20
                                  : 50,
                              height: touchedIndex ==
                                  allMoods.indexOf(mood)
                                  ? 50 + 20
                                  : 50,
                              duration: PieChart.defaultDuration,
                              child: Mood(mood).toImage()),
                          radius:
                          touchedIndex == allMoods.indexOf(mood)
                              ? radius + 10
                              : radius,
                          value: countMoods(days)[moods.indexOf(mood)].toDouble(),
                          titleStyle: TextStyle(
                            fontSize:
                            touchedIndex == allMoods.indexOf(mood)
                                ? 20 + 5
                                : 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xffffffff),
                            shadows: shadows,
                          ),
                          title:
                          "${((countMoods(days)[moods.indexOf(mood)] / sumMoods(days)) * 100).round()}%",
                          color: SharedPrefs().getStatisticsStyle() == "simple" ? Mood(mood).toColor() : Mood(mood).toColor2())
                  ],
                  sectionsSpace: 0,
                  centerSpaceRadius: 0)),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Material(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    elevation: 0.1,
                    child: PopupMenuButton(
                        position: PopupMenuPosition.under,
                        initialValue: days,
                        onSelected: (int value) {
                          setState(() {
                            days = value;
                          });
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              days > 0 ? "Letzte $days Tage" : "Alle",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer),
                            ),
                            Icon(Icons.arrow_drop_down)
                          ],
                        ),
                        itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<int>>[
                          const PopupMenuItem(
                            value: 7,
                            child: Text("Letzte 7 Tage"),
                          ),
                          const PopupMenuDivider(
                            height: 0,
                          ),
                          const PopupMenuItem(
                            value: 30,
                            child: Text("Letzte 30 Tage"),
                          ),
                          const PopupMenuDivider(
                            height: 0,
                          ),
                          const PopupMenuItem(
                            value: 90,
                            child: Text("Letzte 90 Tage"),
                          ),
                          const PopupMenuDivider(
                            height: 0,
                          ),
                          const PopupMenuItem(
                            value: -1,
                            child: Text("Alle"),
                          ),
                        ]),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget diagramWeekdays(BuildContext context){
    List<String> allMoods = existingMoodsWeekdays(weekday);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 300,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 300,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: PieChart(PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndexWeekdays = -1;
                          return;
                        }
                        touchedIndexWeekdays = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  sections: [
                    for (String mood in allMoods)
                      PieChartSectionData(
                          badgePositionPercentageOffset: .98,
                          badgeWidget: AnimatedContainer(
                              width: touchedIndexWeekdays ==
                                  allMoods.indexOf(mood)
                                  ? 50 + 20
                                  : 50,
                              height: touchedIndexWeekdays ==
                                  allMoods.indexOf(mood)
                                  ? 50 + 20
                                  : 50,
                              duration: PieChart.defaultDuration,
                              child: Mood(mood).toImage()),
                          radius:
                          touchedIndexWeekdays == allMoods.indexOf(mood)
                              ? radius + 10
                              : radius,
                          value: countMoodsWeekdays(weekday)[moods.indexOf(mood)].toDouble(),
                          titleStyle: TextStyle(
                            fontSize:
                            touchedIndexWeekdays == allMoods.indexOf(mood)
                                ? 20 + 5
                                : 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xffffffff),
                            shadows: shadows,
                          ),
                          title:
                          "${((countMoodsWeekdays(weekday)[moods.indexOf(mood)] / countMoodsWeekdays(weekday).fold(0, (previousValue, element) => previousValue + element)) * 100).round()}%",
                          color: SharedPrefs().getStatisticsStyle() == "simple" ? Mood(mood).toColor() : Mood(mood).toColor2())
                  ],
                  sectionsSpace: 0,
                  centerSpaceRadius: 0)),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Material(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    elevation: 0.1,
                    child: PopupMenuButton(
                        position: PopupMenuPosition.under,
                        initialValue: weekday,
                        onSelected: (int value) {
                          setState(() {
                            weekday = value;
                          });
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              getWeekdayString(weekday),
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer),
                            ),
                            Icon(Icons.arrow_drop_down)
                          ],
                        ),
                        itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<int>>[
                          const PopupMenuItem(
                            value: 1,
                            child: Text("Monday"),
                          ),
                          const PopupMenuDivider(
                            height: 0,
                          ),
                          const PopupMenuItem(
                            value: 2,
                            child: Text("Tuesday"),
                          ),
                          const PopupMenuDivider(
                            height: 0,
                          ),
                          const PopupMenuItem(
                            value: 3,
                            child: Text("Wednesday"),
                          ),
                          const PopupMenuDivider(
                            height: 0,
                          ),
                          const PopupMenuItem(
                            value: 4,
                            child: Text("Thursday"),
                          ),
                          const PopupMenuDivider(
                            height: 0,
                          ),
                          const PopupMenuItem(
                            value: 5,
                            child: Text("Friday"),
                          ),
                          const PopupMenuDivider(
                            height: 0,
                          ),
                          const PopupMenuItem(
                            value: 6,
                            child: Text("Saturday"),
                          ),
                          const PopupMenuDivider(
                            height: 0,
                          ),
                          const PopupMenuItem(
                            value: 7,
                            child: Text("Sunday"),
                          ),
                        ]),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<int> countMoods(int days) {
    List<int> count = List.generate(moods.length, (index) => 0);
    List<Entry> entries = [];
    if (days > 0) {
      for (Entry entry in SharedPrefs().getEntries()) {
        if (isBetween(DateTime.now().subtract(Duration(days: days)), DateTime.now(), entry.date)) {
          entries.add(entry);
        }
      }
    }else {
      entries = SharedPrefs().getEntries();
    }
    /*for (Entry entry in entries) {
      for (String mood in moods) {
        if (mood == entry.mood.info) {
          count[moods.indexOf(mood)] += 1;
          continue;
        }
      }
    }*/
    for (Entry entry in entries) {
          count[moods.indexOf(entry.mood.info)] += 1;
    }
    return count;
  }

  List<int> countMoodsWeekdays(int weekday) {
    List<int> count = List.generate(moods.length, (index) => 0);
    for (Entry entry in SharedPrefs().getEntries()) {
      if (entry.date.weekday == weekday) {
        count[moods.indexOf(entry.mood.info)] += 1;
      }
    }
    return count;
  }

  bool isBetween(DateTime fromDateTime, DateTime toDateTime, DateTime toCheck) {
    return (toCheck.isAfter(fromDateTime) ||
        toCheck.isAtSameMomentAs(fromDateTime)) &&
        (toCheck.isBefore(toDateTime) ||
        toCheck.isAtSameMomentAs(toDateTime));
  }

  int sumMoods(int days) {
    return countMoods(days)
        .fold(0, (previousValue, element) => previousValue + element);
  }

  List<String> existingMoods(int days) {
    List<String> existingMoods = [];
    for (String mood in moods) {
      if (countMoods(days)[moods.indexOf(mood)] != 0) {
        existingMoods.add(mood);
      }
    }
    return existingMoods;
  }

  List<String> existingMoodsWeekdays(int weekday){
    List<String> existingMoods = [];
    for (Entry entry in SharedPrefs().getEntries()){
      if (entry.date.weekday == weekday) {
        existingMoods.add(entry.mood.info);
      }  
    }
    return existingMoods.toSet().toList();
  }

  String getWeekdayString(int weekday) {
    List<String> weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    if (weekday >= 1 && weekday <= 7) {
      return weekdays[weekday - 1];
    } else {
      return 'Invalid';
    }
  }

  int numChar(){
    int chars = 0;
    for(Entry entry in SharedPrefs().getEntries()){
      chars += entry.text.length;
    }
    return chars;
  }

  int numWords(){
    int words = 0;
    for(Entry entry in SharedPrefs().getEntries()){
      words += entry.text.split(" ").where((element) => element.isNotEmpty && element != " ").toList().length;
    }
    return words;
  }

  int currentStreak(){
    List<Entry> entries = SharedPrefs().getEntries();
    removeDuplicateDays(entries);
    List<Entry> toRemove = [];
    for(Entry entry in entries){
      if(entry.date.isAfter(DateTime.now())){
        toRemove.add(entry);
      }
    }
    entries.removeWhere((element) => toRemove.contains(element));
    entries.sort((a, b) => b.date.compareTo(a.date));
    int count = 0;
    if (entries.isEmpty) {
      return 0;
    }
    for(var i = 0; i < entries.length; i++){
      if(!DateUtils.isSameDay(entries[i].date, DateTime.now().subtract(Duration(days: i)))){
        break;
      }
      count++;
    }
    return count;
  }

  int longestStreak(){
    List<Entry> entries = SharedPrefs().getEntries();
    removeDuplicateDays(entries);
    entries.sort((a, b) => a.date.compareTo(b.date));
    if (entries.isEmpty) {
      return 0;
    }
    int current = 1;
    int longest = 1;
    for(var i = 1; i < entries.length; i++){
      if(DateUtils.isSameDay(entries[i].date, entries[i - 1].date.add(const Duration(days: 1)))){
        current++;
        longest = max(current, longest);
      }else{
        current = 1;
      }
    }
    return longest;
  }

  void removeDuplicateDays(List<Entry> entries){
    List<DateTime> dates = [];
    List<Entry> toRemove = [];
    for (Entry entry in entries){
      if (dates.contains(DateUtils.dateOnly(entry.date))) {
        toRemove.add(entry);
      } else{
        dates.add(DateUtils.dateOnly(entry.date));
      }
    }
    entries.removeWhere((element) => toRemove.contains(element));
  }
}
