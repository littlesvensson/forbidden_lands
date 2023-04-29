import 'package:flutter/material.dart';
import 'package:forbidden_lands/screens/game_detail_screen.dart';
import 'package:provider/provider.dart';

import '../models/game.dart';
import '../providers/games_provider.dart';
import '../screens/add_to_game_screen.dart';

class UserGamesList extends StatelessWidget {
  const UserGamesList({
    Key key,
    @required this.gamesProvider,
  }) : super(key: key);

  final GamesProvider gamesProvider;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<GamesProvider>(
        builder: (context, gamesProvider, child) {
          List<Game> userGames = gamesProvider.games;
          return ListView.builder(
            itemCount: userGames.length,
            itemBuilder: (BuildContext context, int index) {
              Game game = userGames[index];
              return GestureDetector(
                onTap: () {
                  print(game.id);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => GameDetailScreen(game.id, game.name),
                  ));
                },
                child: ListTile(
                  title: Text(game.name),
                  subtitle: Text("Password: ${game.password}"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
