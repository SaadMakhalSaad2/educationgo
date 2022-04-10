import 'package:educationgo/models/answer_report.dart';
import 'package:educationgo/my_firebase_services.dart';
import 'package:educationgo/screens/home_page.dart';
import 'package:educationgo/screens/quizzing_page.dart';
import 'package:educationgo/screens/result_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/question.dart';
import '../models/quiz.dart';
import '../widgets/question_navigation.dart';

class ExamRoom extends StatefulWidget {
  final Quiz quiz;
  const ExamRoom({Key? key, required this.quiz}) : super(key: key);

  @override
  State<ExamRoom> createState() => _ExamRoomState();
}

class _ExamRoomState extends State<ExamRoom> {
  var userId = FirebaseAuth.instance.currentUser!.uid;
  List<Question>? questions = [];

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
    var questionId = widget.quiz.questions[_currentIndex];
    var reportId = '${questionId}_$userId';
    AnswerReport report = AnswerReport(questionId, userId, score);
    MyFirebaseServices()
        .writeData(report.toJson(), 'answer_reports/$reportId')
        .then((value) {
      print('report written');
      setState(() {
        _currentIndex = _currentIndex + 1;
      });
    });
  }

  void _moveNext() {
    if (_currentIndex < questions!.length) {
      setState(() {
        _currentIndex = _currentIndex + 1;
      });
    }
  }

  void _movePrevious() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex = _currentIndex - 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _showMyDialog();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.quiz.title),
          automaticallyImplyLeading: true,
        ),
        body: Column(
          children: [
            FutureBuilder(
                future: MyFirebaseServices()
                    .downloadQuestions(widget.quiz.questions),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Question>> snapshot) {
                  questions = snapshot.data;
                  return _result(snapshot);
                }),
            QuestionNavigation(
              moveNext: _moveNext,
              movePrevious: _movePrevious,
            )
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    print('show dialog');
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text('Are you sure you want to leave quiz?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text('YES'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('NO'),
            ),
          ],
        );
      },
    );
  }

  Widget _result(AsyncSnapshot<List<Question>> snapshot) {
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
  }
}
