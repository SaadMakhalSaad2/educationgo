import 'package:educationgo/models/question.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'models/quiz.dart';
import 'models/subject.dart';

class MyFirebaseServices {
  Future<void> logout() async {
    print('Logout');
    await FacebookAuth.instance.logOut();
    await FirebaseAuth.instance.signOut();
  }

  Future<void> writeData(dynamic data, String key) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(key);
    await ref.set(data).then((value) => {print('data written')});
  }

  Future<UserCredential> signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login(
      permissions: [
        'email',
        'public_profile',
        'user_friends',
      ],
    );
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  Future<List<Subject>> downloadSubjects(String gradeValue) async {
    List<Subject> subjects = [];
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("grades/$gradeValue/subjects");
    DatabaseEvent event = await ref.once();

    var map = event.snapshot.value as List<dynamic>;

    if (map != null) {
      print('stuff ${map.length}');

      map.forEach((element) {
        Subject s = Subject(element['title'], element['iconUrl']);
        subjects.add(s);
      });
      print('final subjects:: ${subjects.length}');
    }

    return subjects;
  }

  Future<List<Quiz>> downloadQuizzes(String queryId) async {
    List<Quiz> quizzes = [];
    DatabaseReference ref = FirebaseDatabase.instance.ref("quizzes/");
    DatabaseEvent event =
        await ref.orderByChild('queryId').equalTo(queryId).once();
    print('found quizzes: ${event.snapshot.value}');

    var quizzesJson = [];
    var map = event.snapshot.value as Map<dynamic, dynamic>;

    map.forEach((key, value) {
      quizzesJson.add(value);
    });

    for (var quizJson in quizzesJson) {
      List<dynamic> questionsJson = [];
      List<String> finalQuestions = [];

      if (quizJson['questions'] != null) {
        questionsJson = quizJson['questions'] as List<dynamic>;
        for (var questionString in questionsJson) {
          finalQuestions.add(questionString);
        }
      }

      Quiz q = Quiz(quizJson['id'], quizJson['title'], quizJson['queryId'],
          finalQuestions);
      quizzes.add(q);
    }
    return quizzes;
  }

  
    Future<List<Question>> downloadQuestions(List<String> questions) async {
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
