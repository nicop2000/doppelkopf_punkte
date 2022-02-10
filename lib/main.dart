import 'dart:async';
import 'package:doppelkopf_punkte/doko/game_add_entry.dart';
import 'package:doppelkopf_punkte/doko/game_list.dart';
import 'package:doppelkopf_punkte/doko/game_settings.dart';
import 'package:doppelkopf_punkte/doko/game_statistics.dart';
import 'package:doppelkopf_punkte/doko/saved_lists.dart';
import 'package:doppelkopf_punkte/helper/enviroment_variables.dart';
import 'package:doppelkopf_punkte/helper/helper.dart';
import 'package:doppelkopf_punkte/helper/persistent_data.dart';
import 'package:doppelkopf_punkte/model/friend.dart';
import 'package:doppelkopf_punkte/model/user.dart';
import 'package:doppelkopf_punkte/scanner.dart';
import 'package:doppelkopf_punkte/usersPage/login.dart';
import 'package:doppelkopf_punkte/usersPage/register.dart';
import 'package:doppelkopf_punkte/usersPage/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helper/constants.dart';
/// Diese App ist der Anwesenheitsmelder für Studenten der FH-Kiel.

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  EnviromentVariables.prefs = await SharedPreferences.getInstance();
  if (Helpers.timer.isActive) Helpers.timer.cancel();
  if (FirebaseAuth.instance.currentUser != null) {
    await Helpers.userLoggedIn();
  }
  AppUser.instance.canCheckBio = await AppUser.instance.localAuth.canCheckBiometrics;
  AppUser.instance.deviceSupported = await AppUser.instance.localAuth.isDeviceSupported();


  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => Opponent("", "")),
            ChangeNotifierProvider(create: (_) => UserModel("", [], [], [])),
            ChangeNotifierProvider(create: (_) => App()),
          ],
      child: const DokoPunkte()
  );
}

class DokoPunkte extends StatefulWidget {
  const DokoPunkte({Key? key}) : super(key: key);

  static void setAppState(BuildContext context) {
    context.findAncestorStateOfType<_DokoPunkteState>()!.restartApp();
  }

  @override
  State<DokoPunkte> createState() => _DokoPunkteState();
}

class _DokoPunkteState extends State<DokoPunkte> {
  void restartApp() {
    setState(() {});

  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          background: PersistentData.getBackground(),
          onBackground: PersistentData.getOnBackground(),
          primary: PersistentData.getPrimaryColor(),
          primaryVariant: Colors.teal,
          onPrimary: PersistentData.getOnPrimary(),
          secondary: PersistentData.getActive(),
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            tooltip: "Accountinformationen",
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
            key: EnviromentVariables.keyBottomNavBar,
            type: BottomNavigationBarType.shifting,
            selectedItemColor: PersistentData.getActive(),
            iconSize: 25,
            selectedIconTheme: const IconThemeData(
              size: 35,
            ),
            unselectedItemColor: Theme.of(context).colorScheme.background,
            onTap: (index) {
              _index = index;
              setState(() {});
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
                            Column(
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
                                Text("Einstellungen", style: TextStyle(color: Theme.of(context).colorScheme.onBackground, fontSize: 8),),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              children: [
                                IconButton(
                                  tooltip: "Alle lokalen Daten löschen",
                                  color: Theme.of(context).colorScheme.primary,
                                  onPressed: () async {
                                    if (await Helpers.authenticate()) {
                                      showCupertinoDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return CupertinoAlertDialog(
                                              title: const Text("Achtung"),
                                              content: const Text(
                                                  "Du bist im Begriff, alle lokalen Daten zu löschen. Dies beinhaltet alle nicht abgeschlossenen Listen und du wirst ausgeloggt. Willst du fortfahren? (Kann nicht rückgänig gemacht werden)"),
                                              actions: <Widget>[
                                                CupertinoDialogAction(
                                                    child: const Text("Ja"),
                                                    onPressed: () {
                                                      EnviromentVariables.prefs
                                                          .clear();
                                                      DokoPunkte.setAppState(
                                                          context);
                                                      FirebaseAuth.instance
                                                          .signOut();
                                                      Navigator.of(context).pop();
                                                    }),
                                                CupertinoDialogAction(
                                                    child: const Text("Nein"),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    }),
                                              ],
                                            );
                                          });
                                    }
                                  },
                                  icon: Icon(
                                    CupertinoIcons.bin_xmark,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                Text("Lokales löschen", style: TextStyle(color: Theme.of(context).colorScheme.onBackground, fontSize: 8),),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              children: [
                                IconButton(
                                  tooltip: "Alle Daten löschen",
                                  color: Theme.of(context).colorScheme.primary,
                                  onPressed: () async {
                                    if (await Helpers.authenticate()) {
                                      showCupertinoDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return CupertinoAlertDialog(
                                              title: const Text("Achtung"),
                                              content: const Text(
                                                  "Du bist im Begriff, alle deine Daten zu löschen. Das beinhaltet sämtliche lokalen Speicher als auch die Online-Daten und dein Konto. Willst du wirklich fortfahren? (Kann nicht rückgängig gemacht werden)"),
                                              actions: <Widget>[
                                                CupertinoDialogAction(
                                                    child: const Text("Ja"),
                                                    onPressed: () async {
                                                      EnviromentVariables.prefs
                                                          .clear();
                                                      await Constants
                                                          .realtimeDatabase
                                                          .child(
                                                              'friends/${FirebaseAuth.instance.currentUser!.uid}')
                                                          .remove();
                                                      await Constants
                                                          .realtimeDatabase
                                                          .child(
                                                              'lists/${FirebaseAuth.instance.currentUser!.uid}')
                                                          .remove();
                                                      FirebaseAuth
                                                          .instance.currentUser!
                                                          .delete();
                                                      DokoPunkte.setAppState(
                                                          context);
                                                      Navigator.of(context).pop();
                                                    }),
                                                CupertinoDialogAction(
                                                    child: const Text("Nein"),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    }),
                                              ],
                                            );
                                          });
                                    }
                                  },
                                  icon: Icon(
                                    CupertinoIcons.clear_thick,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                Text("Alles löschen", style: TextStyle(color: Theme.of(context).colorScheme.onBackground, fontSize: 8),),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              children: [
                                IconButton(
                                  tooltip: "Freunde verwalten",
                                  color: Theme.of(context).colorScheme.primary,
                                  onPressed: () async {
                                    _showFriendManagement(context);
                                  },
                                  icon: Icon(
                                    CupertinoIcons.rectangle_stack_person_crop,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                Text("Freunde verwalten", style: TextStyle(color: Theme.of(context).colorScheme.onBackground, fontSize: 8),),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              children: [
                                IconButton(
                                    tooltip: "Logout",
                                    icon: Icon(
                                      CupertinoIcons.lock_fill,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                    onPressed: () async {
                                      await FirebaseAuth.instance.signOut();
                                      await Helpers.initFriends();
                                    }),
                              Text("Ausloggen", style: TextStyle(color: Theme.of(context).colorScheme.onBackground, fontSize: 8),),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              children: [
                                IconButton(
                                  tooltip: "Schließen",
                                  onPressed: () => Navigator.of(context).pop(),
                                  icon: Icon(
                                    CupertinoIcons.clear_circled,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              Text("Schließen", style: TextStyle(color: Theme.of(context).colorScheme.onBackground, fontSize: 8),),
                              ],
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
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextButton(
                                onPressed: () => pushNewScreen(
                                  context,
                                  screen: const Scanner(),
                                ),
                                child: Text(
                                  "Freund hinzufügen",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(),
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
                          icon: Icon(
                            CupertinoIcons.clear_circled,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
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
                          icon: Icon(
                            CupertinoIcons.clear_circled,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
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

  Widget buildSheet() {
    return DraggableScrollableSheet(
      minChildSize: 0.9,
      initialChildSize: 1,
      builder: (_, controller) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView(
            controller: controller,
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
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: StatefulBuilder(
                    builder: (BuildContext bc, StateSetter managementState) {
                  Widget getFriend(Friend friend) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          friend.name,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 18,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.remove_circle_rounded,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: () async {
                            await Constants.realtimeDatabase
                                .child(
                                    'friends/${FirebaseAuth.instance.currentUser!.uid}')
                                .update({friend.uid: null});
                            await Helpers.getFriends();
                            managementState(() {});
                          },
                        ),
                      ],
                    );
                  }

                  return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (AppUser.instance.friends.length <= 3)
                          Center(
                              child: Text("Du hast noch keine Freunde :c",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground)))
                        else
                          for (Friend friend in AppUser.instance.friends)
                            if (friend.uid != "null") getFriend(friend)
                      ]);
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFriendManagement(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Theme.of(context).colorScheme.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        isScrollControlled: true,
        constraints: BoxConstraints.tight(
            Size.fromHeight(MediaQuery.of(context).size.height * 0.85)),
        context: context,
        builder: (BuildContext bc) {
          return StatefulBuilder(
              builder: (BuildContext bc, StateSetter bottomModalStateSetter) {
            return buildSheet();
          });
        });
  }
}
