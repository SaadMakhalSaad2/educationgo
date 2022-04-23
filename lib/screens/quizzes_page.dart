import 'package:educationgo/my_firebase_services.dart';
import 'package:educationgo/models/quiz.dart';
import 'package:educationgo/resources/styles.dart';
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
            return _buildQuizzes(snapshot, context);
          }),
    );
  }

  Widget _buildQuiz(Quiz quiz, int index, BuildContext context) {
    return GestureDetector(
      onTap: (() => _goToEamRoom(quiz, context)),
      child: Card(
        child: Container(
          margin: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                quiz.title.toString(),
                style: TextStyles.quizTitle,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                quiz.queryId.length.toString() + ' questions',
                style: TextStyles.quizSubTitle,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuizzes(
      AsyncSnapshot<List<Quiz>> snapshot, BuildContext context) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    } else {
      if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      }
      if (snapshot.data != null && snapshot.data!.isNotEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return _buildQuiz(snapshot.data![index], index, context);
              }),
        );
      }
      return const Center(child: Text('No quizzes for this query!'));
    }
  }

  _goToEamRoom(Quiz quiz, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ExamRoom(quiz: quiz)),
    );
  }
}
