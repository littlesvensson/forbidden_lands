import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:firebase_core/firebase_core.dart';
import 'package:forbidden_lands/screens/dash_screen.dart';
import 'package:forbidden_lands/screens/edit_character_screen.dart';
import 'package:forbidden_lands/screens/temp_screen.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

import './screens/auth_screen.dart';
import './providers/auth.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized(); // added line
  await DotEnv.load(fileName: '.env');
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Error initializing Firebase: $e');
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
              home: auth.isAuth ? DashScreen(auth.token, auth.userId) : AuthScreen(),
              routes: {
                TempScreen.routeName: ((ctx) => TempScreen()),
                DashScreen.routeName: ((ctx) => DashScreen(auth.token, auth.userId)),
                EditCharacterScreen.routeName: ((ctx) => EditCharacterScreen(auth.token, auth.userId)),
              }),
        ));
  }
}
