// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class PostCard extends StatefulWidget {
  const PostCard({super.key});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLiked = false;
  bool isCommented = false;
  bool isShared = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            'Course Name',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          'Lecturer Name',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          "Content",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  isLiked = !isLiked;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black),
                              icon: Icon(
                                isLiked
                                    ? Icons.thumb_up_alt_sharp
                                    : Icons.thumb_up_alt_outlined,
                              ),
                              label: Text("Like"),
                            ),
                            TextButton.icon(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black),
                              icon: Icon(
                                Icons.comment_outlined,
                              ),
                              label: Text("Comment"),
                            ),
                            TextButton.icon(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black),
                              icon: Icon(Icons.share),
                              label: Text("Share"),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
