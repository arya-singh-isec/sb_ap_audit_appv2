import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/question.dart';
import '../../domain/usecases/get_questions.dart';



abstract class QuestionState {}


class QuestionInitial extends QuestionState {}


class QuestionLoading extends QuestionState{}

class QuestionLoaded extends QuestionState{
  final List<Question> question;
  QuestionLoaded(this.question);
}

class QuestionError extends QuestionState {
  final String message;
  QuestionError(this.message);

}


class QuestionCubit extends Cubit<QuestionState>{
  final GetQuestion getQuestions;
  QuestionCubit({required this.getQuestions}):super(QuestionInitial());
  Future<void>fetchQuestions() async {
    try{
      emit (QuestionLoading());
      final  question=await getQuestions();
      emit(QuestionLoaded(question));
    }catch(e){
      emit(QuestionError(e.toString()));
    }
  }
}
