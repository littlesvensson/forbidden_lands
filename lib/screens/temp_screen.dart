import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

class TempScreen extends StatefulWidget {
  static const routeName = '/temp';

  @override
  _TempScreenState createState() => _TempScreenState();
}

String projectKey = dotenv.env['PROJECT_KEY'];

class _TempScreenState extends State<TempScreen> {
  bool _isPosting = false;

  Future<void> _postData() async {
    setState(() {
      _isPosting = true;
    });
    final url =
        Uri.parse('https://forbidden-lands-9083c-default-rtdb.europe-west1.firebasedatabase.app/characters.json');
    final response = await http.post(url,
        body: json.encode(
          //{"name": "Kalevatar", "kin": "elf", "age": 87, "profession": "fighter"},
          //{"name": "Ilmarinen", "kin": "dwarf", "age": 42, "profession": "druid"},
          //{"name": "Kullervo", "kin": "halfling", "age": 23, "profession": "peddler"},
          //{"name": "Ahti", "kin": "elf", "age": 61, "profession": "hunter"},
          //{"name": "Väinämöinen", "kin": "dwarf", "age": 76, "profession": "minstrel"},
          {"name": "Louhi", "kin": "halfling", "age": 36, "profession": "sorcerer"},
          // {"name": "Tiera", "kin": "elf", "age": 51, "profession": "rider"},
          // {"name": "Untamo", "kin": "dwarf", "age": 19, "profession": "peddler"},
          // {"name": "Kipu-Tyttö", "kin": "halfling", "age": 44, "profession": "druid"},
          // {"name": "Mielikki", "kin": "elf", "age": 98, "profession": "hunter"}
        ));
    if (response.statusCode == 200) {
      print('Data posted successfully!');
    } else {
      print('Failed to post data: ${response.statusCode}');
    }

    setState(() {
      _isPosting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _isPosting ? null : _postData,
          child: _isPosting ? const CircularProgressIndicator() : const Text('Send Data'),
        ),
      ),
    );
  }
}
