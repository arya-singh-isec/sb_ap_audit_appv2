// lib/domain/usecases/get_records.dart
import '../entities/question.dart';
import '../repositories/question_repository.dart';




class GetQuestions {
  final QuestionRepository repository;

  GetQuestions(this.repository);

  Future<List<Question>> call() async {
    return await repository.getQuestions();
  }
}

