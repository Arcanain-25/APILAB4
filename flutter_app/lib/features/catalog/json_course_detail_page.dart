import 'package:flutter/material.dart';

import '../../data/learning_content.dart';
import '../../widgets/remote_svg_icon.dart';

class JsonCourseDetailPage extends StatefulWidget {
  const JsonCourseDetailPage({required this.overview, super.key});

  final CourseOverviewPageData overview;

  @override
  State<JsonCourseDetailPage> createState() => _JsonCourseDetailPageState();
}

class _JsonCourseDetailPageState extends State<JsonCourseDetailPage> {
  late int _selectedTab;

  CourseOverviewData get course => widget.overview.course;

  @override
  void initState() {
    super.initState();
    final selected = widget.overview.tabs.indexWhere((tab) => tab.selected);
    _selectedTab = selected < 0 ? 0 : selected;
  }

  @override
  Widget build(BuildContext context) {
    final detail = widget.overview;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 250,
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF101012),
            automaticallyImplyLeading: false,
            leading: IconButton(
              tooltip: 'Back',
              onPressed: () => Navigator.of(context).maybePop(),
              icon: RemoteSvgIcon(
                url: detail.navigation.backIconUrl,
                fallback: Icons.arrow_back,
                size: 25,
              ),
            ),
            title: Text(
              detail.navigation.title,
              style: const TextStyle(
                  color: Color(0xFF101012),
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
            actions: const [SizedBox(width: 8)],
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.fromLTRB(20, 90, 20, 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        course.hero.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Container(color: const Color(0xFFCBD9E3)),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.48)
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 14,
                        bottom: 13,
                        child: Text(
                          course.hero.label,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1),
                        ),
                      ),
                      Center(
                        child: Material(
                          color: const Color(0xFFFF6F00),
                          shape: const CircleBorder(),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () =>
                                ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Course preview selected.')),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: RemoteSvgIcon(
                                url: course.hero.playIconUrl,
                                fallback: Icons.play_arrow,
                                size: 31,
                                color: const Color(0xFFFF6F00),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 12,
                        bottom: 12,
                        child: Text(
                          '${course.hero.videoCount} videos  ·  ${course.hero.classCount} classes',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(course.title,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontSize: 26)),
                  const SizedBox(height: 13),
                  Wrap(
                    spacing: 18,
                    runSpacing: 10,
                    children: [
                      _MetadataItem(
                        iconUrl: detail.icons.durationIconUrl,
                        fallback: Icons.schedule_outlined,
                        label: course.duration,
                      ),
                      _MetadataItem(
                        iconUrl: detail.icons.lessonsIconUrl,
                        fallback: Icons.menu_book_outlined,
                        label: '${course.lessonCount} lessons',
                      ),
                      _MetadataItem(
                        iconUrl: detail.icons.ratingIconUrl,
                        fallback: Icons.star_outline,
                        label: course.rating.toStringAsFixed(1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 23),
                  Row(
                    children: List.generate(detail.tabs.length, (index) {
                      final tab = detail.tabs[index];
                      final active = index == _selectedTab;
                      return Padding(
                        padding: EdgeInsets.only(
                            right: index == detail.tabs.length - 1 ? 0 : 25),
                        child: InkWell(
                          onTap: () => setState(() => _selectedTab = index),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tab.label,
                                  style: TextStyle(
                                    color: active
                                        ? const Color(0xFFFF6F00)
                                        : const Color(0xFF818891),
                                    fontWeight: active
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  width: active ? 46 : 0,
                                  height: 2,
                                  color: const Color(0xFFFF6F00),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const Divider(height: 1),
                  if (detail.tabs[_selectedTab].id == 'lessons') ...[
                    const SizedBox(height: 7),
                    ...course.lessons
                        .map((lesson) => _LessonRow(lesson: lesson)),
                  ] else ...[
                    const SizedBox(height: 17),
                    Text(
                      course.description.isEmpty
                          ? 'Course lessons and learning materials are listed here.'
                          : course.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          decoration: const BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                color: Color(0x16000000),
                blurRadius: 12,
                offset: Offset(0, -3)),
          ]),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(detail.price.label,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w800)),
                    Text('${detail.price.amount} ${detail.price.currency}',
                        style: const TextStyle(
                            color: Color(0xFF7E858C), fontSize: 11)),
                  ],
                ),
              ),
              FilledButton(
                onPressed: detail.enroll.enabled
                    ? () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('You are enrolled in this course.')),
                        )
                    : null,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6F00),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 13),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(detail.enroll.label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetadataItem extends StatelessWidget {
  const _MetadataItem({
    required this.iconUrl,
    required this.fallback,
    required this.label,
  });

  final String iconUrl;
  final IconData fallback;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          RemoteSvgIcon(url: iconUrl, fallback: fallback, size: 19),
          const SizedBox(width: 6),
          Text(label,
              style: const TextStyle(color: Color(0xFF686F78), fontSize: 13)),
        ],
      );
}

class _LessonRow extends StatelessWidget {
  const _LessonRow({required this.lesson});

  final CourseOverviewLessonData lesson;

  @override
  Widget build(BuildContext context) {
    final tint =
        lesson.locked ? const Color(0xFFFFE0CC) : const Color(0xFFFF6F00);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          RemoteSvgIcon(
            url: lesson.playIconUrl,
            fallback:
                lesson.locked ? Icons.lock_outline : Icons.play_circle_outline,
            size: 35,
            color: tint,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: lesson.locked
                        ? const Color(0xFF9AA0A6)
                        : const Color(0xFF17191C),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(lesson.duration,
                    style: const TextStyle(
                        color: Color(0xFF858B93), fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          RemoteSvgIcon(
            url: lesson.arrowIconUrl,
            fallback: Icons.chevron_right,
            size: 22,
            color: tint,
          ),
        ],
      ),
    );
  }
}
