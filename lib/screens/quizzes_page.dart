import 'package:educationgo/my_firebase_services.dart';
import 'package:educationgo/models/quiz.dart';
import 'package:educationgo/screens/exam_room.dart';
import 'package:flutter/material.dart';

class Quizzes extends StatelessWidget {
  final String queryId;
  const Quizzes({Key? key, required this.queryId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(queryId)),
      body: FutureBuilder<List<Quiz>>(
          future: MyFirebaseServices().downloadQuizzes(queryId),
          builder: (BuildContext contex, AsyncSnapshot<List<Quiz>> snapshot) {
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
                      return _buildQuiz(snapshot.data![index], index, contex);
                    });
              }
              return const Center(child: Text('No quizzes for this query!'));
            }
          }),
    );
  }

  Widget _buildQuiz(Quiz quiz, int index, BuildContext context) {
    return GestureDetector(
      onTap: (() => _goToEamRoom(quiz, context)),
      child: Container(
        height: 40,
        width: 80,
        margin: const EdgeInsets.all(8),
        color: Colors.yellow,
        child: Text(quiz.title.toString()),
      ),
    );
  }

  _goToEamRoom(Quiz quiz, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ExamRoom(quiz: quiz)),
    );
  }
}
