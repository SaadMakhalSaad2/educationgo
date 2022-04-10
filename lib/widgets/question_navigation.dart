import 'package:flutter/material.dart';

class QuestionNavigation extends StatelessWidget {
  final Function() moveNext;
  final Function() movePrevious;
  const QuestionNavigation(
      {Key? key, required this.moveNext, required this.movePrevious})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      IconButton(
        icon: const Icon(
          Icons.skip_previous_rounded,
        ),
        onPressed: movePrevious,
      ),
      IconButton(
        icon: const Icon(Icons.skip_next_rounded),
        onPressed: moveNext,
      ),
    ]);
  }
}
