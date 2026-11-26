class Course {
  const Course({
    required this.id,
    required this.title,
    required this.instructor,
    required this.category,
    required this.level,
    required this.durationMinutes,
    required this.completedLessons,
    required this.totalLessons,
    required this.rating,
    required this.coverUrl,
    required this.description,
    required this.lessons,
  });

  final String id;
  final String title;
  final String instructor;
  final String category;
  final String level;
  final int durationMinutes;
  final int completedLessons;
  final int totalLessons;
  final double rating;
  final String coverUrl;
  final String description;
  final List<CourseLesson> lessons;

  double get progress =>
      totalLessons == 0 ? 0 : completedLessons / totalLessons;

  String get durationLabel {
    final hours = durationMinutes ~/ 60;
    final minutes = durationMinutes % 60;
    if (hours == 0) return '${minutes}m';
    if (minutes == 0) return '${hours}h';
    return '${hours}h ${minutes}m';
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as String,
      title: json['title'] as String,
      instructor: json['instructor'] as String,
      category: json['category'] as String,
      level: json['level'] as String,
      durationMinutes: json['durationMinutes'] as int,
      completedLessons: json['completedLessons'] as int,
      totalLessons: json['totalLessons'] as int,
      rating: (json['rating'] as num).toDouble(),
      coverUrl: json['coverUrl'] as String,
      description: json['description'] as String,
      lessons: (json['lessons'] as List<dynamic>)
          .map(
              (lesson) => CourseLesson.fromJson(lesson as Map<String, dynamic>))
          .toList(growable: false),
    );
  }
}

class CourseLesson {
  const CourseLesson({
    required this.title,
    required this.duration,
    required this.completed,
  });

  final String title;
  final String duration;
  final bool completed;

  factory CourseLesson.fromJson(Map<String, dynamic> json) => CourseLesson(
        title: json['title'] as String,
        duration: json['duration'] as String,
        completed: json['completed'] as bool,
      );
}
