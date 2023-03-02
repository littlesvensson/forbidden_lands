import 'package:flutter/material.dart';

import 'characters_list_item.dart';

class CharactersList extends StatelessWidget {
  final List<Map<String, dynamic>> characters;

  CharactersList(this.characters);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: characters.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Card(
            elevation: 4.0,
            child: CharacterListItem(characters[index]),
          ),
        );
      },
    );
  }
}
