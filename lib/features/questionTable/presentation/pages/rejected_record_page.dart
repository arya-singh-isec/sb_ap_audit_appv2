// lib/presentation/pages/rejected_record_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sb_ap_audit_appv2/features/questionTable/presentation/blocs/question_bloc.dart';

import '../../../summary/domain/entities/record.dart';
import '../../data/repository/question_repository_impl.dart';
import '../../domain/entities/question.dart';
import '../../domain/usecases/get_questions.dart';
import '../widget/question_card.dart';

class RejectedRecordPage extends StatelessWidget {
  final Record record;

  const RejectedRecordPage({super.key, required this.record});

  void _showQuestionDetail(BuildContext context, Question question) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Question No: ${question.questionNo}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text('Sub Broker: ${question.subBroker}'),
                      SizedBox(height: 8),
                      Text('Reviewer: ${question.reviewer}'),
                      SizedBox(height: 8),
                      Text('Corporate: ${question.corporate}'),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final questionRepository = QuestionRepositoryImpl();
    final getQuestion = GetQuestion(questionRepository);

    return BlocProvider(
      create: (context) =>
          QuestionCubit(getQuestions: getQuestion)..fetchQuestions(),
      child: BlocBuilder<QuestionCubit, QuestionState>(
        builder: (context, state) {
          if (state is QuestionInitial) {
            return const Center(
                child: Text('Please wait while we fetch data...'));
          } else if (state is QuestionLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is QuestionLoaded) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: const [
                      Expanded(
                          child: Text('Ques. No', textAlign: TextAlign.center)),
                      Expanded(
                          child:
                              Text('Sub broker', textAlign: TextAlign.center)),
                      Expanded(
                          child: Text('Reviewer', textAlign: TextAlign.center)),
                      Expanded(
                          child:
                              Text('Corporate', textAlign: TextAlign.center)),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.question.length,
                    itemBuilder: (context, index) {
                      final question = state.question[index];
                      return GestureDetector(
                        onTap: () => _showQuestionDetail(context, question),
                        child: QuestionCard(question: question),
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (state is QuestionError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Unexpected state'));
          }
        },
      ),
    );
  }
}
