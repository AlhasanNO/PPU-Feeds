// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:ppu_feeds/models/course.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FeedsScreen extends StatefulWidget {
  const FeedsScreen({super.key});

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  List<Course> courses = [];
  late Future<List<Course>> futurecourse;

  @override
  void initState() {
    super.initState();
    futurecourse = fetchedcourse();
  }

  Future<List<Course>> fetchedcourse() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("token");

    try {
      var response = await http.get(
        Uri.parse("http://feeds.ppu.edu/api/v1/courses"),
        headers: {"Authorization": "$token"},
      );

      if (response.statusCode == 200) {
        print(response.body);
        var jsonResponse = jsonDecode(response.body);
        var jsonList = jsonResponse as List;
        return jsonList.map((e) => Course.fromJson(e)).toList();
      } else {
        print("Error");
      }
    } catch (e) {
      print("Error $e");
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0A7075),
        title: Text(
          "Feeds",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}
