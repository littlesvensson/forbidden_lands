import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/character.dart';
import '../providers/characters_provider.dart';

class EditCharacterScreen extends StatefulWidget {
  static const routeName = '/edit-character';

  // final String authToken;
  // final String userId;

  EditCharacterScreen();

  @override
  _EditCharacterScreenState createState() => _EditCharacterScreenState();
}

class _EditCharacterScreenState extends State<EditCharacterScreen> {
  final _formKey = GlobalKey<FormState>();

  String _name;
  String _age;
  String _kin;
  String _profession;
  Kin _selectedKin;

  var _editedCharacter = Character(
    id: null,
    name: '',
    age: 0,
    kin: null,
    profession: '',
  );
  var _initValues = {
    'name': '',
    'age': '',
    'kin': '',
    'profession': '',
  };
  var _isInit = true;

  _EditCharacterScreenState();

  Future<void> _saveForm() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (_editedCharacter.id != null) {
        print('ISNOTNULL');
        var editedCharacter = Character(
            id: _editedCharacter.id,
            name: _name,
            age: int.parse(_age),
            kin: Kin.values.firstWhere((e) => e.toString().split('.').last == _kin),
            profession: _profession);

        print('name');
        print(editedCharacter.name);
        print(editedCharacter.kin);
        await Provider.of<CharactersProvider>(context, listen: false)
            .updateCharacter(editedCharacter.id, editedCharacter);
      } else {
        print('NULL');
        // try {
        var newCharacter = Character(
            name: _name,
            age: int.parse(_age),
            kin: Kin.values.firstWhere((e) => e.toString().split('.').last == _kin),
            profession: _profession);
        await Provider.of<CharactersProvider>(context, listen: false).addCharacter(newCharacter);
        // } catch (error) {
        //   print(error);
        // }
      }
      Navigator.of(context).pop();
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final characterId = ModalRoute.of(context).settings.arguments as String;
      if (characterId != null) {
        _editedCharacter = Provider.of<CharactersProvider>(context, listen: false).findById(characterId);

        _initValues = {
          'name': _editedCharacter.name,
          'age': _editedCharacter.age.toString(),
          'kin': _editedCharacter.kin.toString(),
          'profession': _editedCharacter.profession,
        };
        _selectedKin = _editedCharacter.kin;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _editedCharacter.id == null ? Text('Add Character') : Text('Edit Character'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _initValues['name'],
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
                initialValue: _initValues['age'],
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
                initialValue: _initValues['profession'],
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
                child: _editedCharacter.id == null ? Text('Add Character') : Text('Edit Character'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
