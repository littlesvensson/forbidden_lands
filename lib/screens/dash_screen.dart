import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DashScreen extends StatefulWidget {
  static const routeName = '/dashboard';

  @override
  _DashScreenState createState() => _DashScreenState();
}

class _DashScreenState extends State<DashScreen> {
  List<String> _characters = [];

  Future<void> _fetchCharacters() async {
    final url =
        Uri.parse('https://forbidden-lands-9083c-default-rtdb.europe-west1.firebasedatabase.app/characters.json');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      data.forEach((key, value) {
        _characters.add(value['name']);
      });
      setState(() {});
    } else {
      print('Failed to fetch data: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCharacters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Characters'),
      ),
      body: _characters.isNotEmpty
          ? ListView.builder(
              itemCount: _characters.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_characters[index]),
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement create new character functionality.
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
