// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ppu_feeds/models/course.dart';
import 'package:http/http.dart' as http;
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
  bool isSubscribed = false;

  @override
  void initState() {
    super.initState();
    futureCourse = fetchCourse(1);
  }

  Future<Course> fetchCourse(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("token");
    print(token);
    try {
      final response = await http.get(
        Uri.parse("http://feeds.ppu.edu/api/v1/courses/$id"),
        headers: {"Authorization": "$token"},
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        return Course.fromJson(jsonResponse);
      } else {
        throw Exception("Failed to load course");
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("Failed to fetch course");
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
          return Center(child: Text("No course data found"));
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    course.name,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 8.0),
                                  Text(
                                    "",
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                course.collegeName,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2.0),
                              Text(
                                "",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                isSubscribed = !isSubscribed;
                              });
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black,
                            ),
                            icon: Icon(
                              isSubscribed ? Icons.check : Icons.add,
                              color: isSubscribed ? Colors.green : Colors.black,
                            ),
                            label:
                                Text(isSubscribed ? "Subscribed" : "Subscribe"),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.0),
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
