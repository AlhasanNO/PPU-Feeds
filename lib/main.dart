// ignore_for_file: use_key_in_widget_constructors, use_build_context_synchronously, prefer_const_constructors, avoid_print, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:ppu_feeds/pages/feeds_screen.dart';
import 'package:ppu_feeds/pages/home_screen.dart';
import 'package:ppu_feeds/pages/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
      routes: {
        "/Login": (context) => LoginScreen(),
        "/Home": (context) => HomeScreen(),
        "/Feeds": (context) => FeedsScreen(),
      },
    );
  }
}
