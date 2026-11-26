import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:edulearn_flutter/data/learning_content.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('bundled lab JSON exposes every image and icon URL', () async {
    final source = await rootBundle.loadString('assets/data/lab_v4.json');
    final content = LearningContent.fromJson(
      jsonDecode(source) as Map<String, dynamic>,
    );
    final detail = content.courseOverview;
    final urls = [
      content.home.header.avatarUrl,
      content.home.header.notificationIconUrl,
      content.home.learningPrompt.imageUrl,
      content.home.meetup.imageUrl,
      ...content.home.learningPlanItems.map((item) => item.progressIconUrl),
      detail.navigation.backIconUrl,
      detail.course.hero.imageUrl,
      detail.course.hero.playIconUrl,
      ...detail.course.lessons
          .expand((lesson) => [lesson.playIconUrl, lesson.arrowIconUrl]),
      detail.icons.durationIconUrl,
      detail.icons.lessonsIconUrl,
      detail.icons.ratingIconUrl,
    ];

    expect(urls, hasLength(20));
    expect(urls.every((url) => Uri.parse(url).scheme == 'https'), isTrue);
    expect(detail.course.lessonCount, 7);
    expect(detail.course.lessons, hasLength(4));
  });
}
