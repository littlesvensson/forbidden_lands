import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/games_provider.dart';

class GameDetailScreen extends StatefulWidget {
  final String gameId;
  final String gameName;

  GameDetailScreen(this.gameId, this.gameName);

  Future<void> _fetchGamePlayers(BuildContext context) async {
    try {
      final playersIds = await Provider.of<GamesProvider>(context, listen: false).fetchGamePlayers(gameId);
      print('PLAYER IDs');
      print(playersIds);
    } catch (error) {
      // handle error
      print(error);
    }
  }

  @override
  State<GameDetailScreen> createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends State<GameDetailScreen> {
  final List players = [];

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await widget._fetchGamePlayers(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gameName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Players",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: players.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      players[index],
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
