import 'package:flutter/material.dart';

enum Kin {
  human,
  dwarf,
  elf,
  halfling,
}

class Character {
  final String id;
  final String name;
  final int age;
  final Kin kin;
  final String profession;

  Character({
    this.id,
    @required this.name,
    @required this.age,
    @required this.kin,
    @required this.profession,
  });
}
