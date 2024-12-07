// ignore_for_file: use_key_in_widget_constructors, use_build_context_synchronously, prefer_const_constructors, avoid_print, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:ppu_feeds/models/subscription.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Subscription> subscription = [];
  late Future<List<Subscription>> futureSubs;

  @override
  void initState() {
    super.initState();
    futureSubs = fetchedSubs();
  }

  Future<List<Subscription>> fetchedSubs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("token");

    try {
      var response = await http.get(
        Uri.parse("http://feeds.ppu.edu/api/v1/subscriptions"),
        headers: {"Authorization": "$token"},
      );

      if (response.statusCode == 200) {
        print(response.body);
        var jsonResponse = jsonDecode(response.body);
        var jsonList = jsonResponse as List;
        return jsonList.map((e) => Subscription.fromJson(e)).toList();
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
          "Home",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          FutureBuilder<List<Subscription>>(
            future: futureSubs,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                subscription = snapshot.data!;
              }
              if (subscription.isEmpty) {
                return Center(
                    child: Text(
                  "Subscripe to show show feeds",
                  style: TextStyle(fontSize: 20),
                ));
              } else {
                return Expanded(child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Card();
                  },
                ));
              }
            },
          )
        ],
      ),
    );
  }
}
