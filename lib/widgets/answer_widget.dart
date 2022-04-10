import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AnswerWidget extends StatelessWidget {
  final Function() answerSelectedHandler;
  final String answerText;
  final String questionId;
  const AnswerWidget(
      {Key? key,
      required this.answerText,
      required this.answerSelectedHandler,
      required this.questionId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _checkAnswered(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (snapshot.data == false) {
              return SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: answerSelectedHandler,
                  child: Text(
                    answerText,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              );
            } else {
              return SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    answerText,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              );
            }
          }
        });
  }

  Future<bool> _checkAnswered() async {
    bool answered = false;
    DatabaseReference ref = FirebaseDatabase.instance.ref(
        'answer_reports/${questionId}_${FirebaseAuth.instance.currentUser!.uid}');
    DatabaseEvent event = await ref.once();

    if (event.snapshot.exists) {
      answered = true;
    }

    return answered;
  }
}

// Container(
//       width: double.infinity,
//       child: TextButton(
//         onPressed: answerSelectedHandler,
//         child: Text(answerText),
//       ),
//     )
