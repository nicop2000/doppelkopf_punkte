import 'package:doppelkopf_punkte/doko/game_list/sort_players.dart';
import 'package:doppelkopf_punkte/helper/constants.dart';
import 'package:doppelkopf_punkte/model/friend.dart';
import 'package:doppelkopf_punkte/model/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayerManagement extends StatefulWidget {
  const PlayerManagement({Key? key}) : super(key: key);

  @override
  _PlayerManagementState createState() => _PlayerManagementState();
}

class _PlayerManagementState extends State<PlayerManagement> {
  int playerCount = 0;
  List<Friend> friendsToPlay = [];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Spieler auswählen",
          style: TextStyle(color: Theme.of(context).colorScheme.background),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: getPlayerList(context),
        ),
      ),
    );
  }

  List<Widget> getPlayerList(BuildContext context) {
    List<Widget> friends = [];
    friends.add(
      Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Center(
          child: Text(
            "3 Mitspieler auswählen",
            style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontWeight: FontWeight.w500,
                fontSize: 20),
          ),
        ),
      ),
    );
    for (Friend friend in context.read<AppUser>().friends) {
      friends.add(buildFriend(friend));
    }
    friends.add(CupertinoButton(
        child: const Text("Spiel starten"),
        onPressed: playerCount != 3
            ? null
            : () {
                friendsToPlay.add(Friend(
                    uid: context.read<AppUser>().user!.uid,
                    name: context.read<AppUser>().user!.displayName!));
                for (Friend friend in friendsToPlay) {
                  friend.activated = false;
                }
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => SortPlayers(playersToBe: friendsToPlay)));
              }));
    return friends;
  }

  Widget buildFriend(Friend friend) {
    TextEditingController tec = TextEditingController();
    return Column(
      children: [
        GestureDetector(
          child: Container(
            child: Text(friend.name),
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: friend.activated ? Colors.green : Colors.red,
                borderRadius: const BorderRadius.all(Radius.circular(10))),
          ),
          onTap: () {
            if (!friend.activated) {
              if (playerCount < 3) {
                setState(() {
                  playerCount++;
                  friend.activated = true;
                  friendsToPlay.add(friend);
                });
              }
            } else {
              setState(() {
                playerCount--;
                friend.activated = false;
                friendsToPlay.removeWhere((element) =>
                    (element.name == friend.name && element.uid == friend.uid));
              });
            }
          },
        ),
        if (friend.uid == "null" && friend.activated)
          TextField(
              controller: tec,
              decoration: InputDecoration(
                hintText: "Namen für Spieler ${friend.name} eingeben",
                hintStyle: const TextStyle(
                  color: Constants.mainGreyHint,
                ),
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
                labelText: "${friend.name} heißt eigentlich:",
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Constants.mainGrey),
                ),
              ),
              onChanged: (newName) {
                if (newName.trim().isNotEmpty) {
                  friend.name = newName;
                }
              })
      ],
    );
  }
}

extension on List<Friend> {
  bool containsName(String string) {
    for (Friend friend in this) {
      if (friend.name.contains(string)) return true;
    }
    return false;
  }

  bool nameIsEmpty() {
    for (Friend friend in this) {
      if (friend.name.isEmpty) return true;
    }
    return false;
  }
}

/*
return Column(
mainAxisAlignment: MainAxisAlignment.spaceEvenly,
children: [
for (Friend friend in AppUser.instance.friends)
getFriend(friend),
]);
})
,
CupertinoButton
(
child: Text
("Starten
"
,
style: Helpers.getButtonStyle(context),
)
,
onPressed: (
)
async {init = false;
if
(
_playerCount != 3) {
notEnoughPlayers(context);
return;
}
if
(
extra1 || extra2 || extra3) {
await setPlayernames();
if (extra1 && Game.instance.names[0].isEmpty ||
extra2 && Game.instance.names[1].isEmpty ||
extra3 && Game.instance.names[2].isEmpty) {
return;
}
}
String name =
FirebaseAuth.instance.currentUser!.displayName!;
Player self = Player(name);
self.uid = FirebaseAuth.instance.currentUser!.
uid;Game.instance.players.add(self);
Game.instance.date = DateTime.now()
.
toIso8601String
(
).substring
(0,
16
)
.
replaceAll
("T", " ");
if (extra1) {
Game.instance.players
    .add(Player(Game.instance.names[0]));
}
if
(
extra2) {
Game.instance.players
    .add(Player(Game.instance.names[1]));
}
if
(
extra3) {
Game.instance.players
    .add(Player(Game.instance.names[2]));
}
for
(

Friend f
in
activated.keys) {
if (activated[f]! && !f.name.contains("Extra")) {
Player p = Player(f.name);
p.uid = f.uid;
Game.instance.players.add(p);
}
}
Runde.instance.init();
Game.instance.saveList(context);
listNameController.text = "
"
;
Navigator.of(context).

pop();
init = true;
setState
(() {});
}),
],
),
],
)
,





bool extra1 = false;
bool extra2 = false;
bool extra3 = false;
bool init = true;

Widget buildSheet() {
  if (init) {
    for (Friend f in AppUser.instance.friends) {
      activated.addAll({f: false});
    }
  }

  return DraggableScrollableSheet(
      minChildSize: 0.9,
      initialChildSize: 1,
      builder: (_, controller) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child:
        );
      });
}

void _showPlayerInput(BuildContext context) {
  _playerCount = 0;
  showModalBottomSheet(
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      isScrollControlled: true,
      constraints: BoxConstraints.tight(
          Size.fromHeight(MediaQuery
              .of(context)
              .size
              .height * 0.85)),
      context: context,
      builder: (context) {
        return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (BuildContext bc, AsyncSnapshot<User?> snapshot) {
              if (snapshot.hasData) {
                return buildSheet();
              } else if (snapshot.hasError) {
                return Column(
                  children: [
                    Row(
                      children: [
                        const Spacer(),
                        IconButton(
                          tooltip: "Schließen",
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(
                            CupertinoIcons.clear_circled,
                            color: Theme
                                .of(context)
                                .colorScheme
                                .primary,
                          ),
                        ),
                      ],
                    ),
                    const Center(
                      child: Text("Es ist ein Fehler aufgetreten"),
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    Row(
                      children: [
                        const Spacer(),
                        IconButton(
                          tooltip: "Schließen",
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(
                            CupertinoIcons.clear_circled,
                            color: Theme
                                .of(context)
                                .colorScheme
                                .primary,
                          ),
                        ),
                      ],
                    ),
                    Center(
                      child: CupertinoButton(
                        child: const Text("Bitte melde dich erst an"),
                        onPressed: () {
                          Navigator.of(context).pop();
                          _showAccountInfo(context);
                        },
                      ),
                    ),
                  ],
                );
              }
            });
      });
}

void notEnoughPlayers(BuildContext context) {
  showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text("Zu wenig Spieler ausgewählt"),
          content: const Text(
              "Es müssen 3 Spieler ausgewählt (grün hinterlegt) sein"),
          actions: <Widget>[
            CupertinoDialogAction(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ],
        );
      });
}

Future<void> setPlayernames() async {
  Widget okButton = CupertinoButton(
    child: const Text("OK"),
    onPressed: () {
      if (_namesKey.currentState!.validate()) {
        Navigator.of(context).pop();
      }
    },
  );
  AlertDialog alert = AlertDialog(
    backgroundColor: Theme
        .of(context)
        .colorScheme
        .background,
    title: Text(
      "Bitte gebe die Spielernamen ein",
      style: TextStyle(color: Theme
          .of(context)
          .colorScheme
          .onBackground),
    ),
    content: SizedBox(
        height: MediaQuery
            .of(context)
            .size
            .height * 0.4,
        child: Form(key: _namesKey, child: await getAlterContent())),
    actions: [okButton],
  );
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Future<Column> getAlterContent() async {
  List<Widget> temp = [];

  if (extra1) {
    temp.add(TextFormField(
      controller: player1,
      validator: (name) {
        if (name!.isNotEmpty) {
          Game.instance.names[0] = name;
        }
        return name.isEmpty ? "Bitte einen Spielernamen eingeben" : null;
      },
      decoration: InputDecoration(
        errorMaxLines: 3,
        hintText: "Spielernamen eingeben",
        hintStyle: const TextStyle(
          color: Constants.mainGreyHint,
        ),
        labelStyle: TextStyle(
          color: Theme
              .of(context)
              .colorScheme
              .primary,
        ),
        labelText: "Spieler 1",
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Constants.mainGrey),
        ),
      ),
    ));
  }
  if (extra2) {
    temp.add(TextFormField(
      controller: player2,
      validator: (name) {
        if (name!.isNotEmpty) {
          Game.instance.names[1] = name;
        }
        return name.isEmpty ? "Bitte einen Spielernamen eingeben" : null;
      },
      decoration: InputDecoration(
        errorMaxLines: 3,
        hintText: "Spielernamen eingeben",
        hintStyle: const TextStyle(
          color: Constants.mainGreyHint,
        ),
        labelStyle: TextStyle(
          color: Theme
              .of(context)
              .colorScheme
              .primary,
        ),
        labelText: "Spieler 2",
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Constants.mainGrey),
        ),
      ),
    ));
  }
  if (extra3) {
    temp.add(
      TextFormField(
        controller: player3,
        validator: (name) {
          if (name!.isNotEmpty) {
            Game.instance.names[2] = name;
          }
          return name.isEmpty ? "Bitte einen Spielernamen eingeben" : null;
        },
        decoration: InputDecoration(
          errorMaxLines: 3,
          hintText: "Spielernamen eingeben",
          hintStyle: const TextStyle(
            color: Constants.mainGreyHint,
          ),
          labelStyle: TextStyle(
            color: Theme
                .of(context)
                .colorScheme
                .primary,
          ),
          labelText: "Spieler 3",
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Constants.mainGrey),
          ),
        ),
      ),
    );
  }
  return Column(children: temp);
}

void _showSettings(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: Theme
        .of(context)
        .colorScheme
        .background,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
    isScrollControlled: true,
    context: context,
    builder: (BuildContext bc) {
      return SizedBox(
        height: MediaQuery
            .of(context)
            .size
            .height * 0.85,
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
                    color: Theme
                        .of(context)
                        .colorScheme
                        .primary,
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
    backgroundColor: Theme
        .of(context)
        .colorScheme
        .background,
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
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.75,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            tooltip: "Einstellungen",
                            color: Theme
                                .of(context)
                                .colorScheme
                                .primary,
                            onPressed: () async {
                              if (await Helpers.authenticate()) {
                                _showSettings(context);
                              }
                            },
                            icon: Icon(
                              CupertinoIcons.settings_solid,
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .primary,
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
                                color: Theme
                                    .of(context)
                                    .colorScheme
                                    .primary,
                              ),
                            ),
                            icon: Icon(
                              CupertinoIcons.lock_fill,
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .primary,
                            ),
                            onPressed: () => FirebaseAuth.instance.signOut(),
                          ),
                          const Spacer(),
                          IconButton(
                            tooltip: "Schließen",
                            onPressed: () => Navigator.of(context).pop(),
                            icon: Icon(
                              CupertinoIcons.clear_circled,
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .primary,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "Name: ${FirebaseAuth.instance.currentUser!
                            .displayName}",
                        style: TextStyle(
                            fontSize: 16,
                            color:
                            Theme
                                .of(context)
                                .colorScheme
                                .onBackground),
                      ),
                      Text(
                        "E-Mail: ${FirebaseAuth.instance.currentUser!.email}",
                        style: TextStyle(
                            fontSize: 16,
                            color:
                            Theme
                                .of(context)
                                .colorScheme
                                .onBackground),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "UID: ${FirebaseAuth.instance.currentUser!.uid}",
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme
                                    .of(context)
                                    .colorScheme
                                    .onBackground),
                          ),
                          Text(
                            "(Kann zur Authentifizierung gegenüber dem Admin verwendet werden)",
                            style: TextStyle(
                                fontSize: 8,
                                color: Theme
                                    .of(context)
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
                              "DOKO§${FirebaseAuth.instance.currentUser!
                                  .uid}:${FirebaseAuth.instance.currentUser!
                                  .displayName}",
                              size: 200,
                              foregroundColor:
                              Theme
                                  .of(context)
                                  .colorScheme
                                  .onBackground,
                            ),
                          ),
                          Text(
                            "QR-Code für Freundefunktion",
                            style: TextStyle(
                              color:
                              Theme
                                  .of(context)
                                  .colorScheme
                                  .onBackground,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () =>
                            pushNewScreen(
                              context,
                              screen: const Scanner(),
                            ),
                        child: Text(
                          "Freund hinzufügen",
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme
                                .of(context)
                                .colorScheme
                                .primary,
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
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.75,
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
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .primary,
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
    backgroundColor: Theme
        .of(context)
        .colorScheme
        .background,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
    isScrollControlled: true,
    context: context,
    builder: (BuildContext bc) {
      return StatefulBuilder(
        builder: (BuildContext bc, StateSetter bottomModalStateSetter) {
          return SizedBox(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.75,
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
                          color: Theme
                              .of(context)
                              .colorScheme
                              .primary,
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
    backgroundColor: Theme
        .of(context)
        .colorScheme
        .background,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
    isScrollControlled: true,
    context: context,
    builder: (BuildContext bc) {
      return StatefulBuilder(
        builder: (BuildContext bc, StateSetter bottomModalStateSetter) {
          return SizedBox(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.75,
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
                          color: Theme
                              .of(context)
                              .colorScheme
                              .primary,
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
}*/
