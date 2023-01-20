import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  void answerQuestion() {
    print('Answer chosen!');
  }
  @override
  Widget build(BuildContext context) {
    var questions = ['Ako sa mas?', 'Ake mas topanky?'];
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Moja prva Flutter appka'),
        ),
        body: Column(
          children: <Widget>[
            Text('Otazka!'),
            ElevatedButton(child: Text('Odpoved 1'), onPressed: null,),
            ElevatedButton(child: Text('Odpoved 2'), onPressed: null,),
            ElevatedButton(child: Text('Odpoved 3'), onPressed: null,),
          ],
        ),
      ),
    );
  }
}
