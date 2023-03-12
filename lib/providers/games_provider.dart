import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../models/game.dart';
import '../providers/auth.dart';

class GamesProvider extends ChangeNotifier {
  Future<String> getUserId(BuildContext context) async {
    return await Provider.of<Auth>(context, listen: true).userId;
  }

  Future<String> getToken(BuildContext context) async {
    return await Provider.of<Auth>(context, listen: true).token;
  }

  List<Game> _games = [];

  //We are returning copy of games array so it can be manipulated with only within this provider
  List<Game> get games => [..._games];

  Future<List<Game>> fetchGames(Auth auth) async {
    final authToken = auth.token;
    final userId = auth.userId;
    final url = Uri.parse(
        'https://forbidden-lands-9083c-default-rtdb.europe-west1.firebasedatabase.app/games.json?orderBy="dungeon_master"&equalTo="$userId"&auth=$authToken');
    print("userId");
    print(userId);
    final response = await http.get(url);
    print(response.body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> gamesData = json.decode(response.body);
      final List<Game> loadedGames = [];

      gamesData.forEach((gameId, gameData) {
        loadedGames.add(Game(
          name: gameData['game'],
          password: gameData['password'],
        ));
      });

      _games = loadedGames;
      notifyListeners();

      return _games;
    } else {
      // handle error
      print('Failed to fetch games: ${response.statusCode}');
      return [];
    }
  }

  void addNewGame(String name, Auth auth) async {
    String password = _generatePassword();
    Game newGame = Game(name: name, password: password);
    _games.add(newGame);
    notifyListeners();
    final userId = auth.userId;
    final authToken = auth.token;
    final url = Uri.parse(
        'https://forbidden-lands-9083c-default-rtdb.europe-west1.firebasedatabase.app/games.json?auth=$authToken');
    final response = await http.post(
      url,
      body: json.encode({'game': name, 'password': password, 'dungeon_master': userId}),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      // handle error
      print('Error creating game: ${response.statusCode}');
    }
  }

  String _generatePassword() {
    const String validChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    Random random = Random();
    String password = "";
    for (int i = 0; i < 5; i++) {
      int index = random.nextInt(validChars.length);
      password += validChars[index];
    }
    return password;
  }
}
