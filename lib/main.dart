import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

import 'providers/auth_provider.dart';
import './providers/dungeon_master_provider.dart';
import './providers/games_provider.dart';
import './providers/characters_provider.dart';
import './screens/auth_screen.dart';
import 'screens/add_to_game_screen.dart';
import './screens/dash_screen.dart';
import './screens/dice_roller_screen.dart';
import './screens/edit_character_screen.dart';
import './screens/dm_zone_screen.dart';
import './screens/splash_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized(); // added line
  await DotEnv.load(fileName: '.env');

  if (Firebase.apps.isEmpty) {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e) {
      print('Error initializing Firebase: $e');
    }
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProvider.value(
            value: GamesProvider(Auth),
          ),
          ChangeNotifierProvider.value(
            value: DungeonMasterProvider(),
          ),
          ChangeNotifierProxyProvider<Auth, CharactersProvider>(
            create: (BuildContext context) => CharactersProvider(Provider.of<Auth>(context, listen: false)),
            update: (ctx, auth, previousCharacters) => CharactersProvider(auth),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
              title: 'Forbidden Lands',
              theme: ThemeData(
                primarySwatch: Colors.brown,
                colorScheme: ColorScheme.fromSwatch(
                  primarySwatch: Colors.brown,
                  accentColor: Colors.brown,
                ),
                textTheme: TextTheme(
                  headline1: TextStyle(fontFamily: 'Montserrat', fontSize: 24.0, fontWeight: FontWeight.bold),
                  headline2: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, fontWeight: FontWeight.bold),
                  bodyText1: TextStyle(fontFamily: 'Open Sans', fontSize: 16.0),
                  bodyText2: TextStyle(fontFamily: 'Open Sans', fontSize: 14.0),
                ),
              ),
              home: auth.isAuth
                  ? DashScreen(auth.token, auth.userId)
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (ctx, authResultSnapshot) =>
                          authResultSnapshot.connectionState == ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen()),
              routes: {
                DashScreen.routeName: ((ctx) => DashScreen(auth.token, auth.userId)),
                EditCharacterScreen.routeName: ((ctx) => EditCharacterScreen()),
                DmZoneScreen.routeName: (((ctx) => DmZoneScreen())),
                DiceRollerScreen.routeName: (((ctx) => DiceRollerScreen())),
                AddToGameScreen.routeName: (((ctx) => AddToGameScreen())),
              }),
        ));
  }
}
