import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'dart:convert';

import '../../lib/providers/characters_provider.dart';
import '../../lib/models/character.dart';
import '../../lib/providers/auth_provider.dart';

void main() {
  group('CharactersProvider', () {
    final charactersJson = {
      '1': {
        'name': 'Erik',
        'age': '25',
        'kin': 'Human',
        'profession': 'Farmer',
      },
      '2': {
        'name': 'Alrik',
        'age': '22',
        'kin': 'Dwarf',
        'profession': 'Blacksmith',
      }
    };

    final String testId = 'myUserId';
    final String testToken = 'myToken';

    final auth = Auth();
    auth.setUserId(testId);
    auth.setToken(testToken);

    test('fetchAndLoadCharacters should return a list of characters', () async {
      final charactersProvider = CharactersProvider(auth);

      final mockClient = MockClient((request) async {
        final jsonBody = json.encode(charactersJson);
        return http.Response(jsonBody, 200);
      });

      charactersProvider.fetchAndLoadCharacters();

      final characters = charactersProvider.items;

      expect(characters, isNotEmpty);
      expect(characters.length, equals(2));
      expect(characters[0], isA<Map<String, dynamic>>());
      expect(characters[1], isA<Map<String, dynamic>>());
      expect(characters[0]['id'], equals('1'));
      expect(characters[0]['name'], equals('Erik'));
      expect(characters[0]['age'], equals(25));
      expect(characters[0]['kin'], equals(Kin.human));
      expect(characters[0]['profession'], equals('Farmer'));
      expect(characters[1]['id'], equals('2'));
      expect(characters[1]['name'], equals('Alrik'));
      expect(characters[1]['age'], equals(22));
      expect(characters[1]['kin'], equals(Kin.dwarf));
      expect(characters[1]['profession'], equals('Blacksmith'));
    });

    test('addCharacter should add a new character', () async {
      final charactersProvider = CharactersProvider(auth);

      final mockClient = MockClient((request) async {
        final jsonBody = json.encode({'name': 'Siri', 'age': 19, 'kin': 'Elf', 'profession': 'Thief'});
        return http.Response(jsonBody, 200);
      });

      charactersProvider.addCharacter(
        Character(
          id: '3',
          name: 'Siri',
          age: 19,
          kin: Kin.elf,
          profession: 'Thief',
        ),
      );

      final characters = charactersProvider.items;

      expect(characters, isNotEmpty);
      expect(characters.length, equals(1));
      expect(characters[0], isA<Map<String, dynamic>>());
      expect(characters[0]['id'], equals('3'));
      expect(characters[0]['name'], equals('Siri'));
      expect(characters[0]['age'], equals(19));
      expect(characters[0]['kin'], equals(Kin.elf));
      expect(characters[0]['profession'], equals('Thief'));
    });

    test('updateCharacter should update an existing character', () async {
      final charactersProvider = CharactersProvider(auth);

      charactersProvider.addCharacter(
        Character(
          id: '1',
          name: 'Erik',
          age: 25,
          kin: Kin.human,
          profession: 'Farmer',
        ),
      );

      final mockClient = MockClient((request) async {
        return http.Response('', 204);
      });

      charactersProvider.removeCharacter('1');

      final characters = charactersProvider.items;

      expect(characters, isEmpty);
    });
  });
}
