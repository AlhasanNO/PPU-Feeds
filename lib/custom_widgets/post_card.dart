import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ppu_feeds/models/post.dart';
import 'package:ppu_feeds/pages/postcomments_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PostCard extends StatefulWidget {
  final int courseId;
  final int sectionId;

  const PostCard({
    super.key,
    required this.courseId,
    required this.sectionId,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late Future<List<Post>> futurePosts;

  @override
  void initState() {
    super.initState();
    futurePosts = fetchPosts(widget.courseId, widget.sectionId);
  }

  Future<List<Post>> fetchPosts(int courseId, int sectionId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("token");
    
    try {
      final response = await http.get(
        Uri.parse(
            "http://feeds.ppu.edu/api/v1/courses/$courseId/sections/$sectionId/posts"),
        headers: {"Authorization": "$token"},
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final postsJson = jsonResponse["posts"] as List<dynamic>;
        return postsJson.map((e) => Post.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load posts: ${response.statusCode}");
      }
    } catch (e) {
      return Future.error("Error fetching posts: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Post>>(
      future: futurePosts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No posts available"));
        } else {
          final posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostCommentsScreen(
                        courseId: widget.courseId,
                        sectionId: widget.sectionId,
                        postId: post.id,
                      ),
                    ),
                  );
                },
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.author,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          post.datePosted,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          post.body,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
