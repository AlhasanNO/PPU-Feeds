class Course {
  final int id;
  final String name;
  final String collegeName;

  Course({
    required this.id,
    required this.name,
    required this.collegeName,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      name: json['name'],
      collegeName: json['college'],
    );
  }
}
