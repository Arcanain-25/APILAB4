import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/course.dart';
import '../../domain/repositories/course_repository.dart';

enum CourseSort { recommended, title, rating }

abstract class CourseCatalogState {
  const CourseCatalogState();
}

class CatalogLoading extends CourseCatalogState {
  const CatalogLoading();
}

class CatalogError extends CourseCatalogState {
  const CatalogError(this.message);

  final String message;
}

abstract class CatalogContent extends CourseCatalogState {
  const CatalogContent({
    required this.courses,
    required this.visibleCourses,
    required this.categories,
    required this.query,
    required this.category,
    required this.favorites,
    required this.favoritesOnly,
    required this.sort,
  });

  final List<Course> courses;
  final List<Course> visibleCourses;
  final List<String> categories;
  final String query;
  final String category;
  final Set<String> favorites;
  final bool favoritesOnly;
  final CourseSort sort;
}

class CatalogSuccess extends CatalogContent {
  const CatalogSuccess({
    required super.courses,
    required super.visibleCourses,
    required super.categories,
    required super.query,
    required super.category,
    required super.favorites,
    required super.favoritesOnly,
    required super.sort,
  });
}

class CatalogEmpty extends CatalogContent {
  const CatalogEmpty({
    required super.courses,
    required super.visibleCourses,
    required super.categories,
    required super.query,
    required super.category,
    required super.favorites,
    required super.favoritesOnly,
    required super.sort,
  });
}

class CourseCatalogCubit extends Cubit<CourseCatalogState> {
  CourseCatalogCubit(this._repository) : super(const CatalogLoading());

  final CourseRepository _repository;
  List<Course> _courses = const [];
  final Set<String> _favorites = {};
  String _query = '';
  String _category = 'All';
  bool _favoritesOnly = false;
  CourseSort _sort = CourseSort.recommended;

  Future<void> loadCourses() async {
    emit(const CatalogLoading());
    try {
      _courses = await _repository.loadCourses();
      _category = 'All';
      _publish();
    } on Object catch (error) {
      emit(CatalogError('We could not load your courses. $error'));
    }
  }

  void search(String value) {
    _query = value.trim();
    _publish();
  }

  void selectCategory(String value) {
    _category = value;
    _publish();
  }

  void toggleFavoritesOnly() {
    _favoritesOnly = !_favoritesOnly;
    _publish();
  }

  void toggleFavorite(String courseId) {
    if (!_favorites.add(courseId)) _favorites.remove(courseId);
    _publish();
  }

  void setSort(CourseSort value) {
    _sort = value;
    _publish();
  }

  void _publish() {
    final categories =
        <String>{'All', ..._courses.map((course) => course.category)}.toList();
    final normalizedQuery = _query.toLowerCase();
    final visible = _courses.where((course) {
      final matchesQuery = normalizedQuery.isEmpty ||
          course.title.toLowerCase().contains(normalizedQuery) ||
          course.instructor.toLowerCase().contains(normalizedQuery) ||
          course.category.toLowerCase().contains(normalizedQuery);
      final matchesCategory =
          _category == 'All' || course.category == _category;
      final matchesFavorites =
          !_favoritesOnly || _favorites.contains(course.id);
      return matchesQuery && matchesCategory && matchesFavorites;
    }).toList();

    switch (_sort) {
      case CourseSort.recommended:
        visible.sort((a, b) {
          final progressOrder = b.progress.compareTo(a.progress);
          return progressOrder == 0
              ? b.rating.compareTo(a.rating)
              : progressOrder;
        });
      case CourseSort.title:
        visible.sort((a, b) => a.title.compareTo(b.title));
      case CourseSort.rating:
        visible.sort((a, b) => b.rating.compareTo(a.rating));
    }

    final allCourses = List<Course>.unmodifiable(_courses);
    final visibleCourses = List<Course>.unmodifiable(visible);
    final immutableCategories = List<String>.unmodifiable(categories);
    final favoriteIds = Set<String>.unmodifiable(_favorites);

    if (visible.isEmpty) {
      emit(CatalogEmpty(
        courses: allCourses,
        visibleCourses: visibleCourses,
        categories: immutableCategories,
        query: _query,
        category: _category,
        favorites: favoriteIds,
        favoritesOnly: _favoritesOnly,
        sort: _sort,
      ));
    } else {
      emit(CatalogSuccess(
        courses: allCourses,
        visibleCourses: visibleCourses,
        categories: immutableCategories,
        query: _query,
        category: _category,
        favorites: favoriteIds,
        favoritesOnly: _favoritesOnly,
        sort: _sort,
      ));
    }
  }
}
