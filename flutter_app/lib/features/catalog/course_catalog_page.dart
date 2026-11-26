import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/course.dart';
import 'course_catalog_cubit.dart';
import 'course_card.dart';
import 'course_detail_page.dart';
import '../dashboard/learning_content_cubit.dart';
import 'json_course_detail_page.dart';

class CourseCatalogPage extends StatelessWidget {
  const CourseCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: BlocBuilder<CourseCatalogCubit, CourseCatalogState>(
            builder: (context, state) {
              if (state is CatalogLoading) return const _LoadingView();
              if (state is CatalogError) {
                return _ErrorView(message: state.message);
              }
              return _CatalogView(content: state as CatalogContent);
            },
          ),
        ),
      ),
    );
  }
}

class _CatalogView extends StatelessWidget {
  const _CatalogView({required this.content});

  final CatalogContent content;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CourseCatalogCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.menu_book_rounded,
                color: Color(0xFF26796D), size: 25),
            const SizedBox(width: 8),
            Text(
              'EDULEARN',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: const Color(0xFF193A36),
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
            ),
            const Spacer(),
            IconButton(
              tooltip: content.favoritesOnly
                  ? 'Show all courses'
                  : 'Show saved courses',
              onPressed: cubit.toggleFavoritesOnly,
              icon: Icon(
                content.favoritesOnly ? Icons.bookmark : Icons.bookmark_border,
                color: const Color(0xFF26796D),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text('Find your next\nfavorite subject.',
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 9),
        Text(
          'Small lessons. Big progress.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 18),
        TextField(
          onChanged: cubit.search,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Search courses or instructors',
            prefixIcon: const Icon(Icons.search_rounded),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: content.categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final category = content.categories[index];
              final selected = category == content.category;
              return ChoiceChip(
                label: Text(category),
                selected: selected,
                showCheckmark: false,
                onSelected: (_) => cubit.selectCategory(category),
                labelStyle: TextStyle(
                  color: selected ? Colors.white : const Color(0xFF53615C),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                backgroundColor: Colors.white,
                selectedColor: const Color(0xFF26796D),
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 6),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Text(
              content.favoritesOnly ? 'SAVED' : 'COURSES',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: const Color(0xFF193A36),
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
            ),
            const SizedBox(width: 7),
            Text('${content.visibleCourses.length}',
                style: Theme.of(context).textTheme.bodySmall),
            const Spacer(),
            PopupMenuButton<CourseSort>(
              tooltip: 'Sort courses',
              initialValue: content.sort,
              onSelected: cubit.setSort,
              itemBuilder: (_) => const [
                PopupMenuItem(
                    value: CourseSort.recommended, child: Text('Recommended')),
                PopupMenuItem(
                    value: CourseSort.title, child: Text('Title A–Z')),
                PopupMenuItem(
                    value: CourseSort.rating, child: Text('Top rated')),
              ],
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: Row(
                  children: [
                    Icon(Icons.sort_rounded,
                        size: 19, color: Color(0xFF53615C)),
                    SizedBox(width: 4),
                    Text('Sort', style: TextStyle(color: Color(0xFF53615C))),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Expanded(
          child: content is CatalogEmpty
              ? _EmptyView(content: content)
              : ListView.separated(
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: content.visibleCourses.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 13),
                  itemBuilder: (context, index) {
                    final course = content.visibleCourses[index];
                    return CourseCard(
                      course: course,
                      isFavorite: content.favorites.contains(course.id),
                      onFavorite: () => cubit.toggleFavorite(course.id),
                      onTap: () => _openCourse(context, course),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

void _openCourse(BuildContext context, Course course) {
  final contentState = context.read<LearningContentCubit>().state;
  final overview = contentState is LearningContentLoaded
      ? contentState.content.courseOverview
      : null;
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => overview != null && overview.course.id == course.id
          ? JsonCourseDetailPage(overview: overview)
          : CourseDetailPage(course: course),
    ),
  );
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) => const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Color(0xFF26796D)),
            SizedBox(height: 14),
            Text('Loading your courses...'),
          ],
        ),
      );
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_outlined,
                size: 36, color: Color(0xFFB65D48)),
            const SizedBox(height: 12),
            const Text('Courses could not be loaded',
                style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: context.read<CourseCatalogCubit>().loadCourses,
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
            ),
          ],
        ),
      );
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.content});

  final CatalogContent content;

  @override
  Widget build(BuildContext context) {
    final noCourses = content.courses.isEmpty;
    final message = noCourses
        ? 'There are no courses to show yet.'
        : content.favoritesOnly
            ? 'Save a course with the bookmark to find it here.'
            : 'Try another search or category.';
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              content.favoritesOnly
                  ? Icons.bookmark_border
                  : Icons.search_off_rounded,
              size: 36,
              color: const Color(0xFF26796D),
            ),
            const SizedBox(height: 12),
            Text(
              noCourses ? 'Your catalog is empty' : 'No courses found',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 6),
            Text(message, textAlign: TextAlign.center),
            if (!noCourses &&
                (content.query.isNotEmpty || content.category != 'All')) ...[
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  context.read<CourseCatalogCubit>().search('');
                  context.read<CourseCatalogCubit>().selectCategory('All');
                },
                child: const Text('Clear search and filters'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
