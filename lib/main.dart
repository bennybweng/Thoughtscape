import 'package:flutter/material.dart';
import 'package:thoughtscape/pages/lock_screen.dart';
import 'package:thoughtscape/shared/shared_prefs.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thoughtscape',
      theme: ThemeData.light(useMaterial3: true),
      home: const LockScreen(),
    );
  }
}
