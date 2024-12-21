// ignore_for_file: use_key_in_widget_constructors, use_build_context_synchronously, prefer_const_constructors, avoid_print, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:ppu_feeds/custom_widgets/homecourse_card.dart';
import 'package:ppu_feeds/models/subscription.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Subscription>> futureSubs;

  @override
  void initState() {
    super.initState();
    futureSubs = fetchSubs();
  }

  Future<List<Subscription>> fetchSubs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("token");

    try {
      final response = await http.get(
        Uri.parse("http://feeds.ppu.edu/api/v1/subscriptions"),
        headers: {"Authorization": "$token"},
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        List<dynamic> subscriptionsJson = jsonResponse["subscriptions"];
        return subscriptionsJson.map((e) => Subscription.fromJson(e)).toList();
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFC4FFF9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A7075),
        title: const Text(
          "Home",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            futureSubs = fetchSubs();
          });
        },
        child: FutureBuilder<List<Subscription>>(
          future: futureSubs,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.subscriptions, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      "No subscriptions found",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final subscription = snapshot.data![index];
                // Pass the course ID from the subscription to HomeCourseCard
                return HomeCourseCard(id: subscription.sectionId);
              },
            );
          },
        ),
      ),
    );
  }
}
