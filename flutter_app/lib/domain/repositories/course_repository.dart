import '../../data/course.dart';

abstract interface class CourseRepository {
  Future<List<Course>> loadCourses();
}
