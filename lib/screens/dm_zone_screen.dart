import 'package:flutter/material.dart';
import 'package:forbidden_lands/providers/dungeon_master_provider.dart';
import 'package:provider/provider.dart';

import '../models/game.dart';
import '../providers/auth_provider.dart';
import '../providers/games_provider.dart';
import '../widgets/user_games_list.dart';

class DmZoneScreen extends StatefulWidget {
  const DmZoneScreen({Key key}) : super(key: key);

  static const routeName = '/dm_zone';

  Future<void> _fetchUserGames(BuildContext context, Auth auth) async {
    try {
      await Provider.of<GamesProvider>(context, listen: false).fetchGames(auth);
    } catch (error) {
      // handle error
      print(error);
    }
  }

  @override
  _DmZoneScreenState createState() => _DmZoneScreenState();
}

class _DmZoneScreenState extends State<DmZoneScreen> {
  TextEditingController _gameNameController = TextEditingController();

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await widget._fetchUserGames(context, Provider.of<Auth>(context, listen: false));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DM Zone"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<DungeonMasterProvider>(
              builder: (context, provider, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Use the nickname from the provider
                    Text(
                      "Nickname: ${provider.nickname}",
                      style: const TextStyle(fontSize: 20),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Update Nickname"),
                            content: TextField(
                              onChanged: (value) {
                                provider.updateNickname(value);
                              },
                              decoration: const InputDecoration(
                                hintText: "Enter new nickname",
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Save"),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createNewGame,
              child: const Text("Create New Game"),
            ),
            const SizedBox(height: 20),
            UserGamesList(gamesProvider: Provider.of<GamesProvider>(context, listen: false)),
          ],
        ),
      ),
    );
  }

// Add a new game using the GameProvider
  void _createNewGame() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Create New Game"),
        content: TextField(
          controller: _gameNameController,
          decoration: const InputDecoration(
            hintText: "Enter game name",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              String gameName = _gameNameController.text.trim();
              if (gameName.isNotEmpty) {
                Auth authProvider = Provider.of<Auth>(context, listen: false);
                Provider.of<GamesProvider>(context, listen: false)
                    .addNewGame(gameName, authProvider); // Add the game using the provider
              }
              _gameNameController.clear();
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
