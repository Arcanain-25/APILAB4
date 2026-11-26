import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/learning_content.dart';
import '../../domain/repositories/learning_content_repository.dart';

abstract class LearningContentState {
  const LearningContentState();
}

class LearningContentLoading extends LearningContentState {
  const LearningContentLoading();
}

class LearningContentError extends LearningContentState {
  const LearningContentError(this.message);

  final String message;
}

class LearningContentLoaded extends LearningContentState {
  const LearningContentLoaded(this.content);

  final LearningContent content;
}

class LearningContentCubit extends Cubit<LearningContentState> {
  LearningContentCubit(this._repository)
      : super(const LearningContentLoading());

  final LearningContentRepository _repository;

  Future<void> load() async {
    emit(const LearningContentLoading());
    try {
      emit(LearningContentLoaded(await _repository.load()));
    } on Object catch (error) {
      emit(LearningContentError('Learning data could not be loaded. $error'));
    }
  }
}
