class LearningContent {
  const LearningContent({required this.home, required this.courseOverview});

  final HomePageData home;
  final CourseOverviewPageData courseOverview;

  factory LearningContent.fromJson(Map<String, dynamic> json) =>
      LearningContent(
        home: HomePageData.fromJson(json['homePage'] as Map<String, dynamic>),
        courseOverview: CourseOverviewPageData.fromJson(
          json['courseOverviewPage'] as Map<String, dynamic>,
        ),
      );
}

class HomePageData {
  const HomePageData({
    required this.header,
    required this.learnedToday,
    required this.myCoursesTitle,
    required this.myCoursesActionLabel,
    required this.learningPrompt,
    required this.learningPlanTitle,
    required this.learningPlanItems,
    required this.meetup,
  });

  final HomeHeaderData header;
  final LearnedTodayData learnedToday;
  final String myCoursesTitle;
  final String myCoursesActionLabel;
  final LearningPromptData learningPrompt;
  final String learningPlanTitle;
  final List<LearningPlanItemData> learningPlanItems;
  final MeetupData meetup;

  factory HomePageData.fromJson(Map<String, dynamic> json) => HomePageData(
        header: HomeHeaderData.fromJson(json['header'] as Map<String, dynamic>),
        learnedToday: LearnedTodayData.fromJson(
          json['learnedToday'] as Map<String, dynamic>,
        ),
        myCoursesTitle:
            (json['myCourses'] as Map<String, dynamic>)['title'] as String,
        myCoursesActionLabel: (json['myCourses']
            as Map<String, dynamic>)['actionLabel'] as String,
        learningPrompt: LearningPromptData.fromJson(
          json['learningPrompt'] as Map<String, dynamic>,
        ),
        learningPlanTitle:
            (json['learningPlan'] as Map<String, dynamic>)['title'] as String,
        learningPlanItems: ((json['learningPlan']
                as Map<String, dynamic>)['items'] as List<dynamic>)
            .map((item) =>
                LearningPlanItemData.fromJson(item as Map<String, dynamic>))
            .toList(growable: false),
        meetup: MeetupData.fromJson(json['meetup'] as Map<String, dynamic>),
      );
}

class HomeHeaderData {
  const HomeHeaderData({
    required this.greeting,
    required this.subtitle,
    required this.avatarUrl,
    required this.hasUnread,
    required this.notificationIconUrl,
  });

  final String greeting;
  final String subtitle;
  final String avatarUrl;
  final bool hasUnread;
  final String notificationIconUrl;

  factory HomeHeaderData.fromJson(Map<String, dynamic> json) {
    final notification = json['notification'] as Map<String, dynamic>;
    return HomeHeaderData(
      greeting: json['greeting'] as String,
      subtitle: json['subtitle'] as String,
      avatarUrl: json['avatarUrl'] as String,
      hasUnread: notification['hasUnread'] as bool,
      notificationIconUrl: notification['iconUrl'] as String,
    );
  }
}

class LearnedTodayData {
  const LearnedTodayData({
    required this.title,
    required this.learnedMinutes,
    required this.goalMinutes,
    required this.formatted,
    required this.progress,
  });

  final String title;
  final int learnedMinutes;
  final int goalMinutes;
  final String formatted;
  final double progress;

  factory LearnedTodayData.fromJson(Map<String, dynamic> json) =>
      LearnedTodayData(
        title: json['title'] as String,
        learnedMinutes: json['learnedMinutes'] as int,
        goalMinutes: json['goalMinutes'] as int,
        formatted: json['formatted'] as String,
        progress: (json['progress'] as num).toDouble(),
      );
}

class LearningPromptData {
  const LearningPromptData({
    required this.title,
    required this.actionLabel,
    required this.imageUrl,
  });

  final String title;
  final String actionLabel;
  final String imageUrl;

  factory LearningPromptData.fromJson(Map<String, dynamic> json) =>
      LearningPromptData(
        title: json['title'] as String,
        actionLabel: json['actionLabel'] as String,
        imageUrl: json['imageUrl'] as String,
      );
}

class LearningPlanItemData {
  const LearningPlanItemData({
    required this.id,
    required this.title,
    required this.completed,
    required this.total,
    required this.progress,
    required this.progressIconUrl,
  });

  final String id;
  final String title;
  final int completed;
  final int total;
  final double progress;
  final String progressIconUrl;

  factory LearningPlanItemData.fromJson(Map<String, dynamic> json) =>
      LearningPlanItemData(
        id: json['id'] as String,
        title: json['title'] as String,
        completed: json['completed'] as int,
        total: json['total'] as int,
        progress: (json['progress'] as num).toDouble(),
        progressIconUrl: json['progressIconUrl'] as String,
      );
}

class MeetupData {
  const MeetupData(
      {required this.title, required this.subtitle, required this.imageUrl});

  final String title;
  final String subtitle;
  final String imageUrl;

  factory MeetupData.fromJson(Map<String, dynamic> json) => MeetupData(
        title: json['title'] as String,
        subtitle: json['subtitle'] as String,
        imageUrl: json['imageUrl'] as String,
      );
}

class CourseOverviewPageData {
  const CourseOverviewPageData({
    required this.navigation,
    required this.course,
    required this.tabs,
    required this.price,
    required this.enroll,
    required this.icons,
  });

  final CourseNavigationData navigation;
  final CourseOverviewData course;
  final List<CourseTabData> tabs;
  final CoursePriceData price;
  final CourseEnrollData enroll;
  final CourseUiIconsData icons;

  factory CourseOverviewPageData.fromJson(Map<String, dynamic> json) {
    final courseJson = json['course'] as Map<String, dynamic>;
    final actions = json['actions'] as Map<String, dynamic>;
    final tabsJson =
        (courseJson['tabs'] as Map<String, dynamic>)['items'] as List<dynamic>;
    return CourseOverviewPageData(
      navigation: CourseNavigationData.fromJson(
          json['navigation'] as Map<String, dynamic>),
      course: CourseOverviewData.fromJson(courseJson),
      tabs: tabsJson
          .map((item) => CourseTabData.fromJson(item as Map<String, dynamic>))
          .toList(growable: false),
      price: CoursePriceData.fromJson(actions['price'] as Map<String, dynamic>),
      enroll:
          CourseEnrollData.fromJson(actions['enroll'] as Map<String, dynamic>),
      icons:
          CourseUiIconsData.fromJson(json['uiIcons'] as Map<String, dynamic>),
    );
  }
}

class CourseNavigationData {
  const CourseNavigationData({required this.title, required this.backIconUrl});

  final String title;
  final String backIconUrl;

  factory CourseNavigationData.fromJson(Map<String, dynamic> json) =>
      CourseNavigationData(
        title: json['title'] as String,
        backIconUrl: json['backIconUrl'] as String,
      );
}

class CourseOverviewData {
  const CourseOverviewData({
    required this.id,
    required this.title,
    required this.duration,
    required this.durationMinutes,
    required this.lessonCount,
    required this.rating,
    required this.hero,
    required this.lessons,
    required this.description,
  });

  final String id;
  final String title;
  final String duration;
  final int durationMinutes;
  final int lessonCount;
  final double rating;
  final CourseHeroData hero;
  final List<CourseOverviewLessonData> lessons;
  final String description;

  factory CourseOverviewData.fromJson(Map<String, dynamic> json) =>
      CourseOverviewData(
        id: json['id'] as String,
        title: json['title'] as String,
        duration: json['duration'] as String,
        durationMinutes: json['durationMinutes'] as int,
        lessonCount: json['lessonCount'] as int,
        rating: (json['rating'] as num).toDouble(),
        hero: CourseHeroData.fromJson(json['hero'] as Map<String, dynamic>),
        lessons: (json['lessons'] as List<dynamic>)
            .map((item) =>
                CourseOverviewLessonData.fromJson(item as Map<String, dynamic>))
            .toList(growable: false),
        description:
            (json['description'] as Map<String, dynamic>)['text'] as String,
      );
}

class CourseHeroData {
  const CourseHeroData({
    required this.label,
    required this.imageUrl,
    required this.playIconUrl,
    required this.videoCount,
    required this.classCount,
  });

  final String label;
  final String imageUrl;
  final String playIconUrl;
  final int videoCount;
  final int classCount;

  factory CourseHeroData.fromJson(Map<String, dynamic> json) => CourseHeroData(
        label: json['label'] as String,
        imageUrl: json['imageUrl'] as String,
        playIconUrl: json['playIconUrl'] as String,
        videoCount: json['videoCount'] as int,
        classCount: json['classCount'] as int,
      );
}

class CourseOverviewLessonData {
  const CourseOverviewLessonData({
    required this.id,
    required this.title,
    required this.duration,
    required this.durationSeconds,
    required this.completed,
    required this.locked,
    required this.playIconUrl,
    required this.arrowIconUrl,
  });

  final String id;
  final String title;
  final String duration;
  final int durationSeconds;
  final bool completed;
  final bool locked;
  final String playIconUrl;
  final String arrowIconUrl;

  factory CourseOverviewLessonData.fromJson(Map<String, dynamic> json) =>
      CourseOverviewLessonData(
        id: json['id'] as String,
        title: json['title'] as String,
        duration: json['duration'] as String,
        durationSeconds: json['durationSeconds'] as int,
        completed: json['completed'] as bool,
        locked: json['locked'] as bool,
        playIconUrl: json['playIconUrl'] as String,
        arrowIconUrl: json['arrowIconUrl'] as String,
      );
}

class CourseTabData {
  const CourseTabData(
      {required this.id, required this.label, required this.selected});

  final String id;
  final String label;
  final bool selected;

  factory CourseTabData.fromJson(Map<String, dynamic> json) => CourseTabData(
        id: json['id'] as String,
        label: json['label'] as String,
        selected: json['selected'] as bool,
      );
}

class CoursePriceData {
  const CoursePriceData(
      {required this.label, required this.amount, required this.currency});

  final String label;
  final num amount;
  final String currency;

  factory CoursePriceData.fromJson(Map<String, dynamic> json) =>
      CoursePriceData(
        label: json['label'] as String,
        amount: json['amount'] as num,
        currency: json['currency'] as String,
      );
}

class CourseEnrollData {
  const CourseEnrollData({required this.label, required this.enabled});

  final String label;
  final bool enabled;

  factory CourseEnrollData.fromJson(Map<String, dynamic> json) =>
      CourseEnrollData(
        label: json['label'] as String,
        enabled: json['enabled'] as bool,
      );
}

class CourseUiIconsData {
  const CourseUiIconsData({
    required this.durationIconUrl,
    required this.lessonsIconUrl,
    required this.ratingIconUrl,
  });

  final String durationIconUrl;
  final String lessonsIconUrl;
  final String ratingIconUrl;

  factory CourseUiIconsData.fromJson(Map<String, dynamic> json) =>
      CourseUiIconsData(
        durationIconUrl: json['durationIconUrl'] as String,
        lessonsIconUrl: json['lessonsIconUrl'] as String,
        ratingIconUrl: json['ratingIconUrl'] as String,
      );
}
