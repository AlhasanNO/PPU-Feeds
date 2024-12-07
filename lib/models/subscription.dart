class Subscription {
  int id;
  String section;
  String lecturer;
  String subscriptionDate;

  Subscription({
    required this.id,
    required this.lecturer,
    required this.section,
    required this.subscriptionDate,
  });

  factory Subscription.fromJson(dynamic jsonObject) {
    return Subscription(
      id: int.parse(jsonObject[""]),
      section: jsonObject["Section Name"],
      lecturer: jsonObject["Lecturer Name"],
      subscriptionDate: jsonObject["YYYY-MM-DD"],
    );
  }
}
