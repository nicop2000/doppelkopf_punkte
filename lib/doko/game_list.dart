import 'package:doppelkopf_punkte/helper/constants.dart';
import 'package:doppelkopf_punkte/helper/enviroment_variables.dart';
import 'package:doppelkopf_punkte/helper/helper.dart';
import 'package:doppelkopf_punkte/helper/persistent_data.dart';
import 'package:doppelkopf_punkte/model/friend.dart';
import 'package:doppelkopf_punkte/model/game.dart';
import 'package:doppelkopf_punkte/model/player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class GameList extends StatefulWidget {
  const GameList({Key? key}) : super(key: key);

  @override
  State<GameList> createState() => _GameListState();
}

class _GameListState extends State<GameList> {
  final _namesKey = GlobalKey<FormState>();
  Map<Friend, bool> activated = {};
  int _playerCount = 0;
  int _rounds = 30;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).colorScheme.background,
        child: Env.game.players.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        "Rundenanzahl auswählen",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    NumberPicker(
                      minValue: 3,
                      maxValue: 120,
                      value: _rounds,
                      onChanged: (newMax) => setState(() => _rounds = newMax),
                      textStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 17),
                      selectedTextStyle: TextStyle(
                          color: PersistentData.getActive(),
                          fontSize: 30,
                          fontWeight: FontWeight.w600),
                    ),
                    CupertinoButton(
                      onPressed: () {
                        Env.game.setMaxRounds(_rounds);
                        _showPlayerInput(context);
                      },
                      child: Text(
                        "Neue Liste beginnen",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                    if (Env.prefs.containsKey('saved-points-0'))
                      CupertinoButton(
                        onPressed: () {
                          Helpers.restoreList();
                          setState(() {});
                        },
                        child: Text(
                          "Letzte Liste wiederherstellen",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                  ],
                ),
              )
            : ListView(
                children: [
                  if (Env.game.currentRound - 1 >= Env.game.maxRounds)
                    Padding(
                      padding: EdgeInsets.only(top: spacing),
                      child: Center(
                          child: Helpers.getQuestionnaireHeadline(
                              context, "Die Liste ist beendet")),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: getList(),
                    ),
                  ),
                  if (!(Env.game.currentRound - 1 >= Env.game.maxRounds))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Center(
                      child: Text("Noch ${Env.game.maxRounds + 1 - Env.game.currentRound} Runden", style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground, fontSize: 16, fontWeight: FontWeight.w400,
                      ),),
                    ),
                  ),
                  if (Env.game.currentRound > 1)
                    CupertinoButton(
                        // color: Theme.of(context).colorScheme.onPrimary,
                        child: Text(
                          "Letzten Eintrag löschen",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        onPressed: () {
                          Env.game.currentRound--;
                          for (var player in Env.game.players) {
                            player.removeLastRound();
                          }
                          Helpers.saveList();
                          setState(() {});
                        }),

                  CupertinoButton(
                      // color: Theme.of(context).colorScheme.onPrimary,
                      child: Text(
                        "Liste löschen",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      onPressed: () {
                        showAlertDialog(context);
                        setState(() {});
                      }),
                  if (Env.game.currentRound - 1 >= Env.game.maxRounds)
                    CupertinoButton(
                        child: Text(
                            "Punkte für ${Env.game.players[0].getName()} in Datenbank übertragen & speichern"),
                        onPressed: () {
                          Helpers.saveMyList(Env.game.players[0].uid);
                        }),
                  if (Env.game.currentRound - 1 >= Env.game.maxRounds)
                    CupertinoButton(
                        child: Text(
                            "Punkte für ${Env.game.players[1].getName()} in Datenbank übertragen & speichern"),
                        onPressed: () {
                          Helpers.saveMyList(Env.game.players[1].uid);
                        }),
                  if (Env.game.currentRound - 1 >= Env.game.maxRounds)
                    CupertinoButton(
                        child: Text(
                            "Punkte für ${Env.game.players[2].getName()} in Datenbank übertragen & speichern"),
                        onPressed: () {
                          Helpers.saveMyList(Env.game.players[2].uid);
                        }),
                  if (Env.game.currentRound - 1 >= Env.game.maxRounds)
                    CupertinoButton(
                        child: Text(
                            "Punkte für ${Env.game.players[3].getName()} in Datenbank übertragen & speichern"),
                        onPressed: () {
                          Helpers.saveMyList(Env.game.players[3].uid);
                        }),
                ],
              ));
  }

  showAlertDialog(BuildContext context) {
    Widget cancelButton = CupertinoButton(
      child: const Text("Nein"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = CupertinoButton(
      child: const Text("Ja"),
      onPressed: () {
        Helpers.deleteList();
        Navigator.of(context).pop();
        setState(() {});
      },
    );
    AlertDialog alert = AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      title: Text(
        "Warnung",
        style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
      ),
      content: Text("Soll die Liste wirklich gelöscht werden?",
          style: TextStyle(color: Theme.of(context).colorScheme.onBackground)),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  List<Widget> getList() {
    List<Widget> temp = [getRoundColumn(Env.game)];
    for (var player in Env.game.players) {
      temp.add(getPlayerColumn(player));
    }
    return temp;
  }

  double spacing = 15.0;

  TextStyle getListHeadline(BuildContext context) {
    return TextStyle(
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.underline,
      fontSize: 16,
      color: Theme.of(context).colorScheme.onBackground,
    );
  }

  Column getRoundColumn(Game g) {
    List<Widget> temp = [
      Text(
        "Runde",
        style: getListHeadline(context),
      ),
      SizedBox(
        height: spacing,
      )
    ];
    for (int i = 0; i < Env.game.currentRound; i++) {
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

  Column getPlayerColumn(Player p) {
    List<Widget> temp = [
      Text(
        p.getName(),
        style: getListHeadline(context),
      ),
      SizedBox(
        height: spacing,
      ),
    ];
    for (int i = 0; i < Env.game.currentRound; i++) {
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

  Widget buildSheet() {
    bool extra1 = false;
    bool extra2 = false;
    bool extra3 = false;
    for (Friend f in Env.friends) {
      activated.addAll({f: false});
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
                Form(
                  key: _namesKey,
                  child: Column(
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
                              for (Friend friend in Env.friends)
                                getFriend(friend),
                              if (extra1)
                                TextFormField(
                                  controller: player1,
                                  validator: (name) {
                                    return name!.isEmpty
                                        ? "Bitte einen Spielernamen eingeben"
                                        : null;
                                  },
                                  decoration: InputDecoration(
                                    errorMaxLines: 3,
                                    hintText: "Spielernamen eingeben",
                                    hintStyle: const TextStyle(
                                      color: Constants.mainGreyHint,
                                    ),
                                    labelStyle: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    labelText: "Spieler 1",
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Constants.mainGrey),
                                    ),
                                  ),
                                ),
                              if (extra2)
                                TextFormField(
                                  controller: player2,
                                  validator: (name) {
                                    return name!.isEmpty
                                        ? "Bitte einen Spielernamen eingeben"
                                        : null;
                                  },
                                  decoration: InputDecoration(
                                    errorMaxLines: 3,
                                    hintText: "Spielernamen eingeben",
                                    hintStyle: const TextStyle(
                                      color: Constants.mainGreyHint,
                                    ),
                                    labelStyle: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    labelText: "Spieler 2",
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Constants.mainGrey),
                                    ),
                                  ),
                                ),
                              if (extra3)
                                TextFormField(
                                  controller: player3,
                                  validator: (name) {
                                    return name!.isEmpty
                                        ? "Bitte einen Spielernamen eingeben"
                                        : null;
                                  },
                                  decoration: InputDecoration(
                                    errorMaxLines: 3,
                                    hintText: "Spielernamen eingeben",
                                    hintStyle: const TextStyle(
                                      color: Constants.mainGreyHint,
                                    ),
                                    labelStyle: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    labelText: "Spieler 3",
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Constants.mainGrey),
                                    ),
                                  ),
                                ),
                            ]);
                      }),
                      CupertinoButton(
                          child: Text(
                            "Starten",
                            style: Helpers.getButtonStyle(context),
                          ),
                          onPressed: () {
                            if (_playerCount != 3) {
                              notEnoughPlayers(context);
                              return;
                            }
                            String name =
                                FirebaseAuth.instance.currentUser!.displayName!;
                            Player self = Player(name);
                            self.uid = FirebaseAuth.instance.currentUser!.uid;
                            Env.game.players.add(self);
                            if (_namesKey.currentState!.validate()) {
                              if (extra1) {
                                Env.game.players.add(Player(player1.text));
                              }
                              if (extra2) {
                                Env.game.players.add(Player(player2.text));
                              }
                              if (extra3) {
                                Env.game.players.add(Player(player3.text));
                              }
                              activated.forEach((friend, player) {
                                if (player && !friend.name.contains("Extra")) {
                                  Player p = Player(friend.name);
                                  p.uid = friend.uid;
                                  Env.game.players.add(p);
                                }
                              });

                              for (Player p in Env.game.players) {
                                Env.activatedPlayed.addAll({p: false});
                              }
                              for (Player p in Env.game.players) {
                                Env.wonPoints.addAll({p: false});
                              }

                              for (punkte p in punkte.values) {
                                Env.winnerPoints.addAll({p: false});
                              }

                              Env.controller.sink.add("Players chosen");

                              Navigator.of(context).pop();
                              setState(() {});
                            }
                          }),
                    ],
                  ),
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
                          onPressed: () {},
                        ),
                      ),
                    ],
                  );
                }
              });
        });
  }

  void notEnoughPlayers(BuildContext context) {
    Widget okButton = CupertinoButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      title: Text(
        "Zu wenig Spieler ausgewählt",
        style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
      ),
      content: Text("Es müssen 3 Spieler ausgewählt (grün hinterlegt) sein",
          style: TextStyle(color: Theme.of(context).colorScheme.onBackground)),
      actions: [okButton],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
