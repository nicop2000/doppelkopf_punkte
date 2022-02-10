import 'package:doppelkopf_punkte/doko/graph.dart';
import 'package:doppelkopf_punkte/helper/constants.dart';
import 'package:doppelkopf_punkte/helper/helper.dart';
import 'package:doppelkopf_punkte/model/game.dart';
import 'package:doppelkopf_punkte/model/player.dart';
import 'package:doppelkopf_punkte/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class SavedLists extends StatefulWidget {
  const SavedLists({Key? key}) : super(key: key);

  @override
  _SavedListsState createState() => _SavedListsState();
}

class _SavedListsState extends State<SavedLists> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Stream<User?> firebaseStream = FirebaseAuth.instance.authStateChanges();
    return StreamBuilder(
        stream: firebaseStream,
        builder: (BuildContext bc, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasData) {
            return Stack(children: [
              Container(
                color: Theme.of(context).colorScheme.background,
              ),
              SingleChildScrollView(
                child: Column(
                  children: formLists(),
                ),
              ),
            ]);
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
              "Es ist ein Fehler aufgetreten",
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onBackground),
            ));
          } else {
            return Center(
                child: Text(
              "Bitte melde dich erst an, damit deine archivierten Listen geladen werden können.",
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onBackground),
            ));
          }
        });
  }

  SizedBox getSpacing() {
    return const SizedBox(
      height: 15.0,
    );
  }

  TextStyle getListStyle() {
    return TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w300,
      color: Theme.of(context).colorScheme.onBackground,
    );
  }

  TextStyle getHeadStyle() {
    return TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: Theme.of(context).colorScheme.onBackground,
    );
  }

  List<Widget> formLists() {
    List<Widget> tempWidget = [];
    if (AppUser.instance.archivedLists.isEmpty) {
      tempWidget.add(const Text("Du hast keine archivierten Listen"));
      return tempWidget;
    }

    for (var game in AppUser.instance.archivedLists) {
      tempWidget.add(
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                game.listname,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
            Row(
              children: [
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("", style: getHeadStyle()),
                    getSpacing(),
                    Text("Gewonnen", style: getHeadStyle()),
                    getSpacing(),
                    Text("Verloren", style: getHeadStyle()),
                    getSpacing(),
                    Text("Solos", style: getHeadStyle()),
                    getSpacing(),
                    Text("Gesamtpunkte", style: getHeadStyle()),
                    getSpacing(),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    Text(
                      game.players[0].getName(),
                      style: getHeadStyle(),
                    ),
                    getSpacing(),
                    Text("${game.players[0].getWon()}", style: getListStyle()),
                    getSpacing(),
                    Text("${game.players[0].getLost()}", style: getListStyle()),
                    getSpacing(),
                    Text("${game.players[0].getSolo()}", style: getListStyle()),
                    getSpacing(),
                    Text("${game.players[0].getLastScore()}",
                        style: getListStyle()),
                    getSpacing(),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    Text(
                      game.players[1].getName(),
                      style: getHeadStyle(),
                    ),
                    getSpacing(),
                    Text("${game.players[1].getWon()}", style: getListStyle()),
                    getSpacing(),
                    Text("${game.players[1].getLost()}", style: getListStyle()),
                    getSpacing(),
                    Text("${game.players[1].getSolo()}", style: getListStyle()),
                    getSpacing(),
                    Text("${game.players[1].getLastScore()}",
                        style: getListStyle()),
                    getSpacing(),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    Text(
                      game.players[2].getName(),
                      style: getHeadStyle(),
                    ),
                    getSpacing(),
                    Text("${game.players[2].getWon()}", style: getListStyle()),
                    getSpacing(),
                    Text("${game.players[2].getLost()}", style: getListStyle()),
                    getSpacing(),
                    Text("${game.players[2].getSolo()}", style: getListStyle()),
                    getSpacing(),
                    Text("${game.players[2].getLastScore()}",
                        style: getListStyle()),
                    getSpacing(),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    Text(
                      game.players[3].getName(),
                      style: getHeadStyle(),
                    ),
                    getSpacing(),
                    Text("${game.players[3].getWon()}", style: getListStyle()),
                    getSpacing(),
                    Text("${game.players[3].getLost()}", style: getListStyle()),
                    getSpacing(),
                    Text("${game.players[3].getSolo()}", style: getListStyle()),
                    getSpacing(),
                    Text("${game.players[3].getLastScore()}",
                        style: getListStyle()),
                    getSpacing(),
                  ],
                ),
                const Spacer(),
              ],
            ),
            CupertinoButton(
                child: const Text("Als Kreisdiagramm anzeigen"),
                onPressed: () async {
                  Map<String, double> dataMapWon = {
                    game.players[0].getName():
                        game.players[0].getWon().toDouble(),
                    game.players[1].getName():
                        game.players[1].getWon().toDouble(),
                    game.players[2].getName():
                        game.players[2].getWon().toDouble(),
                    game.players[3].getName():
                        game.players[3].getWon().toDouble(),
                  };
                  Map<String, double> dataMapLost = {
                    game.players[0].getName():
                        game.players[0].getLost().toDouble(),
                    game.players[1].getName():
                        game.players[1].getLost().toDouble(),
                    game.players[2].getName():
                        game.players[2].getLost().toDouble(),
                    game.players[3].getName():
                        game.players[3].getLost().toDouble(),
                  };
                  Map<String, double> dataMapSolo = {
                    game.players[0].getName():
                        game.players[0].getSolo().toDouble(),
                    game.players[1].getName():
                        game.players[1].getSolo().toDouble(),
                    game.players[2].getName():
                        game.players[2].getSolo().toDouble(),
                    game.players[3].getName():
                        game.players[3].getSolo().toDouble(),
                  };
                  showPie(
                      context,
                      "Gewonnene Spiele",
                      dataMapWon,
                      "Verlorene Spiele",
                      dataMapLost,
                      "Solospiele",
                      dataMapSolo);
                  setState(() {});
                }),
            CupertinoButton(
                child: const Text("Als Graph anzeigen"),
                onPressed: () async {
                  // pushNewScreen(context, screen: LineChartWidget(game));
                  showGraph(context, game);
                }),
            CupertinoButton(
                child: const Text("Diese Liste genauer betrachten"),
                onPressed: () async {
                  showListDetails(game);
                  setState(() {});
                }),
            CupertinoButton(
                child: const Text("Diese Liste löschen"),
                onPressed: () async {
                  await Constants.realtimeDatabase
                      .child(
                          'endedLists/${FirebaseAuth.instance.currentUser!.uid}/${game.listname}')
                      .remove();
                  await Helpers.getMyArchivedLists();
                  setState(() {});
                }),
          ],
        ),
      );
    }
    return tempWidget;
  }

  void showPie(BuildContext context, String textWon, dataMapWon,
      String textLost, dataMapLost, String textSolo, dataMapSolo) {
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
          return DraggableScrollableSheet(
              minChildSize: 0.9,
              initialChildSize: 1,
              builder: (_, controller) {
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ListView(controller: controller, children: [
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
                    PieChart(
                      dataMap: dataMapWon,
                      animationDuration: const Duration(milliseconds: 800),
                      centerText: textWon,
                      chartRadius: MediaQuery.of(context).size.width * 0.55,
                      chartLegendSpacing: 25,
                      chartType: ChartType.disc,
                      chartValuesOptions: const ChartValuesOptions(
                        decimalPlaces: 0,
                      ),
                      legendOptions: LegendOptions(
                        legendShape: BoxShape.circle,
                        showLegendsInRow: true,
                        legendPosition: LegendPosition.bottom,
                        legendTextStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    ),
                    PieChart(
                      dataMap: dataMapLost,
                      animationDuration: const Duration(milliseconds: 800),
                      centerText: textLost,
                      chartRadius: MediaQuery.of(context).size.width * 0.55,
                      chartLegendSpacing: 25,
                      chartType: ChartType.disc,
                      chartValuesOptions: const ChartValuesOptions(
                        decimalPlaces: 0,
                      ),
                      legendOptions: LegendOptions(
                        legendShape: BoxShape.circle,
                        showLegendsInRow: true,
                        legendPosition: LegendPosition.bottom,
                        legendTextStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    ),
                    PieChart(
                      dataMap: dataMapSolo,
                      animationDuration: const Duration(milliseconds: 800),
                      centerText: textSolo,
                      chartRadius: MediaQuery.of(context).size.width * 0.55,
                      chartLegendSpacing: 25,
                      chartType: ChartType.disc,
                      chartValuesOptions: const ChartValuesOptions(
                        decimalPlaces: 0,
                      ),
                      legendOptions: LegendOptions(
                        legendShape: BoxShape.circle,
                        showLegendsInRow: true,
                        legendPosition: LegendPosition.bottom,
                        legendTextStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    ),
                  ]),
                );
              });
        });
  }

  void showGraph(BuildContext context, Game game) {
    showModalBottomSheet(
        backgroundColor: Theme.of(context).colorScheme.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        isScrollControlled: true,
        constraints: BoxConstraints.tight(
            Size.fromHeight(MediaQuery.of(context).size.height * 0.95)),
        context: context,
        builder: (BuildContext bc) {
          return DraggableScrollableSheet(
              minChildSize: 0.9,
              initialChildSize: 1,
              builder: (_, controller) {
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
                Graph(game),
                  ],
                );

              });
        });
  }

  List<Widget> getList(Game game) {
    List<Widget> temp = [getRoundColumn(game)];
    for (var player in game.players) {
      temp.add(getPlayerColumn(player, game));
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

  Column getRoundColumn(Game game) {
    List<Widget> temp = [
      Text(
        "Runde",
        style: getListHeadline(context),
      ),
      SizedBox(
        height: spacing,
      )
    ];
    for (int i = 0; i < game.currentRound; i++) {
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

  Column getPlayerColumn(Player player, Game game) {
    List<Widget> temp = [
      Text(
        player.getName(),
        style: getListHeadline(context),
      ),
      SizedBox(
        height: spacing,
      ),
    ];
    for (int i = 0; i < game.currentRound; i++) {
      temp.add(Text(
        "${player.getAllPoints()[i]}",
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

  void showListDetails(Game game) {
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
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: getList(game),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
