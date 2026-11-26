import 'package:flutter/material.dart';

import '../../data/course.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({
    required this.course,
    required this.isFavorite,
    required this.onFavorite,
    required this.onTap,
    super.key,
  });

  final Course course;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 148,
                  width: double.infinity,
                  child: Image.network(
                    course.coverUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFFDCE9E1),
                      alignment: Alignment.center,
                      child: const Icon(Icons.auto_stories_outlined,
                          size: 38, color: Color(0xFF26796D)),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.94),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 5),
                      child: Text(
                        course.category.toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xFF26796D),
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.7,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: IconButton.filledTonal(
                    tooltip: isFavorite
                        ? 'Remove from saved courses'
                        : 'Save course',
                    onPressed: onFavorite,
                    style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.95)),
                    icon: Icon(
                      isFavorite ? Icons.bookmark : Icons.bookmark_border,
                      color: const Color(0xFF26796D),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 13, 15, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          course.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontSize: 17),
                        ),
                      ),
                      const Icon(Icons.star_rounded,
                          size: 17, color: Color(0xFFE2A64B)),
                      const SizedBox(width: 3),
                      Text(course.rating.toStringAsFixed(1),
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('${course.instructor}  ·  ${course.level}',
                      style: TextStyle(color: muted, fontSize: 12)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.schedule_rounded, size: 15, color: muted),
                      const SizedBox(width: 4),
                      Text(course.durationLabel,
                          style: TextStyle(color: muted, fontSize: 12)),
                      const SizedBox(width: 13),
                      Icon(Icons.play_lesson_outlined, size: 15, color: muted),
                      const SizedBox(width: 4),
                      Text('${course.totalLessons} lessons',
                          style: TextStyle(color: muted, fontSize: 12)),
                      const Spacer(),
                      Text('${(course.progress * 100).round()}%',
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 7),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: course.progress,
                      minHeight: 5,
                      backgroundColor: const Color(0xFFE8ECE7),
                      color: const Color(0xFF5A9B79),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
