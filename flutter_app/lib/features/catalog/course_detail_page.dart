import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/course.dart';
import 'course_catalog_cubit.dart';

class CourseDetailPage extends StatelessWidget {
  const CourseDetailPage({required this.course, super.key});

  final Course course;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CourseCatalogCubit>();
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 245,
            backgroundColor: const Color(0xFF193A36),
            foregroundColor: Colors.white,
            actions: [
              BlocBuilder<CourseCatalogCubit, CourseCatalogState>(
                builder: (context, state) {
                  final saved = state is CatalogContent &&
                      state.favorites.contains(course.id);
                  return IconButton(
                    tooltip:
                        saved ? 'Remove from saved courses' : 'Save course',
                    onPressed: () => cubit.toggleFavorite(course.id),
                    icon: Icon(saved ? Icons.bookmark : Icons.bookmark_border),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    course.coverUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(color: const Color(0xFF356E61)),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.05),
                          Colors.black.withValues(alpha: 0.62)
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 22,
                    right: 22,
                    bottom: 25,
                    child: Text(
                      course.category.toUpperCase(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(course.title,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontSize: 29)),
                  const SizedBox(height: 8),
                  Text('By ${course.instructor}  ·  ${course.level}',
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 18,
                    runSpacing: 10,
                    children: [
                      _MetaItem(
                          icon: Icons.schedule_rounded,
                          label: course.durationLabel),
                      _MetaItem(
                          icon: Icons.play_lesson_outlined,
                          label: '${course.totalLessons} lessons'),
                      _MetaItem(
                          icon: Icons.star_rounded,
                          label: course.rating.toStringAsFixed(1)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text('About this course',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 7),
                  Text(course.description,
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                          child: Text('Lessons',
                              style: Theme.of(context).textTheme.titleLarge)),
                      Text(
                          '${course.completedLessons}/${course.totalLessons} complete',
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: course.progress,
                    minHeight: 5,
                    borderRadius: BorderRadius.circular(4),
                    color: const Color(0xFF5A9B79),
                    backgroundColor: const Color(0xFFE1E8E1),
                  ),
                  const SizedBox(height: 10),
                  ...course.lessons.asMap().entries.map((entry) {
                    final index = entry.key;
                    final lesson = entry.value;
                    return _LessonTile(index: index, lesson: lesson);
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 17, color: const Color(0xFF26796D)),
          const SizedBox(width: 5),
          Text(label,
              style: const TextStyle(color: Color(0xFF53615C), fontSize: 13)),
        ],
      );
}

class _LessonTile extends StatelessWidget {
  const _LessonTile({required this.index, required this.lesson});

  final int index;
  final CourseLesson lesson;

  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          radius: 17,
          backgroundColor:
              lesson.completed ? const Color(0xFFDCEBE0) : Colors.white,
          child: lesson.completed
              ? const Icon(Icons.check_rounded,
                  size: 18, color: Color(0xFF26796D))
              : Text('${index + 1}',
                  style:
                      const TextStyle(color: Color(0xFF53615C), fontSize: 13)),
        ),
        title: Text(lesson.title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        subtitle: Text(lesson.duration),
        trailing: Icon(
          lesson.completed ? Icons.check_circle : Icons.play_circle_outline,
          color: lesson.completed
              ? const Color(0xFF5A9B79)
              : const Color(0xFF26796D),
        ),
      );
}
