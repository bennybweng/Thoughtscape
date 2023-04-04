import 'package:flutter/material.dart';
import 'package:thoughtscape/pages/calender_page.dart';
import 'package:thoughtscape/pages/create_entry_page.dart';
import 'package:thoughtscape/pages/mainpage.dart';
import 'package:thoughtscape/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Homepage'),
      ),
      body: const Center(
        child: MainPage()
      ),
      floatingActionButton: SizedBox(
        width: 80,
          height: 80,
          child: FittedBox(child: FloatingActionButton(onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateEntryPage()),
            );
          }, child: const Icon(Icons.add)))),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CalenderPage()),
                );
              }, icon: Icon(Icons.calendar_month_outlined), iconSize: 40,),
              IconButton(onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              }, icon: Icon(Icons.person), iconSize: 40,),
            ],
          ),
        ),
      )
    );
  }
}
