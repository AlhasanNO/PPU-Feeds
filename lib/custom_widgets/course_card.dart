// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class CourseCard extends StatefulWidget {
  const CourseCard({super.key});

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  bool isSubscribed = false;

  @override
  Widget build(BuildContext context) {
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
                              'Course Name',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              'Section: ',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'College Name',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Lecturer Name',
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
                      label: Text(isSubscribed ? "Subscribed" : "Subscribe"),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
