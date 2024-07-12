// lib/presentation/pages/rejected_record_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sb_ap_audit_appv2/features/summary/domain/entities/record.dart';
import 'package:sb_ap_audit_appv2/features/questionTable/presentation/blocs/question_bloc.dart';
import 'package:sb_ap_audit_appv2/features/questionTable/domain/entities/question.dart';
import 'package:sb_ap_audit_appv2/features/questionTable/presentation/widget/question_card.dart';
import 'package:sb_ap_audit_appv2/injection_container.dart' as di;

class RejectedRecordPageArguments {
  final Record record;

  RejectedRecordPageArguments({required this.record});
}

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
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('Sub Broker: ${question.subBroker}'),
                      const SizedBox(height: 8),
                      Text('Reviewer: ${question.reviewer}'),
                      const SizedBox(height: 8),
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
    return BlocProvider(
      create: (context) => di.sl<QuestionCubit>()..fetchQuestions(),
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
                    itemCount: state.questions.length,
                    itemBuilder: (context, index) {
                      final question = state.questions[index];
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