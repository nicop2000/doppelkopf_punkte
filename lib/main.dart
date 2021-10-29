// ignore_for_file: prefer_const_constructors

import 'package:doppelkopf_punkte/admin.dart';
import 'package:doppelkopf_punkte/doko/game_add_entry.dart';
import 'package:doppelkopf_punkte/doko/game_list.dart';
import 'package:doppelkopf_punkte/doko/game_settings.dart';
import 'package:doppelkopf_punkte/doko/game_statistics.dart';
import 'package:doppelkopf_punkte/helper/enviroment_variables.dart';
import 'package:doppelkopf_punkte/helper/helper.dart';
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

import 'helper/constants.dart';

/// Diese App ist der Anwesenheitsmelder für Studenten der FH-Kiel.

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Env.canCheckBio = await Env.localAuth.canCheckBiometrics;
  Env.deviceSupported = await Env.localAuth.isDeviceSupported();
  if (FirebaseAuth.instance.currentUser != null) {
    Helpers.userLoggedIn(FirebaseAuth.instance.currentUser!);
  }
  runApp(DokoPunkte());
}

class DokoPunkte extends StatelessWidget {
  const DokoPunkte({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Constants.fhTheme,
      initialRoute: "/",
      routes: {
        "/": (context) => AppOverlay(),
        "${routers.login}": (context) => Login(),
        "${routers.register}": (context) => Register(),
        "${routers.admin}": (context) => Admin(),
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
    0: ["Spielliste", null],
    1: ["Eintrag hinzufügen", null],
    2: ["Statistiken", null],
    3: ["Einstellungen", null],
    4: ["Einstellungen", null],
  };

  @override
  Widget build(BuildContext context) {
    PersistentTabController _controller;
    int initialIndex = 1;
    _controller = PersistentTabController(initialIndex: initialIndex);

    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.account_circle_outlined),
              onPressed: () => _showAccountInfo(context),
            ),
          ],
          title: Text("${_content[_index]![0]}"),
        ),
        body: PersistentTabView(
          context,
          controller: _controller,
          backgroundColor: Constants.mainBlue,
          handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset: true,
          hideNavigationBarWhenKeyboardShows: true,
          decoration: NavBarDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            adjustScreenBottomPaddingOnCurve: true,

          ),
          screens: const [
            GameList(),
            GameAddEntry(),
            GameStatistics(),
            GameSettings(),
            GameList(),
          ],
          items: [
            _bottomNavigationElementPersistent(
                title: "Spielliste", icon: Icons.account_balance_outlined),
            _bottomNavigationElementPersistent(
                title: "Statistiken", icon: Icons.assistant_navigation),
            _bottomNavigationElementPersistent(
                title: "Neu", icon: CupertinoIcons.add),
            _bottomNavigationElementPersistent(
                title: "Einstellungen", icon: Icons.assistant_navigation),
            _bottomNavigationElementPersistent(
                title: "Freunde", icon: Icons.assistant_navigation),
          ],
          onItemSelected: (index) => setState(() {
            _index = index;
          }),
          confineInSafeArea: true,
          navBarStyle: NavBarStyle.style6,

        ));
  }

  /// Das _bottomNavigationElement stellt die Naviagtionselemente in der unteren
  /// Navigationsleiste dar.

  PersistentBottomNavBarItem _bottomNavigationElementPersistent(
      {required String title, required IconData icon}) {
    return PersistentBottomNavBarItem(
      icon: Icon(icon),

      activeColorSecondary: Colors.red,

      title: title,
      inactiveColorPrimary: Constants.mainGrey,
    );
  }

  void _showSettings(BuildContext context) {
    showModalBottomSheet(
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
                  Spacer(),
                  IconButton(
                    tooltip: "Schließen",
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      CupertinoIcons.clear_circled,
                      color: Constants.mainBlue,
                    ),
                  ),
                ],
              ),
              Expanded(child: Settings()),
            ],
          ),
        );
      },
    );
  }

  void _showAccountInfo(BuildContext context) {
    Stream<User?> firebaseStream = FirebaseAuth.instance.authStateChanges();
    showModalBottomSheet(
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
                              onPressed: () async {
                                if (await Helpers.authenticate()) {
                                  _showSettings(context);
                                }
                              },
                              icon: Icon(
                                CupertinoIcons.settings_solid,
                                color: Constants.mainBlue,
                              ),
                            ),
                            Spacer(),
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                    width: 1.0, color: Constants.mainGrey),
                              ),
                              label: Text("Logout"),
                              icon: Icon(
                                CupertinoIcons.lock_fill,
                                color: Constants.mainBlue,
                              ),
                              onPressed: () => FirebaseAuth.instance.signOut(),
                            ),
                            Spacer(),
                            IconButton(
                              tooltip: "Schließen",
                              onPressed: () => Navigator.of(context).pop(),
                              icon: Icon(
                                CupertinoIcons.clear_circled,
                                color: Constants.mainBlue,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "Name: ${FirebaseAuth.instance.currentUser!.displayName}",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          "E-Mail: ${FirebaseAuth.instance.currentUser!.email}",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              "UID: ${FirebaseAuth.instance.currentUser!.uid}",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "(Kann zur Authentifizierung gegenüber dem Admin verwendet werden)",
                              style: TextStyle(fontSize: 8),
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
                                    "${FirebaseAuth.instance.currentUser!.uid}:${FirebaseAuth.instance.currentUser!.displayName}",
                                size: 200,
                              ),
                            ),
                            Text("QR-Code für Freundefunktion"),
                          ],
                        ),
                        TextButton(
                          onPressed: () => pushNewScreen(
                            context,
                            screen: Scanner(),
                          ),
                          child: Text(
                            "Freund hinzufügen",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("Fehler");
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
                            Spacer(),
                            IconButton(
                              tooltip: "Schließen",
                              onPressed: () => Navigator.of(context).pop(),
                              icon: Icon(
                                CupertinoIcons.clear_circled,
                                color: Constants.mainBlue,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        ElevatedButton(
                          onPressed: () async {
                            _showLogin(context);
                          },
                          child: Text("Anmelden"),
                        ),
                        ElevatedButton(
                          onPressed: () => _showRegister(context),
                          child: Text("Registrieren"),
                        ),
                        Spacer(),
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
                        Spacer(),
                        IconButton(
                          tooltip: "Schließen",
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(
                            CupertinoIcons.clear_circled,
                            color: Constants.mainBlue,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Login(),
                    Spacer(),
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
                        Spacer(),
                        IconButton(
                          tooltip: "Schließen",
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(
                            CupertinoIcons.clear_circled,
                            color: Constants.mainBlue,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Register(),
                    Spacer(),
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
