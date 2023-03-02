import 'package:flutter/material.dart';

import '../screens/dm_zone_screen.dart';
import 'package:forbidden_lands/screens/dice_roller_screen.dart';

class BottomTabs extends StatefulWidget {
  BottomTabs();

  @override
  _BottomTabsState createState() => _BottomTabsState();
}

class _BottomTabsState extends State<BottomTabs> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.white,
      selectedItemColor: Colors.white,
      currentIndex: _selectedPageIndex,
      onTap: (index) {
        if (index == 0) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => DmZoneScreen()),
          );
        } else if (index == 1) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => DiceRollerScreen()),
          );
        }
      },
      items: [
        BottomNavigationBarItem(
          backgroundColor: Theme.of(context).primaryColor,
          icon: Icon(Icons.category),
          label: 'DM Zone',
        ),
        BottomNavigationBarItem(
          backgroundColor: Theme.of(context).primaryColor,
          icon: Icon(Icons.star),
          label: 'Dice',
        ),
      ],
    );
  }
}
