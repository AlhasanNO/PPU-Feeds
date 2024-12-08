class Course {
  int id;
  String name;
  String collegeName;
  int collegeId;

  Course({
    required this.id,
    required this.name,
    required this.collegeName,
    required this.collegeId,
  });

  factory Course.fromJson(dynamic jsonObject) {
    return Course(
      id: jsonObject["id"],
      name: jsonObject["name"],
      collegeName: jsonObject["college"],
      collegeId: jsonObject["college_id"],
    );
  }
}
