import '../../domain/entities/question.dart';
import '../../domain/repositories/question_repository.dart';


class QuestionRepositoryImpl implements QuestionRepository {
  @override
  Future<List<Question>> getQuestions() async{

    await Future.delayed( Duration(seconds: 1));

    return [
      Question(questionNo: '1', subBroker: 'N', reviewer: 'Y', corporate: 'Y'),
      Question(questionNo: '2', subBroker: 'Y', reviewer: 'Y', corporate: 'Y'),
    ];

  }
}