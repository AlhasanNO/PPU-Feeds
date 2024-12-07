import 'package:ppu_feeds/models/course.dart';
import 'package:ppu_feeds/models/section.dart';

class Subscription {
  int id;
  Course course;
  Section section;
  String lecturer;
  String subscriptionDate;

  Subscription({
    required this.id,
    required this.section,
    required this.course,
    required this.lecturer,
    required this.subscriptionDate,
  });

  factory Subscription.fromJson(dynamic jsonObject) {
    return Subscription(
      id: int.parse(jsonObject["id"]),
      section: jsonObject["section"],
      course: jsonObject["course"],
      lecturer: jsonObject["lecturer"],
      subscriptionDate: jsonObject["subscription_date"],
    );
  }
}
