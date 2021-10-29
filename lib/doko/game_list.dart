import 'package:doppelkopf_punkte/helper/constants.dart';
import 'package:doppelkopf_punkte/helper/enviroment_variables.dart';
import 'package:doppelkopf_punkte/model/friend.dart';
import 'package:doppelkopf_punkte/model/game.dart';
import 'package:doppelkopf_punkte/model/player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GameList extends StatefulWidget {
  const GameList({Key? key}) : super(key: key);

  @override
  State<GameList> createState() => _GameListState();
}

class _GameListState extends State<GameList> {
  final _namesKey = GlobalKey<FormState>();
  Map<Friend, bool> activated = {};
  int _playerCount = 0;

  @override
  Widget build(BuildContext context) {
    if (Env.players.isEmpty) {
      return Center(
        child: Column(
          children: [
            CupertinoButton(
              onPressed: () {
                _showPlayerInput(context);
                setState(() {});
              },
              child: Text("Neue Liste beginnen ${DateTime.now()}"),
            ),
          ],
        ),
      );
    } else {
      return Row(
        children: getList(),
      );
    }
  }

  List<Widget> getList() {
    List<Widget> temp = roundsToColumn(Env.game);
    Env.players.forEach((player) {
      temp.add(Column(
        children: scoreToColumn(player),
      ));
    });
    return temp;
  }

  List<Widget> roundsToColumn(Game g) {
    List<Widget> temp = [];
    for(int i = 0; i < g.currentRound; i++) {
        temp.add(Text("$i"));
    }
    return temp;
  }

  List<Widget> scoreToColumn(Player player) {
    List<Widget> temp = [Text(player.getName())];
    player.getAllPoints().forEach((score) {
      temp.add(Text("$score"));
    });
    return temp;
  }

  Widget buildSheet() {
    TextEditingController player1 = TextEditingController();
    TextEditingController player2 = TextEditingController();
    TextEditingController player3 = TextEditingController();
    TextEditingController player4 = TextEditingController();
    bool extra1 = false;
    bool extra2 = false;
    bool extra3 = false;
    for (Friend f in Env.friends) {
      activated.addAll({f: false});
    }
    final textController = [player1, player2, player3, player4];
    return DraggableScrollableSheet(
        initialChildSize: 1,
        builder: (_, controller) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.85,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListView(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      IconButton(
                        tooltip: "Schließen",
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          CupertinoIcons.clear_circled,
                          color: Constants.mainBlue,
                        ),
                      ),
                    ],
                  ),
                  Form(
                    key: _namesKey,
                    child: Column(
                      children: [
                        StatefulBuilder(builder:
                            (BuildContext bc, StateSetter friendState) {
                          Widget getFriend(Friend f) {
                            return GestureDetector(
                              child: Container(
                                child: Text(f.name),
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: activated[f]!
                                        ? Colors.green
                                        : Colors.red,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                              ),
                              onTap: () {
                                activated.update(f, (value) {
                                  print(value);
                                  if (!value && _playerCount < 4) {
                                    _playerCount++;
                                    return !value;
                                  } else if (value) {
                                    _playerCount--;
                                    return !value;
                                  } else {
                                    return value;
                                  }
                                });
                                print(activated);

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
                                    decoration: const InputDecoration(
                                      errorMaxLines: 3,
                                      hintText: "Spielernamen eingeben",
                                      hintStyle: TextStyle(
                                        color: Constants.mainGreyHint,
                                      ),
                                      labelText: "Spieler 1",
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Constants.mainGrey),
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
                                    decoration: const InputDecoration(
                                      errorMaxLines: 3,
                                      hintText: "Spielernamen eingeben",
                                      hintStyle: TextStyle(
                                        color: Constants.mainGreyHint,
                                      ),
                                      labelText: "Spieler 2",
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Constants.mainGrey),
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
                                    decoration: const InputDecoration(
                                      errorMaxLines: 3,
                                      hintText: "Spielernamen eingeben",
                                      hintStyle: TextStyle(
                                        color: Constants.mainGreyHint,
                                      ),
                                      labelText: "Spieler 3",
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Constants.mainGrey),
                                      ),
                                    ),
                                  ),
                              ]);
                        }),
                        CupertinoButton(
                            child: const Text("Los"),
                            onPressed: () {
                              if (_namesKey.currentState!.validate()) {
                                if (extra1) {
                                  Env.players.add(Player(player1.text));
                                }
                                if (extra2) {
                                  Env.players.add(Player(player2.text));
                                }
                                if (extra3) {
                                  Env.players.add(Player(player3.text));
                                }
                                activated.forEach((friend, player) {
                                  if (player &&
                                      !friend.name.contains("Extra")) {
                                    Player p = Player(friend.name);
                                    p.uid = friend.uid;
                                    Env.players.add(p);
                                  }
                                });

                                Env.players.forEach((element) {});
                                for (Player p in Env.players) {
                                  Env.activatedPlayed.addAll({p: false});
                                }
                                for (Player p in Env.players) {
                                  Env.wonPoints.addAll({p: false});
                                }

                                for (punkte p in punkte.values) {
                                  Env.winnerPoints.addAll({p: false});
                                }
                                Navigator.of(context).pop();
                                setState(() {});
                              }
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _showPlayerInput(BuildContext context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      isScrollControlled: true,
      context: context,
      builder: (context) => buildSheet(),
    );
  }
}

/*
if(extra1)
                          TextFormField(
                            controller: player1,
                            validator: (name) {
                              return name!.isEmpty
                                  ? "Bitte einen Spielernamen eingeben"
                                  : null;
                            },
                            decoration: const InputDecoration(
                              errorMaxLines: 3,
                              hintText: "Spielernamen eingeben",
                              hintStyle: TextStyle(
                                color: Constants.mainGreyHint,
                              ),
                              labelText: "Spieler 1",
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Constants.mainGrey),
                              ),
                            ),
                          ),
                          if(extra2)
                          TextFormField(
                            controller: player2,
                            validator: (name) {
                              return name!.isEmpty
                                  ? "Bitte einen Spielernamen eingeben"
                                  : null;
                            },
                            decoration: const InputDecoration(
                              errorMaxLines: 3,
                              hintText: "Spielernamen eingeben",
                              hintStyle: TextStyle(
                                color: Constants.mainGreyHint,
                              ),
                              labelText: "Spieler 2",
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Constants.mainGrey),
                              ),
                            ),
                          ),
                          if(extra3)
                          TextFormField(
                            controller: player4,
                            validator: (name) {
                              return name!.isEmpty
                                  ? "Bitte einen Spielernamen eingeben"
                                  : null;
                            },
                            decoration: const InputDecoration(
                              errorMaxLines: 3,
                              hintText: "Spielernamen eingeben",
                              hintStyle: TextStyle(
                                color: Constants.mainGreyHint,
                              ),
                              labelText: "Spieler 4",
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Constants.mainGrey),
                              ),
                            ),
                          ),
 */
