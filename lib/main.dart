import 'dart:async';
import 'package:doppelkopf_punkte/doko/game_add_entry.dart';
import 'package:doppelkopf_punkte/doko/game_list.dart';
import 'package:doppelkopf_punkte/doko/game_settings.dart';
import 'package:doppelkopf_punkte/doko/game_statistics.dart';
import 'package:doppelkopf_punkte/doko/saved_lists.dart';
import 'package:doppelkopf_punkte/helper/enviroment_variables.dart';
import 'package:doppelkopf_punkte/helper/helper.dart';
import 'package:doppelkopf_punkte/helper/persistent_data.dart';
import 'package:doppelkopf_punkte/scanner.dart';
import 'package:doppelkopf_punkte/usersPage/login.dart';
import 'package:doppelkopf_punkte/usersPage/register.dart';
import 'package:doppelkopf_punkte/usersPage/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helper/constants.dart';

/// Diese App ist der Anwesenheitsmelder für Studenten der FH-Kiel.

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Env.prefs = await SharedPreferences.getInstance();
  if (FirebaseAuth.instance.currentUser != null) Env.archivedLists = await Helpers.getMyList();
  Env.controller.add("ERRRROOOR");
  Env.canCheckBio = await Env.localAuth.canCheckBiometrics;
  Env.deviceSupported = await Env.localAuth.isDeviceSupported();
  if (FirebaseAuth.instance.currentUser != null) {
    Helpers.userLoggedIn(FirebaseAuth.instance.currentUser!);
  }

  runApp(const DokoPunkte());
}

class DokoPunkte extends StatelessWidget {
  const DokoPunkte({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          background: PersistentData.getBackground(),
          onBackground: PersistentData.getOnBackground(),
          primary: PersistentData.getPrimaryColor(),
          primaryVariant: Colors.red,
          onPrimary: PersistentData.getOnPrimary(),
          secondary: Colors.red,
          secondaryVariant: Colors.red,
          onSecondary: Colors.red,
          error: Colors.red,
          onError: Colors.deepPurpleAccent,
          surface: Colors.teal,
          onSurface: Colors.red,
        ),
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const AppOverlay(),
        "${routers.login}": (context) => const Login(),
        "${routers.register}": (context) => const Register(),
      },
      debugShowCheckedModeBanner: true,
    );
  }
}

/// Das AppOverlay Widget stellt die Titelleiste und die untere Navigationsleiste
/// dar. Die untere Navigationsleiste verwaltet zudem den angezeigten Content.
class AppOverlay extends StatefulWidget {
  const AppOverlay({Key? key}) : super(key: key);

  @override
  _AppOverlayState createState() => _AppOverlayState();
}

class _AppOverlayState extends State<AppOverlay> {
  int _index = 0;
  final Map<int, List<dynamic>> _content = {
    0: ["Spielliste", const GameList()],
    1: ["Spielstatistiken", const GameStatistics()],
    2: ["Listeneintrag hinzufügen", const GameAddEntry()],
    3: ["Gespeicherte Statistiken", const SavedLists()],
    4: ["Einstellungen", const GameSettings()],
  };

  @override
  Widget build(BuildContext context) {
    Env.playersAdd.listen((event) {
      print("EVENT: $event");
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            icon: Icon(
              Icons.account_circle_outlined,
              color: Theme.of(context).colorScheme.background,
            ),
            onPressed: () => _showAccountInfo(context),
          ),
        ],
        title: Text(
          _content[_index]![0],
          style: TextStyle(color: Theme.of(context).colorScheme.background),
        ),
      ),
      body: _content[_index]![1],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Theme.of(context).colorScheme.primary,
        ),
        child: BottomNavigationBar(
            key: Env.keyBottomNavBar,
            type: BottomNavigationBarType.shifting,
            selectedItemColor: PersistentData.getActive(),
            iconSize: 25,
            selectedIconTheme: const IconThemeData(
              size: 35,
            ),
            unselectedItemColor: Theme.of(context).colorScheme.background,
            onTap: (index) {
              print(index);
              _index = index;
              setState(() {
                print(index);
              });
            },
            currentIndex: _index,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            backgroundColor: Theme.of(context).colorScheme.primary,
            items: [
              _bottomNavigationElement(
                  title: _content[0]![0], icon: CupertinoIcons.list_bullet),
              _bottomNavigationElement(
                  title: _content[1]![0], icon: CupertinoIcons.chart_pie),
              _bottomNavigationElement(title: "Add", icon: CupertinoIcons.add),
              _bottomNavigationElement(
                  title: "Archiv", icon: CupertinoIcons.floppy_disk),
              _bottomNavigationElement(
                  title: _content[4]![0], icon: CupertinoIcons.settings),
            ]),
      ),
    );
  }

  /// Das _bottomNavigationElement stellt die Naviagtionselemente in der unteren
  /// Navigationsleiste dar.

  BottomNavigationBarItem _bottomNavigationElement(
      {required String title, required IconData icon}) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: title,
      tooltip: title,
    );
  }

  void _showSettings(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      isScrollControlled: true,
      context: context,
      builder: (BuildContext bc) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.85,
          child: Column(
            children: [
              Row(
                children: [
                  const Spacer(),
                  IconButton(
                    tooltip: "Schließen",
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      CupertinoIcons.clear_circled,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const Expanded(child: Settings()),
            ],
          ),
        );
      },
    );
  }

  void _showAccountInfo(BuildContext context) {
    Stream<User?> firebaseStream = FirebaseAuth.instance.authStateChanges();
    showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      isScrollControlled: true,
      context: context,
      builder: (BuildContext bc) {
        return StreamBuilder(
            stream: firebaseStream,
            builder: (BuildContext bc, AsyncSnapshot<User?> snapshot) {
              if (snapshot.hasData) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              tooltip: "Einstellungen",
                              color: Theme.of(context).colorScheme.primary,
                              onPressed: () async {
                                if (await Helpers.authenticate()) {
                                  _showSettings(context);
                                }
                              },
                              icon: Icon(
                                CupertinoIcons.settings_solid,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const Spacer(),
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    width: 1.0, color: Constants.mainGrey),
                              ),
                              label: Text(
                                "Logout",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              icon: Icon(
                                CupertinoIcons.lock_fill,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              onPressed: () => FirebaseAuth.instance.signOut(),
                            ),
                            const Spacer(),
                            IconButton(
                              tooltip: "Schließen",
                              onPressed: () => Navigator.of(context).pop(),
                              icon: Icon(
                                CupertinoIcons.clear_circled,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "Name: ${FirebaseAuth.instance.currentUser!.displayName}",
                          style: TextStyle(
                              fontSize: 16,
                              color:
                                  Theme.of(context).colorScheme.onBackground),
                        ),
                        Text(
                          "E-Mail: ${FirebaseAuth.instance.currentUser!.email}",
                          style: TextStyle(
                              fontSize: 16,
                              color:
                                  Theme.of(context).colorScheme.onBackground),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "UID: ${FirebaseAuth.instance.currentUser!.uid}",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                            ),
                            Text(
                              "(Kann zur Authentifizierung gegenüber dem Admin verwendet werden)",
                              style: TextStyle(
                                  fontSize: 8,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Tooltip(
                              message:
                                  "Diesen QR-Code können deine Freunde scannen, um dich als Freund hinzuzufügen",
                              child: QrImage(
                                data:
                                    "DOKO§${FirebaseAuth.instance.currentUser!.uid}:${FirebaseAuth.instance.currentUser!.displayName}",
                                size: 200,
                                foregroundColor:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                            Text(
                              "QR-Code für Freundefunktion",
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () => pushNewScreen(
                            context,
                            screen: const Scanner(),
                          ),
                          child: Text(
                            "Freund hinzufügen",
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return const Text("Fehler");
              } else {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            const Spacer(),
                            IconButton(
                              tooltip: "Schließen",
                              onPressed: () => Navigator.of(context).pop(),
                              icon: Icon(
                                CupertinoIcons.clear_circled,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () async {
                            _showLogin(context);
                          },
                          child: const Text("Anmelden"),
                        ),
                        ElevatedButton(
                          onPressed: () => _showRegister(context),
                          child: const Text("Registrieren"),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                );
              }
            });
      },
    );
  }

  void _showLogin(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      isScrollControlled: true,
      context: context,
      builder: (BuildContext bc) {
        return StatefulBuilder(
          builder: (BuildContext bc, StateSetter bottomModalStateSetter) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const Spacer(),
                        IconButton(
                          tooltip: "Schließen",
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            CupertinoIcons.clear_circled,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Login(),
                    const Spacer(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showRegister(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      isScrollControlled: true,
      context: context,
      builder: (BuildContext bc) {
        return StatefulBuilder(
          builder: (BuildContext bc, StateSetter bottomModalStateSetter) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const Spacer(),
                        IconButton(
                          tooltip: "Schließen",
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            CupertinoIcons.clear_circled,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Register(),
                    const Spacer(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
