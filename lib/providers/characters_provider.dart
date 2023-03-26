import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/character.dart';

class CharactersProvider with ChangeNotifier {
  List<Map<String, dynamic>> _items = [];

  final auth;

  CharactersProvider(this.auth);

  Future<void> fetchAndLoadCharacters() async {
    final userId = this.auth.userId;
    final authToken = this.auth.token;
    final url =
        'https://forbidden-lands-9083c-default-rtdb.europe-west1.firebasedatabase.app/users/$userId/characters.json?auth=$authToken';
    final response = await http.get(Uri.parse(url));
    final charactersJson = json.decode(response.body) as Map<String, dynamic>;
    final charactersList = charactersJson.entries
        .map((char) => {
              'id': char.key,
              'name': char.value['name'],
              'age': int.parse(char.value['age']),
              'kin': Kin.values.firstWhere((e) => e.toString().split('.')[1] == char.value['kin']),
              'profession': char.value['profession'],
            })
        .toList();
    _items = charactersList;
    notifyListeners();
  }

  Future<void> addCharacter(newCharacter) async {
    final userId = this.auth.userId;
    final authToken = this.auth.token;
    final url = Uri.parse(
        'https://forbidden-lands-9083c-default-rtdb.europe-west1.firebasedatabase.app/users/$userId/characters.json?auth=$authToken');
    final response = await http.post(url,
        body: json.encode({
          'name': newCharacter.name.toString(),
          'age': newCharacter.age,
          'kin': newCharacter.kin.toString().split('.')[1],
          'profession': newCharacter.profession
        }));
    print('response');
    print(response);
    final responseData = json.decode(response.body);
    final characterData = {
      'id': responseData['name'],
      'name': newCharacter.name,
      'age': newCharacter.age,
      'kin': newCharacter.kin.toString().split('.')[1],
      'profession': newCharacter.profession,
    };
    _items.add(characterData);
    notifyListeners();
  }

  Future<void> updateCharacter(charId, editedCharacter) async {
    final userId = this.auth.userId;
    final authToken = this.auth.token;

    final characterIndex = _items.indexWhere((char) => char['id'] == charId);

    if (characterIndex >= 0) {
      final url = Uri.parse(
          'https://forbidden-lands-9083c-default-rtdb.europe-west1.firebasedatabase.app/users/$userId/characters/$charId.json?auth=$authToken');
      final response = await http.patch(url,
          body: json.encode({
            'name': editedCharacter.name,
            'age': editedCharacter.age.toString(),
            'kin': editedCharacter.kin.toString().split('.')[1],
            'profession': editedCharacter.profession
          }));

      final editedCharacterMap = {
        'id': editedCharacter.id,
        'name': editedCharacter.name,
        'age': editedCharacter.age,
        'kin': editedCharacter.kin.toString().split('.')[1],
        'profession': editedCharacter.profession,
      };
      _items[characterIndex] = editedCharacterMap;
      notifyListeners();
    }
  }

  Future<void> deleteCharacter(String characterId) async {
    final userId = this.auth.userId;
    final authToken = this.auth.token;
    final url = Uri.parse(
        'https://forbidden-lands-9083c-default-rtdb.europe-west1.firebasedatabase.app/users/$userId/characters/$characterId.json?auth=$authToken');
    final response = await http.delete(url);
    _items.removeWhere((char) => char['id'] == characterId);
    notifyListeners();
  }

  List<Map<String, dynamic>> get items {
    return [..._items];
  }

  Character findById(String id) {
    final characterMap = _items.firstWhere((character) => character['id'] == id);
    return Character(
      id: characterMap['id'],
      name: characterMap['name'],
      age: characterMap['age'],
      kin: characterMap['kin'],
      profession: characterMap['profession'],
    );
  }
}
