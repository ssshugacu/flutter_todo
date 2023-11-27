import 'package:flutter/material.dart';
import 'package:flutter_todo/pages/home.dart';
import 'package:flutter_todo/pages/main_screen.dart';
import 'package:flutter_todo/pages/calendar.dart';

void main() => runApp(MaterialApp(

  theme: ThemeData(
    primaryColor: Colors.white,
  ),
  initialRoute: '/',
  routes: {
    '/': (context) => MainScreen(),
    '/todo': (context) => Home(),
    '/calendar': (context) => CalendarApp(),
   },
  ),
);