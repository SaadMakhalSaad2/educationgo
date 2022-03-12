import 'package:flutter/material.dart';

class AnswerWidget extends StatelessWidget {
  final Function() answerSelectedHandler;
  final String answerText;
  const AnswerWidget(
      {Key? key, required this.answerText, required this.answerSelectedHandler})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: TextButton(
        onPressed: answerSelectedHandler,
        child: Text(answerText),
      ),
    );
  }
}
