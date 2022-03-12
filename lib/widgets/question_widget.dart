import 'package:educationgo/resources/styles.dart';
import 'package:flutter/material.dart';

class QuestionWidget extends StatelessWidget {
  final String questionText;

  const QuestionWidget({Key? key, required this.questionText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: double.infinity,
      child: Text(
        questionText.toString(),
        style: TextStyles.questionStyle,
        
      ),
    );
  }
}
