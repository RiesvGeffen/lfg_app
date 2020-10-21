import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lfg_app/app.dart';

final GlobalKey<NavigatorState> homeTabNavKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> createPostTabNavKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> profileTabNavKey = GlobalKey<NavigatorState>();

void main() {
  runApp(new CupertinoApp(
    home: new LfgApp(),
    localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
      DefaultMaterialLocalizations.delegate,
      DefaultWidgetsLocalizations.delegate,
    ],
  ));
}
