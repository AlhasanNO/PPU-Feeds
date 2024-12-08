// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ppu_feeds/models/course.dart';
import 'package:http/http.dart' as http;
import 'package:ppu_feeds/models/section.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseCard extends StatefulWidget {
  final int id;

  const CourseCard({
    super.key,
    required this.id,
  });

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  late Future<Course> futureCourse;
  late Future<List<Section>> futureSections;
  bool isSubscribed = false;

  @override
  void initState() {
    super.initState();
    futureCourse = fetchCourse(widget.id);
    futureSections = fetchSections(widget.id);
  }

  Future<List<Section>> fetchSections(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("token");

    try {
      final response = await http.get(
        Uri.parse("http://feeds.ppu.edu/api/v1/courses/$id/sections"),
        headers: {"Authorization": "$token"},
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        List<dynamic> sectionsJson = jsonResponse["sections"];
        return sectionsJson.map((e) => Section.fromJson(e)).toList();
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<Course> fetchCourse(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("token");

    try {
      final response = await http.get(
        Uri.parse("http://feeds.ppu.edu/api/v1/courses/$id"),
        headers: {
          "Authorization":
              "$token"
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        final courseJson = jsonResponse['course'];
        return Course.fromJson(courseJson);
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Course>(
      future: futureCourse,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData) {
          return Center(child: Text("No courses found"));
        } else {
          final course = snapshot.data!;
          return Column(
            children: [
              Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  course.name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  course.collegeName,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                FutureBuilder<List<Section>>(
                                  future: futureSections,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return Center(
                                          child: Text("${snapshot.error}"));
                                    } else if (!snapshot.hasData ||
                                        snapshot.data!.isEmpty) {
                                      return Text("No sections found");
                                    } else {
                                      final List<Section> sections =
                                          snapshot.data!;
                                      return SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: sections.map((section) {
                                            return ListTile(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 3.0),
                                              title: Text(
                                                "Section: ${section.name}",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              subtitle: Text(
                                                "Lecturer: ${section.lecturer}",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                isSubscribed = !isSubscribed;
                              });
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black,
                            ),
                            label:
                                Text(isSubscribed ? "Subscribed" : "Subscribe"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
