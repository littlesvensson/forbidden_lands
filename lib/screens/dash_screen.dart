import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  List<Map<String, dynamic>> _characters = [];

  final String authToken;
  final String userId;

  _DashScreenState(this.authToken, this.userId);

  Future<void> _fetchCharacters() async {
    print('authToken: ');
    print(authToken);
    final url = Uri.parse(
        'https://forbidden-lands-9083c-default-rtdb.europe-west1.firebasedatabase.app/$userId/characters.json?auth=$authToken');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      data.forEach((key, value) {
        _characters
            .add({'name': value['name'], 'age': value['age'], 'kin': value['kin'], 'profession': value['profession']});
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
      drawer: MainDrawer(),
      body: _characters.isNotEmpty
          ? CharactersList(_characters)
          : Center(
              child: CircularProgressIndicator(),
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
