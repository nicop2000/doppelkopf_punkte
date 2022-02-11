import 'dart:async';
import 'package:doppelkopf_punkte/doko/app_overlay.dart';
import 'package:doppelkopf_punkte/helper/enviroment_variables.dart';
import 'package:flutter/material.dart';
import 'package:doppelkopf_punkte/helper/helper.dart';
import 'package:doppelkopf_punkte/helper/persistent_data.dart';

import 'package:doppelkopf_punkte/model/user.dart';

import 'package:doppelkopf_punkte/usersPage/login.dart';
import 'package:doppelkopf_punkte/usersPage/register.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'model/game.dart';
import 'model/runde.dart';
/// Diese App ist der Anwesenheitsmelder für Studenten der FH-Kiel.

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  EnviromentVariables.prefs = await SharedPreferences.getInstance();
  // if (Helpers.timer.isActive) Helpers.timer.cancel(); //TODO LOGIK



  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => Game()),
            ChangeNotifierProvider(create: (_) => AppUser()),
            ChangeNotifierProvider(create: (_) => PersistentData()),
            ChangeNotifierProvider(create: (_) => Runde()),
          ],
      child: const DokoPunkte())
  );
}

class DokoPunkte extends StatefulWidget {
  const DokoPunkte({Key? key}) : super(key: key);

  @override
  State<DokoPunkte> createState() => _DokoPunkteState();
}

class _DokoPunkteState extends State<DokoPunkte> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          background: context.watch<PersistentData>().getBackground(),
          onBackground: context.watch<PersistentData>().getOnBackground(),
          primary: context.watch<PersistentData>().getPrimaryColor(),
          primaryVariant: Colors.teal,
          onPrimary: context.watch<PersistentData>().getOnPrimary(),
          secondary: context.watch<PersistentData>().getActive(),
          secondaryVariant: Colors.red,
          onSecondary: Colors.red,
          error: Colors.red,
          onError: Colors.deepPurpleAccent,
          surface: Colors.teal,
          onSurface: Colors.teal,
        ),
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const AppOverlay(),
        "${routers.login}": (context) => const Login(),
        "${routers.register}": (context) => const Register(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

