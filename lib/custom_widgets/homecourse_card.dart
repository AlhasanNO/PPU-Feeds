// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ppu_feeds/models/course.dart';
import 'package:http/http.dart' as http;
import 'package:ppu_feeds/models/subscription.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeCourseCard extends StatefulWidget {
  final int id;

  const HomeCourseCard({
    super.key,
    required this.id,
  });

  @override
  State<HomeCourseCard> createState() => _HomeCourseCardState();
}

class _HomeCourseCardState extends State<HomeCourseCard> {
  late Future<Course?> futureCourse;
  late Future<List<Subscription>> futureSubs;

  @override
  void initState() {
    super.initState();
    futureCourse = fetchCourse(widget.id);
    futureSubs = fetchSubs();
  }

  Future<Course?> fetchCourse(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString("token");

      if (token == null) {
        throw Exception("Authentication token not found");
      }

      final response = await http.get(
        Uri.parse("http://feeds.ppu.edu/api/v1/courses/$id"),
        headers: {"Authorization": token},
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        final courseJson = jsonResponse["course"];
        return Course.fromJson(courseJson);
      } else {
        throw Exception("Failed to load course: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching course: $e");
      return null;
    }
  }

  Future<List<Subscription>> fetchSubs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString("token");

      if (token == null) {
        throw Exception("Authentication token not found");
      }

      final response = await http.get(
        Uri.parse("http://feeds.ppu.edu/api/v1/subscriptions"),
        headers: {"Authorization": token},
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        List<dynamic> subscriptionsJson = jsonResponse["subscriptions"];
        return subscriptionsJson.map((e) => Subscription.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load subscriptions: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching subscriptions: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<Subscription>>(
          future: futureSubs,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Unable to load subscriptions",
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No subscriptions found"));
            }

            final List<Subscription> subs = snapshot.data!;
            Subscription? subscription;

            try {
              subscription = subs.firstWhere(
                (sub) => sub.sectionId == widget.id,
              );
            } catch (e) {
              return const Center(
                child: Text(
                  "Subscription not found",
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subscription.course,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                FutureBuilder<Course?>(
                  future: futureCourse,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError || !snapshot.hasData) {
                      return const Text(
                        "College information unavailable",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }

                    final Course course = snapshot.data!;
                    return Text(
                      course.collegeName,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
                Text(
                  "Section: ${subscription.section}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Lecturer: ${subscription.lecturer}",
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
