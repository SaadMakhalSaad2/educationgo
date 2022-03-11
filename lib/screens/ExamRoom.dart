import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../models/Question.dart';
import '../models/Quiz.dart';

class ExamRoom extends StatelessWidget {
  final Quiz quiz;
  const ExamRoom({Key? key, required this.quiz}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(quiz.title),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder(
          future: _downloadQuestions(quiz.questions),
          builder:
              (BuildContext context, AsyncSnapshot<List<Question>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return _buildQuestion(snapshot.data![index]);
                    });
              }
              return const Center(child: Text('question not found'));
            }
          }),
    );
  }

  Widget _buildQuestion(Question question) {
    return Text(question.text.toString());
  }

  Future<List<Question>> _downloadQuestions(List<String> questions) async {
    List<Question> actualQuestions = [];
    for (var element in questions) {
      DatabaseEvent event =
          await FirebaseDatabase.instance.ref('questions/$element').once();
      var data = event.snapshot.value as Map<dynamic, dynamic>;

      Question question =
          Question(data['id'], data['grade'], data['subject'], data['text']);
      actualQuestions.add(question);
    }

    return actualQuestions;
  }
}
