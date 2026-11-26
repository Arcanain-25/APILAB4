import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';
import 'data/course_repository.dart';
import 'data/learning_content_repository.dart';
import 'features/catalog/course_catalog_cubit.dart';
import 'features/dashboard/learning_content_cubit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              CourseCatalogCubit(HttpCourseRepository())..loadCourses(),
        ),
        BlocProvider(
          create: (_) =>
              LearningContentCubit(HttpLearningContentRepository())..load(),
        ),
      ],
      child: const EduLearnApp(),
    ),
  );
}
