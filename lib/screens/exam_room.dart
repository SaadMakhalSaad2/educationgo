import 'package:educationgo/screens/quizzing_page.dart';
import 'package:educationgo/screens/result_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../models/question.dart';
import '../models/quiz.dart';

class ExamRoom extends StatefulWidget {
  final Quiz quiz;
  const ExamRoom({Key? key, required this.quiz}) : super(key: key);

  @override
  State<ExamRoom> createState() => _ExamRoomState();
}

class _ExamRoomState extends State<ExamRoom> {
  var _currentIndex = 0;
  var _totalScore = 0;

  void _resetQuiz() {
    setState(() {
      _currentIndex = 0;
      _totalScore = 0;
    });
  }

  void _answerQuestion(int score) {
    _totalScore += score;
    setState(() {
      _currentIndex = _currentIndex + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz.title),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder(
          future: _downloadQuestions(widget.quiz.questions),
          builder:
              (BuildContext context, AsyncSnapshot<List<Question>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                return _currentIndex < snapshot.data!.length
                    ? QuizzingPage(
                        answerQuestion: _answerQuestion,
                        currentIndex: _currentIndex,
                        questions: snapshot.data,
                      )
                    : ResultPage(
                        finalScore: _totalScore,
                        resetQuiz: _resetQuiz,
                      );
              }
              return const Center(child: Text('question not found'));
            }
          }),
    );
  }


  Future<List<Question>> _downloadQuestions(List<String> questions) async {
    List<Question> actualQuestions = [];
    for (var element in questions) {
      DatabaseEvent event =
          await FirebaseDatabase.instance.ref('questions/$element').once();
      var data = event.snapshot.value as Map<dynamic, dynamic>;

      Question question = Question(data['id'], data['grade'], data['subject'],
          data['text'], data['answers']);
      actualQuestions.add(question);
    }

    return actualQuestions;
  }
}
