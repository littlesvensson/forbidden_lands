import 'package:flutter/material.dart';

class CharacterListItem extends StatelessWidget {
  final Map<String, dynamic> character;
  //final Function onDelete;

  CharacterListItem(this.character);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      //onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      child: ListTile(
        title: Text(
          character['name'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.0),
            Text(
              'Age: ${character['age']}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 4.0),
            Text(
              'Kin: ${character['kin']}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 4.0),
            Text(
              'Profession: ${character['profession']}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }
}
