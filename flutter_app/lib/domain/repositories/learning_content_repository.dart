import '../../data/learning_content.dart';

abstract interface class LearningContentRepository {
  Future<LearningContent> load();
}
