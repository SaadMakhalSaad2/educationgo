import 'package:educationgo/models/question.dart';
import 'package:flutter/material.dart';

import '../widgets/answer_widget.dart';
import '../widgets/question_widget.dart';

class QuizzingPage extends StatelessWidget {
  final List<Question>? questions;
  final int currentIndex;
  final Function answerQuestion;
  const QuizzingPage(
      {Key? key,
      required this.questions,
      required this.currentIndex,
      required this.answerQuestion})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        QuestionWidget(
          questionText: questions![currentIndex].text.toString(),
        ),
        ...(questions![currentIndex].answers).map((answer) {
          var a = answer as Map<Object?, Object?>;
          return AnswerWidget(
              answerSelectedHandler: () => answerQuestion(a['score']),
              answerText: answer['text'].toString());
        })
      ],
    );
  }
}
