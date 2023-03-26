import 'package:flutter/material.dart';
import 'package:forbidden_lands/screens/dm_zone_screen.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../screens/dice_roller_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: 140,
            child: DrawerHeader(
              child: Text(
                'Options',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.brown,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.waving_hand),
            title: Text('Dice'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => DiceRollerScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.castle),
            title: Text('DM Zone'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => DmZoneScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('My characters'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              Provider.of<Auth>(context, listen: false).logout();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
