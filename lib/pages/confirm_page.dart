import 'package:flutter/material.dart';
import 'package:thoughtscape/components/simple_preview.dart';

import '../types/entry.dart';

class ConfirmPage extends StatelessWidget {
  final List<Entry> entries;

  const ConfirmPage({Key? key, required this.entries}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Preview"),
      ),
      body: ListView(
        children: [
          for (Entry entry in entries)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SimplePreview(entry: entry),
            ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
            child: SizedBox(
                width: 80,
                height: 80,
                child: FittedBox(
                    child: FloatingActionButton(
                        heroTag: "fab1",
                        backgroundColor: Theme.of(context).colorScheme.errorContainer,
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: const Icon(Icons.close)))),
          ),
          SizedBox(
              width: 80,
              height: 80,
              child: FittedBox(
                  child: FloatingActionButton(
                    heroTag: "fab2",
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: const Icon(Icons.done)))),
        ],
      ),
    );
  }
}
