import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/characters_provider.dart';

class AddToGameScreen extends StatefulWidget {
  static const routeName = '/add-to-game';

  final String characterId;

  AddToGameScreen({@required this.characterId});

  @override
  _AddToGameScreenState createState() => _AddToGameScreenState();
}

class _AddToGameScreenState extends State<AddToGameScreen> {
  final _formKey = GlobalKey<FormState>();

  String _gameName;
  String _password;

  void _saveForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      // Call addCharacterToGame function from CharactersProvider provider
      final charactersProvider = Provider.of<CharactersProvider>(context, listen: false);
      charactersProvider.addCharacterToGame(widget.characterId, _gameName, _password);

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add to Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Game Name'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a game name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _gameName = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _saveForm,
                child: Text('Add to Game'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
