import 'package:flutter/material.dart';
import 'package:thoughtscape/pages/homepage.dart';
import 'package:thoughtscape/pages/lock_screen.dart';
import 'package:thoughtscape/shared/shared_prefs.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs().init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
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

class _MyAppState extends State<MyApp> {

  ThemeMode _themeMode = SharedPrefs().getBrightness();
  ThemeData lightTheme = ThemeData(colorSchemeSeed: colorOptions[SharedPrefs().getColor()], brightness: Brightness.light, useMaterial3: true);
  ThemeData darkTheme = ThemeData(colorSchemeSeed: colorOptions[SharedPrefs().getColor()], brightness: Brightness.dark, useMaterial3: true);



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //locale: Locale('de', 'DE'),
      supportedLocales: [
        Locale('en', 'US'),
      //Locale('de', 'DE'),
    ],
      title: 'Thoughtscape',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
      home: SharedPrefs().getLock() ? const LockScreen() : const HomePage(),
    );
  }

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
      SharedPrefs().setBrightness(themeMode);
    });
  }

  void changeColor(index) {
    setState(() {
      lightTheme = ThemeData(colorSchemeSeed: colorOptions[index], brightness: Brightness.light, useMaterial3: true);
      darkTheme = ThemeData(colorSchemeSeed: colorOptions[index], brightness: Brightness.dark, useMaterial3: true);
      SharedPrefs().setColor(index);
    });
  }
}
