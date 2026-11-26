import '../../data/learning_content.dart';
import '../repositories/learning_content_repository.dart';

class LoadLearningContent {
  const LoadLearningContent(this.repository);

  final LearningContentRepository repository;

  Future<LearningContent> call() => repository.load();
}
