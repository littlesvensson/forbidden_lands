import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import './quiz.dart';
import './result.dart';

void main() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  static const _questions = const [
    {
      'questionText': 'Ako sa mas?',
      'answers': [
        {'text': 'super', 'score': 0},
        {'text': 'dobre', 'score': 2},
        {'text': 'hrozne', 'score': 3}
      ]
    },
    {
      'questionText': 'Ake mas topanky?',
      'answers': [
        {'text': 'pekne', 'score': 1},
        {'text': '38', 'score': 2},
        {'text': 'skarede', 'score': 3}
      ],
    },
  ];

  int _questionIndex = 0;
  var _totalScore = 0;

  void _resetQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
    });
  }

  void _answerQuestion(int score) {
    _totalScore += score;
    setState(() {
      _questionIndex = _questionIndex + 1;
    });
    print(_questionIndex);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Moja prva Flutter appka'),
        ),
        body: _questionIndex < _questions.length
            ? Quiz(answerQuestion: _answerQuestion, questions: _questions, questionIndex: _questionIndex)
            : Result(_totalScore, _resetQuiz),
      ),
    );
  }
}
