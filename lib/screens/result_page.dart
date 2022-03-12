import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final int finalScore;
  final Function() resetQuiz;

  const ResultPage(
      {Key? key, required this.finalScore, required this.resetQuiz})
      : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'resultPhrase',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ), //Text
          Text(
            'Score ' '$finalScore',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ), //Text
          FlatButton(
            child: Text(
              'Restart Quiz!',
            ), //Text
            textColor: Colors.blue,
            onPressed: resetQuiz,
          ), //FlatButton
        ], //<Widget>[]
      ), //Column
    ); //Center
  }
}
