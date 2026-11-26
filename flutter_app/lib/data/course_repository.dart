import 'dart:convert';

import 'package:http/http.dart' as http;

import '../domain/repositories/course_repository.dart';
import 'course.dart';

class HttpCourseRepository implements CourseRepository {
  HttpCourseRepository({http.Client? client})
      : _client = client ?? http.Client();

  static const _detailsUrl =
      'https://test-api-jlbn.onrender.com/lab2026/v4/feed/details';

  final http.Client _client;

  @override
  Future<List<Course>> loadCourses() async {
    final response = await _client.get(Uri.parse(_detailsUrl));
    if (response.statusCode != 200) {
      throw Exception('HTTP ${response.statusCode} while loading courses');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final courseJson = decoded['course'] as Map<String, dynamic>;
    final heroJson = courseJson['hero'] as Map<String, dynamic>;
    final lessonsJson = courseJson['lessons'] as List<dynamic>;

    final course = Course(
      id: courseJson['id'] as String,
      title: courseJson['title'] as String,
      instructor: 'EduLearn instructor',
      category: heroJson['label'] as String,
      level: 'All levels',
      durationMinutes: courseJson['durationMinutes'] as int,
      completedLessons:
          lessonsJson.where((lesson) => lesson['completed'] == true).length,
      totalLessons: courseJson['lessonCount'] as int,
      rating: (courseJson['rating'] as num).toDouble(),
      coverUrl: heroJson['imageUrl'] as String,
      description:
          ((decoded['course'] as Map<String, dynamic>)['description']
                  as Map<String, dynamic>)['text'] as String? ??
              'Explore lessons and learning materials for this course.',
      lessons: lessonsJson
          .map((lesson) => CourseLesson(
                title: lesson['title'] as String,
                duration: lesson['duration'] as String,
                completed: lesson['completed'] as bool,
              ))
          .toList(growable: false),
    );

    return [course];
  }
}
