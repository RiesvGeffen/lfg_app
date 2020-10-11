import 'package:flutter/material.dart';
import 'package:lfg_app/screens/home_screen.dart';

class LfgApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LfgAppState();
  }
}

class LfgAppState extends State<LfgApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primaryColor: Color.fromARGB(255, 40, 44, 52),
          accentColor: Color.fromARGB(255, 117, 190, 255),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: {
          '/': (context) => HomeScreen(),
        });
  }
}
