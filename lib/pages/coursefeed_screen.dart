import 'package:flutter/material.dart';
import 'package:ppu_feeds/custom_widgets/post_card.dart';  

class CourseFeedsScreen extends StatefulWidget {
  final int courseId;
  final int sectionId;

  const CourseFeedsScreen({
    super.key,
    required this.courseId,
    required this.sectionId,
  });

  @override
  State<CourseFeedsScreen> createState() => _CourseFeedsScreenState();
}

class _CourseFeedsScreenState extends State<CourseFeedsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Course Feeds'),
      ),
      body: PostCard(
        courseId: widget.courseId,   
        sectionId: widget.sectionId,
        ),
     );
}
}