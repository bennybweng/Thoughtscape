import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:thoughtscape/shared/shared_prefs.dart';
import 'package:thoughtscape/types/entry.dart';

class CalenderPage extends StatefulWidget {
  const CalenderPage({Key? key}) : super(key: key);

  @override
  State<CalenderPage> createState() => _CalenderPageState();
}

class _CalenderPageState extends State<CalenderPage> {
  late final ValueNotifier<List<Entry>> _selectedEntries;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late final List<Entry> entries;

  @override
  void initState() {
    entries = SharedPrefs().getEntries();
    _selectedDay = DateTime.now();
    _selectedEntries = ValueNotifier(_getEntries(_selectedDay!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2000),
            lastDay: DateTime(2030),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            eventLoader: _getEntries,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiaryContainer,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  shape: BoxShape.circle),
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
            ),
            availableCalendarFormats: const {CalendarFormat.month: "Monat"},
            daysOfWeekHeight: 16 * MediaQuery.of(context).textScaleFactor,
            onDaySelected: (selectedDay, focusedDay) {
              print(_selectedEntries.value.length);
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Entry>>(
              valueListenable: _selectedEntries,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        onTap: () => print('a'),
                        title: Text(value[index].text),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

    );
  }

  bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) {
      return false;
    }

    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  List<Entry> _getEntries(DateTime day) {
    List<Entry> dayEntries = [];
    for (Entry entry in entries) {
      if (isSameDay(entry.date, day)) {
        dayEntries.add(entry);
      }
    }
    return dayEntries;
  }
}
