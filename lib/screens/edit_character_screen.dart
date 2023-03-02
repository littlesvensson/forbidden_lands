import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum Kin {
  human,
  dwarf,
  elf,
  halfling,
}

class EditCharacterScreen extends StatefulWidget {
  static const routeName = '/edit-character';

  final String authToken;
  final String userId;

  EditCharacterScreen(this.authToken, this.userId);

  @override
  _EditCharacterScreenState createState() => _EditCharacterScreenState(authToken, userId);
}

class _EditCharacterScreenState extends State<EditCharacterScreen> {
  final _formKey = GlobalKey<FormState>();
  final String authToken;
  final String userId;

  String _name;
  String _age;
  String _kin;
  String _profession;
  Kin _selectedKin;

  _EditCharacterScreenState(this.authToken, this.userId);

  Future<void> _saveForm() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final url = Uri.parse(
          'https://forbidden-lands-9083c-default-rtdb.europe-west1.firebasedatabase.app/$userId/characters.json?auth=$authToken');
      final response = await http.post(url,
          body: json.encode({
            'name': _name,
            'age': _age,
            'kin': _kin,
            'profession': _profession,
          }));
      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.of(context).pop();
      } else {
        print('Failed to add character: ${response.statusCode}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Character'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter an age';
                  }
                  return null;
                },
                onSaved: (value) {
                  _age = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Profession'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a profession';
                  }
                  return null;
                },
                onSaved: (value) {
                  _profession = value;
                },
              ),
              DropdownButtonFormField<Kin>(
                value: _selectedKin,
                items: Kin.values.map((kin) {
                  return DropdownMenuItem<Kin>(
                    value: kin,
                    child: Text(kin.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedKin = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Kin',
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a kin';
                  }
                  return null;
                },
                onSaved: (value) {
                  _kin = value.toString().split('.').last;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _saveForm,
                child: Text('Add Character'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
