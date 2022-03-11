import 'package:educationgo/MyFirebaseServices.dart';
import 'package:educationgo/models/Subject.dart';
import 'package:educationgo/screens/Quizzes.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String gradeValue = 'Grade 11';
  int subjectsCount = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  _buildAppBar() {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Icon(Icons.account_circle),
              SizedBox(
                width: 4.0,
              ),
              Text('Hi, Saado'),
            ],
          ),
          DropdownButton<String>(
            value: gradeValue,
            hint: const Text('Choose grade'),
            items: <String>['Grade 10', 'Grade 11', 'Grade 12']
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              updateSubjects(value);
            },
          )
        ],
      ),
    );
  }

  _buildBody() {
    return FutureBuilder<List<Subject>>(
        future: MyFirebaseServices().downloadSubjects(gradeValue),
        builder: (BuildContext context, AsyncSnapshot<List<Subject>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (snapshot.data != null && snapshot.data!.isNotEmpty) {
              return _buildSubjectsGrid(snapshot.data);
            }
            return const Center(child: Text('No subjects for this grade yet!'));
          }
        });
  }

  void updateSubjects(String? value) {
    setState(() {
      gradeValue = value.toString();
    });
  }

  _buildSubjectsGrid(List<Subject>? subjects) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: subjects!.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _moveToQuizzes(subjects[index]),
            child: Card(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                        width: 80.0,
                        image: NetworkImage(subjects[index].iconUrl)),
                    Text(subjects[index].name.toString())
                  ]),
            ),
          );
        },
      ),
    );
  }

  _moveToQuizzes(Subject subject) {
    String id = subject.name + '_' + gradeValue;
    print(id);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Quizzes(queryId: id)),
    );
  }
}
