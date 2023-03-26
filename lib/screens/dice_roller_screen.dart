import 'dart:math';

import 'package:flutter/material.dart';

class DiceRollerScreen extends StatefulWidget {
  const DiceRollerScreen({Key key}) : super(key: key);

  static const routeName = '/dice-roller';

  @override
  _DiceRollerScreenState createState() => _DiceRollerScreenState();
}

class _DiceRollerScreenState extends State<DiceRollerScreen> {
  int _numDice = 1;
  int _numSides = 6;
  List<int> _results = [];

  List<int> _diceSides = List.generate(12, (index) => 6);
  List<TextEditingController> _controllers = [];

  void _throwDice() {
    List<int> results = [];
    for (int i = 0; i < _numDice; i++) {
      results.add(Random().nextInt(_diceSides[i]) + 1);
    }
    setState(() {
      _results = results;
    });
  }

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      _diceSides.length,
      (index) => TextEditingController(text: _diceSides[index].toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dice Roller'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Number of Dice: '),
                  DropdownButton<int>(
                    value: _numDice,
                    items: List.generate(
                      12,
                      (index) => index + 1,
                    ).map((num) {
                      return DropdownMenuItem<int>(
                        value: num,
                        child: Text(num.toString()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _numDice = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _numDice,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Dice ${index + 1} sides: '),
                      SizedBox(
                        width: 60,
                        child: TextFormField(
                          controller: _controllers[index],
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              _diceSides[index] = int.tryParse(value) ?? 6;
                            });
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _throwDice,
                child: Text('Throw Dice'),
              ),
              SizedBox(height: 16.0),
              if (_results.isNotEmpty) Text('Results: ${_results.join(', ')}'),
            ],
          ),
        ),
      ),
    );
  }
}
