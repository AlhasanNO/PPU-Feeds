class Course {
  final int id;
  final String name;
  final String collegeName;
  final int collegeId;

  Course({
    required this.id,
    required this.name,
    required this.collegeName,
    required this.collegeId,
  });

  factory Course.fromJson(dynamic jsonObject) {
    return Course(
      id: int.parse(jsonObject["id"]),
      name: jsonObject["name"],
      collegeName: jsonObject["college"],
      collegeId: int.parse(jsonObject["college_id"]),
    );
  }
}
