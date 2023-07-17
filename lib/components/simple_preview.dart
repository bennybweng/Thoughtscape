import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thoughtscape/types/entry.dart';

class SimplePreview extends StatelessWidget {

  const SimplePreview({Key? key, required this.entry}) : super(key: key);

  final Entry entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 16,
      decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.outline),
          borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                child: RichText(text: TextSpan(style: TextStyle(color: Theme.of(context).colorScheme.primary),
                    children: [
                      TextSpan(text: entry.date.day.toString().padLeft(2, "0"), style: const TextStyle(fontSize: 25, decoration: TextDecoration.underline)),
                      TextSpan(text: " ${DateFormat.MMM(Localizations.localeOf(context).toString()).format(entry.date)}.", style: const TextStyle(fontSize: 20))
                    ])),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 8, 0),
                child: SizedBox(
                    height: 40,
                    width: 40,
                    child: entry.mood.toImage()),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 5, 0, 0),
            child: Text(entry.title, style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 17)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Text(entry.text, overflow: TextOverflow.ellipsis, style: TextStyle(color: Theme.of(context).colorScheme.primary.withOpacity(0.5))),
          )
        ],
      ),
    );
  }
}
