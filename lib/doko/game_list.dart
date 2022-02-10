import 'dart:async';

import 'package:doppelkopf_punkte/helper/constants.dart';
import 'package:doppelkopf_punkte/helper/enviroment_variables.dart';
import 'package:doppelkopf_punkte/helper/helper.dart';
import 'package:doppelkopf_punkte/helper/persistent_data.dart';
import 'package:doppelkopf_punkte/main.dart';
import 'package:doppelkopf_punkte/model/friend.dart';
import 'package:doppelkopf_punkte/model/game.dart';
import 'package:doppelkopf_punkte/model/player.dart';
import 'package:doppelkopf_punkte/model/runde.dart';
import 'package:doppelkopf_punkte/model/user.dart';
import 'package:doppelkopf_punkte/scanner.dart';
import 'package:doppelkopf_punkte/usersPage/login.dart';
import 'package:doppelkopf_punkte/usersPage/register.dart';
import 'package:doppelkopf_punkte/usersPage/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sticky_headers/sticky_headers.dart';

class GameList extends StatefulWidget {
  const GameList({Key? key}) : super(key: key);

  @override
  State<GameList> createState() => _GameListState();
}

class _GameListState extends State<GameList> {
  final _namesKey = GlobalKey<FormState>();
  final _workTogetherKey = GlobalKey<FormState>();
  Map<Friend, bool> activated = {};
  int _playerCount = 0;
  int _rounds = Game.instance.maxRounds;
  TextEditingController listNameController = TextEditingController();
  TextEditingController workTogether = TextEditingController();

  var timer = Timer(Duration(days: 2), () {});

  @override
  void initState() {
    extra1 = false;
    extra2 = false;
    extra3 = false;
    init = true;
    if (Game.instance.shared)
      timer = Timer.periodic(Constants.refreshList, (timer) {
        print("SET");
        setState(() {});
      });
    setState(() {});
    super.initState();
    super.initState();
  }

  @override
  void dispose() {
    if (timer.isActive) timer.cancel();
    listNameController.dispose();
    player1.dispose();
    player2.dispose();
    player3.dispose();
    player4.dispose();
    workTogether.dispose();
    super.dispose();
  }

  getReBool() => Game.instance.rePoints == 2;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext bc, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasData) {
            if (Game.instance.players.isEmpty) {
              return Center(
                child: CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Text(
                              "Rundenanzahl auswählen",
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          NumberPicker(
                            minValue: 3,
                            maxValue: 90,
                            value: _rounds,
                            onChanged: (newMax) =>
                                setState(() => _rounds = newMax),
                            textStyle: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                fontSize: 17),
                            selectedTextStyle: TextStyle(
                                color: PersistentData.getActive(),
                                fontSize: 30,
                                fontWeight: FontWeight.w600),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                30.0, 20.0, 30.0, 20.0),
                            child: TextField(
                              autocorrect: false,
                              controller: listNameController,
                              decoration: InputDecoration(
                                hintText: "z.B. Liste Nr. 1",
                                hintStyle: const TextStyle(
                                  color: Constants.mainGreyHint,
                                ),
                                labelStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                labelText: "Listenname",
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Constants.mainGrey),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                Text("Re/Kontra geben..."),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("1 Punkt"),
                                    Switch(
                                        value: getReBool(),
                                        onChanged: (newValue) {
                                          newValue
                                              ? Game.instance.rePoints = 2
                                              : Game.instance.rePoints = 1;
                                          setState(() {});
                                        }),
                                    const Text("2 Punkte")
                                  ],
                                ),
                              ])),
                          CupertinoButton(
                            onPressed: () {
                              Game.instance.setMaxRounds(_rounds);

                              Game.instance.listname = listNameController.text;
                              Game.instance.listname +=
                                  " - ${DateTime.now().toIso8601String().substring(0, 16).replaceAll("T", " ")}";
                              Game.instance.listname.replaceAll(".", "_");

                              _showPlayerInput(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Neue Liste beginnen",
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                            ),
                          ),
                          if (AppUser.instance.pendingLists.isNotEmpty)
                            CupertinoButton(
                                child:
                                    const Text("Alte Liste wiederherstellen"),
                                onPressed: () async {
                                  List<String> items = AppUser
                                      .instance.pendingLists
                                      .map((e) => e.listname)
                                      .toList();
                                  String selectedList = items[0];

                                  showMaterialScrollPicker(
                                      context: context,
                                      items: items,
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      confirmText: "OK",
                                      cancelText: "Abbrechen",
                                      buttonTextColor:
                                          Theme.of(context).colorScheme.primary,
                                      title: "Wähle eine Liste aus",
                                      headerColor:
                                          Theme.of(context).colorScheme.primary,
                                      headerTextColor: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      showDivider: false,
                                      selectedItem: selectedList,
                                      onChanged: (value) => setState(
                                          () => selectedList = value as String),
                                      onConfirmed: () async {
                                        for (Game game
                                            in AppUser.instance.pendingLists) {
                                          if (game.listname == selectedList) {
                                            await Game.instance
                                                .restoreList(context, game);
                                          }
                                        }
                                        setState(() {});
                                        print("GAME_LIST RESTORE");
                                        timer = Timer.periodic(
                                            Constants.refreshList, (timer) {
                                          print("SET");
                                          setState(() {});
                                        });
                                      });
                                }),

                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 20),
                            child: Text(
                              "oder",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onBackground,
                                fontWeight: FontWeight.w400,
                                fontSize: 20,
                              ),
                            ),
                          ),

                          Text(
                            "Bei anderer Liste mitwriken",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                30.0, 20.0, 30.0, 20.0),
                            child: Form(
                              key: _workTogetherKey,
                              child: TextFormField(
                                autocorrect: false,
                                validator: (code) {
                                  code!.length != 6
                                      ? "Der Code muss 6 Stellen lang sein"
                                      : null;
                                },
                                onChanged: (_) => setState(() {}),
                                controller: workTogether,
                                decoration: InputDecoration(
                                  hintText: "z.B. 12345678",
                                  hintStyle: const TextStyle(
                                    color: Constants.mainGreyHint,
                                  ),
                                  labelStyle: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  labelText: "Code eingeben",
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Constants.mainGrey),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (workTogether.text.isNotEmpty)
                            CupertinoButton(
                                child: const Text("Zusammenarbeit starten"),
                                onPressed: () async {
                                  if (_workTogetherKey.currentState!
                                      .validate()) {
                                    if (!await Helpers.getTogetherList(
                                        context, workTogether.text)) {
                                      showCupertinoDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return CupertinoAlertDialog(
                                              title:
                                                  const Text("Nichts gefunden"),
                                              content: const Text(
                                                  "Es gibt keine Liste mit diesem Code :c"),
                                              actions: <Widget>[
                                                CupertinoDialogAction(
                                                    child: const Text("OK"),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    })
                                              ],
                                            );
                                          });
                                    } else {
                                      EnviromentVariables.othersList = true;
                                      workTogether.text = "";
                                      Helpers.startTimer(context);
                                      print("GAME_LIST ELSE");
                                      timer = Timer.periodic(
                                          Constants.refreshList, (timer) {
                                        print("SET");
                                        setState(() {});
                                      });
                                    }
                                  }

                                  setState(() {});
                                }),
                        ],

                      ),
                    ),
                  ],
                ),
              );
            } else {
              return ListView(
                children: [
                  if (Game.instance.currentRound - 1 >= Game.instance.maxRounds)
                    Padding(
                      padding: EdgeInsets.only(top: spacing),
                      child: Center(
                          child: Helpers.getQuestionnaireHeadline(
                              context, "Die Liste ist beendet")),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: StickyHeader(
                      header: Container(
                        color: Theme.of(context).colorScheme.background,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: getList()
                                .map((e) => (e as Column).children.first)
                                .toList(),
                          ),
                        ),
                      ),
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: getListMinusHead(),
                      ),
                    ),
                  ),
                  if (!(Game.instance.currentRound - 1 >=
                      Game.instance.maxRounds))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Center(
                        child: Text(
                          "Noch ${Game.instance.maxRounds + 1 - Game.instance.currentRound} Runden",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  if (Game.instance.currentRound > 1)
                    if (!EnviromentVariables.review)
                      CupertinoButton(
                          // color: Theme.of(context).colorScheme.onPrimary,
                          child: Text(
                            "Letzten Eintrag löschen",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          onPressed: () {
                            var b = Game.instance;
                            Game.instance.currentRound--;
                            for (var player in Game.instance.players) {
                              player.removeLastRound();
                            }
                            Game.instance.saveList(context);
                            setState(() {});
                          }),
                  if (EnviromentVariables.othersList)
                    CupertinoButton(
                        child: Text(
                          "Zusammenarbeit auf diesem Gerät beenden",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        onPressed: () {
                          Helpers.timer.cancel();
                          timer.cancel();
                          Game.instance.reset();
                          setState(() {});
                        }),
                  if (!EnviromentVariables.othersList)
                    CupertinoButton(
                        // color: Theme.of(context).colorScheme.onPrimary,
                        child: Text(
                          "Liste pausieren",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        onPressed: () async {
                          await Game.instance.pauseList(context);
                          timer.cancel();
                          setState(() {});
                        }),
                  if (!EnviromentVariables.othersList)
                    CupertinoButton(
                        // color: Theme.of(context).colorScheme.onPrimary,
                        child: Text(
                          "Liste löschen",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        onPressed: () {
                          showCupertinoDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CupertinoAlertDialog(
                                  title: const Text("Warnung"),
                                  content: const Text(
                                      "Soll die Liste wirklich gelöscht werden?"),
                                  actions: <Widget>[
                                    CupertinoDialogAction(
                                      isDefaultAction: true,
                                      child: const Text("Nein"),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                    ),
                                    CupertinoDialogAction(
                                      child: const Text("Ja"),
                                      onPressed: () async {
                                        await Game.instance.deleteList();
                                        timer.cancel();
                                        Helpers.timer.cancel();
                                        Navigator.of(context).pop();
                                        setState(() {});
                                      },
                                    )
                                  ],
                                );
                              });
                          setState(() {});
                        }),
                  if (!Game.instance.shared)
                    CupertinoButton(
                      onPressed: () {
                        Game.instance.shared = true;
                        Helpers.startTimer(context);
                        timer = Timer.periodic(Constants.refreshList, (timer) {
                          print("SET");
                          setState(() {});
                        });
                        Game.instance.saveList(context);
                        showCupertinoDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CupertinoAlertDialog(
                                title: const Text("Code"),
                                content: Text(
                                    "Diesen Code müssen deine Freunde eingeben, um auf ihrem Gerät mitarbeiten zu könnnen: ${Game.instance.id}"),
                                actions: <Widget>[
                                  CupertinoDialogAction(
                                    child: const Text("OK"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {});
                                    },
                                  ),
                                ],
                              );
                            });
                      },
                      child: Text(
                        "Liste als gemeinsam freigeben",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    )
                  else
                    Center(
                      child: Text(
                        "Code für Zusammenarbeit: ${Game.instance.id}",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    ),
                  if (Game.instance.currentRound - 1 >=
                          Game.instance.maxRounds &&
                      Game.instance.players[0].uid != "null")
                    CupertinoButton(
                        child: Text(
                            "Punkte für ${Game.instance.players[0].getName()} in Datenbank übertragen & speichern"),
                        onPressed: () {
                          Helpers.sendMyListToDB(Game.instance.players[0].uid);
                        }),
                  if (Game.instance.currentRound - 1 >=
                          Game.instance.maxRounds &&
                      Game.instance.players[1].uid != "null")
                    CupertinoButton(
                        child: Text(
                            "Punkte für ${Game.instance.players[1].getName()} in Datenbank übertragen & speichern"),
                        onPressed: () {
                          Helpers.sendMyListToDB(Game.instance.players[1].uid);
                        }),
                  if (Game.instance.currentRound - 1 >=
                          Game.instance.maxRounds &&
                      Game.instance.players[2].uid != "null")
                    CupertinoButton(
                        child: Text(
                            "Punkte für ${Game.instance.players[2].getName()} in Datenbank übertragen & speichern"),
                        onPressed: () {
                          Helpers.sendMyListToDB(Game.instance.players[2].uid);
                        }),
                  if (Game.instance.currentRound - 1 >=
                          Game.instance.maxRounds &&
                      Game.instance.players[3].uid != "null")
                    CupertinoButton(
                        child: Text(
                            "Punkte für ${Game.instance.players[3].getName()} in Datenbank übertragen & speichern"),
                        onPressed: () {
                          Helpers.sendMyListToDB(Game.instance.players[3].uid);
                        }),

                  if (Game.instance.currentRound - 1 >=
                      Game.instance.maxRounds)
                    CupertinoButton(
                        child: const Text(
                            "Liste endgültig beenden (kann danach nicht mehr bearbeitet werden)."),
                        onPressed: () {
                          showCupertinoDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CupertinoAlertDialog(
                                  title: const Text("Warnung"),
                                  content: const Text(
                                      "Soll die Liste wirklich beendet werden? Nicht in der Datenbank gespeicherte Listen gehen verloren!"),
                                  actions: <Widget>[
                                    CupertinoDialogAction(
                                      isDefaultAction: true,
                                      child: const Text("Nein"),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                    ),
                                    CupertinoDialogAction(
                                      child: const Text("Ja"),
                                      onPressed: () async {
                                        await Game.instance.deleteList();
                                        timer.cancel();
                                        Helpers.timer.cancel();
                                        Navigator.of(context).pop();
                                        setState(() {});
                                      },
                                    )
                                  ],
                                );
                              });
                          setState(() {});

                        }),
                ],
              );
            }
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Es ist ein Fehler aufgetreten"),
            );
          } else {
            return Center(
              child: CupertinoButton(
                child: const Text("Bitte melde dich erst an"),
                onPressed: () {
                  _showAccountInfo(context);
                },
              ),
            );
          }
        },
      ),
    );
  }

  List<Widget> getListMinusHead() {
    List<Widget> temp = getList();
    for (var element in temp) {
      (element as Column).children[0] =
          Opacity(opacity: 0.0, child: element.children[0]);
    }
    return temp;
  }

  List<Widget> getList() {
    List<Widget> temp = [getRoundColumn(Game.instance)];
    int indicator = 0;
    for (var player in Game.instance.players) {
      temp.add(getPlayerColumn(player, indicator));
      indicator++;
    }
    return temp;
  }

  double spacing = 15.0;

  TextStyle getListHeadline(BuildContext context, bool geber) {
    return TextStyle(
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.underline,
      fontSize: 16,
      color: geber
          ? PersistentData.getActive()
          : Theme.of(context).colorScheme.onBackground,
    );
  }

  Column getRoundColumn(Game g) {
    List<Widget> temp = [
      Text(
        "Runde",
        style: getListHeadline(context, false),
      ),
      SizedBox(
        height: spacing,
      )
    ];
    for (int i = 0; i < Game.instance.currentRound; i++) {
      temp.add(Text(
        "$i",
        style: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ));
      temp.add(SizedBox(
        height: spacing,
      ));
    }
    return Column(
      children: temp,
    );
  }

  Column getPlayerColumn(Player p, int indicator) {
    var b = Game.instance;
    List<Widget> temp = [
      Text(
        p.getName(),
        style: getListHeadline(
            context,
            ((((Game.instance.currentRound - 1) % 4) == indicator) &&
                    !(Game.instance.currentRound - 1 >=
                        Game.instance.maxRounds))
                ? true
                : false),
      ),
      SizedBox(
        height: spacing,
      ),
    ];
    for (int i = 0; i < Game.instance.currentRound; i++) {
      temp.add(Text(
        "${p.getAllPoints()[i]}",
        style: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ));
      temp.add(SizedBox(
        height: spacing,
      ));
    }

    return Column(
      children: temp,
    );
  }

  TextEditingController player1 = TextEditingController();
  TextEditingController player2 = TextEditingController();
  TextEditingController player3 = TextEditingController();
  TextEditingController player4 = TextEditingController();

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
            child: ListView(
              controller: controller,
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
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Center(
                          child: Text(
                        "3 Mitspieler auswählen",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                      )),
                    ),
                    StatefulBuilder(
                        builder: (BuildContext bc, StateSetter friendState) {
                      Widget getFriend(Friend f) {
                        return GestureDetector(
                          child: Container(
                            alignment: Alignment.topLeft,
                            width: MediaQuery.of(context).size.width,
                            child: Text(f.name),
                            margin: const EdgeInsets.all(15),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color:
                                    activated[f]! ? Colors.green : Colors.red,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                          ),
                          onTap: () {
                            activated.update(f, (value) {
                              if (!value && _playerCount < 3) {
                                _playerCount++;
                                return !value;
                              } else if (value) {
                                _playerCount--;
                                return !value;
                              } else {
                                return value;
                              }
                            });

                            friendState(() {
                              activated.forEach((key, value) {
                                if (key.name.contains("Extra 1") && value) {
                                  extra1 = true;
                                } else if (key.name.contains("Extra 1") &&
                                    !value) {
                                  extra1 = false;
                                } else if (key.name.contains("Extra 2") &&
                                    value) {
                                  extra2 = true;
                                } else if (key.name.contains("Extra 2") &&
                                    !value) {
                                  extra2 = false;
                                } else if (key.name.contains("Extra 3") &&
                                    value) {
                                  extra3 = true;
                                } else if (key.name.contains("Extra 3") &&
                                    !value) {
                                  extra3 = false;
                                }
                              });
                            });
                          },
                        );
                      }

                      return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            for (Friend friend in AppUser.instance.friends)
                              getFriend(friend),
                          ]);
                    }),
                    CupertinoButton(
                        child: Text(
                          "Starten",
                          style: Helpers.getButtonStyle(context),
                        ),
                        onPressed: () async {
                          init = false;
                          if (_playerCount != 3) {
                            notEnoughPlayers(context);
                            return;
                          }
                          if (extra1 || extra2 || extra3) {
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
                          self.uid = FirebaseAuth.instance.currentUser!.uid;
                          Game.instance.players.add(self);
                          Game.instance.date = DateTime.now()
                              .toIso8601String()
                              .substring(0, 16)
                              .replaceAll("T", " ");
                          if (extra1) {
                            Game.instance.players
                                .add(Player(Game.instance.names[0]));
                          }
                          if (extra2) {
                            Game.instance.players
                                .add(Player(Game.instance.names[1]));
                          }
                          if (extra3) {
                            Game.instance.players
                                .add(Player(Game.instance.names[2]));
                          }
                          for (Friend f in activated.keys) {
                            if (activated[f]! && !f.name.contains("Extra")) {
                              Player p = Player(f.name);
                              p.uid = f.uid;
                              Game.instance.players.add(p);
                            }
                          }
                          Runde.instance.init();
                          Game.instance.saveList(context);
                          listNameController.text = "";
                          Navigator.of(context).pop();
                          init = true;
                          setState(() {});
                        }),
                  ],
                ),
              ],
            ),
          );
        });
  }

  void _showPlayerInput(BuildContext context) {
    _playerCount = 0;
    showModalBottomSheet(
        backgroundColor: Theme.of(context).colorScheme.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        isScrollControlled: true,
        constraints: BoxConstraints.tight(
            Size.fromHeight(MediaQuery.of(context).size.height * 0.85)),
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
                              color: Theme.of(context).colorScheme.primary,
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
                              color: Theme.of(context).colorScheme.primary,
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
      backgroundColor: Theme.of(context).colorScheme.background,
      title: Text(
        "Bitte gebe die Spielernamen ein",
        style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
      ),
      content: SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
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
            color: Theme.of(context).colorScheme.primary,
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
            color: Theme.of(context).colorScheme.primary,
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
              color: Theme.of(context).colorScheme.primary,
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
}
