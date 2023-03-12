import 'package:flutter/material.dart';

class DungeonMasterProvider with ChangeNotifier {
  String _nickname = "Hello";

  void updateNickname(String newNickname) {
    _nickname = newNickname;

    notifyListeners();
  }

  String get nickname {
    return _nickname;
  }
}
