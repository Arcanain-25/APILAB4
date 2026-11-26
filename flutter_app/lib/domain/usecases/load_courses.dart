import '../../data/course.dart';
import '../repositories/course_repository.dart';

class LoadCourses {
  const LoadCourses(this.repository);

  final CourseRepository repository;

  Future<List<Course>> call() => repository.loadCourses();
}
