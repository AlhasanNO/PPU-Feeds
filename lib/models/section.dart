class Section {
  final int id;
  final String name;
  final String course;  // Changed from Course to String
  final String lecturer;

  Section({
    required this.id,
    required this.name,
    required this.course,
    required this.lecturer,
  });

  factory Section.fromJson(dynamic jsonObject) {
    return Section(
      id: jsonObject["id"],
      name: jsonObject["name"],
      course: jsonObject["course"],  // Now directly using the string
      lecturer: jsonObject["lecturer"],
    );
  }
}