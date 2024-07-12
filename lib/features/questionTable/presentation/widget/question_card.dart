// lib/presentation/widgets/question_card.dart
import 'package:flutter/material.dart';
import '../../domain/entities/question.dart';

// class QuestionCard extends StatelessWidget {
//   final Question question;

//   QuestionCard({required this.question});

//   @override
//   Widget build(BuildContext context) {
//     bool isAnyFieldN = question.subBroker == 'N' || question.reviewer == 'N' || question.corporate == 'N';
//     Color textColor(String value) => value == 'N' ? Colors.red : Colors.green;

//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//       decoration: const BoxDecoration(
//         border: Border(
//           bottom: BorderSide(color: Colors.black),
//         ),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: Text(
//               '${question.questionNo}.',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: isAnyFieldN ? Colors.red : Colors.black,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//           Expanded(
//             child: Text(
//               question.subBroker,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: textColor(question.subBroker),
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//           Expanded(
//             child: Text(
//               question.reviewer,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: textColor(question.reviewer),
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//           Expanded(
//             child: Text(
//               question.corporate,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: textColor(question.corporate),
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class QuestionCard extends StatelessWidget {
  final Question question;

  QuestionCard({required this.question});

  @override
  Widget build(BuildContext context) {
    bool isAnyFieldN = question.subBroker == 'N' || question.reviewer == 'N' || question.corporate == 'N';
    Color textColor(String? value) {
      if (value == null) return Colors.black; // Handle null case
      return value == 'N' ? Colors.red : Colors.green;
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              '${question.questionNo}.',
              style: TextStyle(
                fontSize: 16,
                color: isAnyFieldN ? Colors.red : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              question.subBroker,
              style: TextStyle(
                fontSize: 16,
                color: textColor(question.subBroker),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              question.reviewer,
              style: TextStyle(
                fontSize: 16,
                color: textColor(question.reviewer),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              question.corporate,
              style: TextStyle(
                fontSize: 16,
                color: textColor(question.corporate),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}