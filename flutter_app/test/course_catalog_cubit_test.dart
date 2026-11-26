import 'package:flutter_test/flutter_test.dart';

import 'package:edulearn_flutter/data/course.dart';
import 'package:edulearn_flutter/domain/repositories/course_repository.dart';
import 'package:edulearn_flutter/features/catalog/course_catalog_cubit.dart';

void main() {
  const courses = [
    Course(
      id: 'react',
      title: 'React Basics',
      instructor: 'Alex Kim',
      category: 'Development',
      level: 'Beginner',
      durationMinutes: 90,
      completedLessons: 1,
      totalLessons: 3,
      rating: 4.8,
      coverUrl: '',
      description: 'Learn React.',
      lessons: [],
    ),
    Course(
      id: 'design',
      title: 'Product Design',
      instructor: 'Sam Lee',
      category: 'Design',
      level: 'Beginner',
      durationMinutes: 120,
      completedLessons: 0,
      totalLessons: 4,
      rating: 4.6,
      coverUrl: '',
      description: 'Learn product design.',
      lessons: [],
    ),
  ];

  test('loads courses and applies search, category, and favorites filters',
      () async {
    final cubit = CourseCatalogCubit(_FakeCourseRepository(courses));
    await cubit.loadCourses();
    expect(cubit.state, isA<CatalogSuccess>());
    expect((cubit.state as CatalogSuccess).visibleCourses, hasLength(2));

    cubit.search('react');
    expect((cubit.state as CatalogSuccess).visibleCourses.single.id, 'react');

    cubit.search('');
    cubit.selectCategory('Design');
    expect((cubit.state as CatalogSuccess).visibleCourses.single.id, 'design');

    cubit.selectCategory('All');
    cubit.toggleFavorite('react');
    cubit.toggleFavoritesOnly();
    expect((cubit.state as CatalogSuccess).visibleCourses.single.id, 'react');
    await cubit.close();
  });

  test('emits an empty state when no course matches', () async {
    final cubit = CourseCatalogCubit(_FakeCourseRepository(courses));
    await cubit.loadCourses();
    cubit.search('no matching course');
    expect(cubit.state, isA<CatalogEmpty>());
    await cubit.close();
  });

  test('emits an error state when loading fails', () async {
    final cubit = CourseCatalogCubit(_FakeCourseRepository.failure());
    await cubit.loadCourses();
    expect(cubit.state, isA<CatalogError>());
    await cubit.close();
  });
}

class _FakeCourseRepository implements CourseRepository {
  _FakeCourseRepository(this._courses) : _error = null;

  _FakeCourseRepository.failure()
      : _courses = const [],
        _error = Exception('asset unavailable');

  final List<Course> _courses;
  final Object? _error;

  @override
  Future<List<Course>> loadCourses() async {
    if (_error case final error?) throw error;
    return _courses;
  }
}
