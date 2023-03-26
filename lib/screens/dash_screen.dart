import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/characters_provider.dart';
import '../widgets/characters_list.dart';
import '../widgets/main_drawer.dart';
import '../widgets/bottom_tabs.dart';

class DashScreen extends StatefulWidget {
  static const routeName = '/dashboard';

  final String authToken;
  final String userId;

  DashScreen(this.authToken, this.userId);

  @override
  _DashScreenState createState() => _DashScreenState(authToken, userId);
}

class _DashScreenState extends State<DashScreen> {
  final String authToken;
  final String userId;

  _DashScreenState(this.authToken, this.userId);

  @override
  void initState() {
    super.initState();
    Provider.of<CharactersProvider>(context, listen: false).fetchAndLoadCharacters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Characters'),
      ),
      drawer: MainDrawer(),
      body: Consumer<CharactersProvider>(
        builder: (ctx, charactersProvider, child) {
          final _characters = charactersProvider.items;
          return _characters.isNotEmpty
              ? CharactersList(_characters)
              : Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/edit-character');
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomTabs(),
    );
  }
}
