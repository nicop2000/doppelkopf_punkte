import 'package:doppelkopf_punkte/helper/enviroment_variables.dart';
import 'package:doppelkopf_punkte/helper/helper.dart';
import 'package:doppelkopf_punkte/helper/persistent_data.dart';
import 'package:doppelkopf_punkte/model/game.dart';
import 'package:doppelkopf_punkte/model/player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class CurrentList extends StatefulWidget {
  const CurrentList({Key? key}) : super(key: key);

  @override
  _CurrentListState createState() => _CurrentListState();
}

class _CurrentListState extends State<CurrentList> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        if (context.watch<Game>().gameEnd())
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
        if (!(context.watch<Game>().currentRound - 1 >=
            context.watch<Game>().maxRounds))
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Center(
              child: Text(
                "Noch ${context.watch<Game>().maxRounds + 1 - context.watch<Game>().currentRound} Runden",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        if (context.watch<Game>().currentRound > 1)
          if (!EnviromentVariables.review)
            CupertinoButton(
                child: Text(
                  "Letzten Eintrag löschen",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                onPressed: () {
                  context.read<Game>().deleteRound(context);
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
                context.read<Game>().reset();
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
                await context.read<Game>().pauseList(context);
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
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          CupertinoDialogAction(
                            child: const Text("Ja"),
                            onPressed: () async {
                              await context.read<Game>().deleteList(context);
                              Navigator.of(context).pop();
                              // setState(() {}); //TDSEST
                            },
                          )
                        ],
                      );
                    });
                setState(() {});
              }),
        if (!context.watch<Game>().shared)
          CupertinoButton(
            onPressed: () {
              context.read<Game>().shared = true;
              context.read<Game>().saveList(context);
              showCupertinoDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CupertinoAlertDialog(
                      title: const Text("Code"),
                      content: Text(
                          "Diesen Code müssen deine Freunde eingeben, um auf ihrem Gerät mitarbeiten zu könnnen: ${context.watch<Game>().id}"),
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
              "Code für Zusammenarbeit: ${context.watch<Game>().id}",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ),
        if (context.watch<Game>().shared && !context.watch<Game>().gameEnd())
          CupertinoButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Gemeinsame Liste aktualisieren"),
                  Icon(
                    Icons.refresh,
                    color: context.watch<PersistentData>().getPrimaryColor(),
                  )
                ],
              ),
              onPressed: () async {
                await context
                    .read<Game>()
                    .getTogetherList(context.read<Game>().id, context);
                await context.read<Game>().saveList(context);
              }),
        if (context.watch<Game>().currentRound - 1 >=
                context.watch<Game>().maxRounds &&
            context.watch<Game>().players[0].uid != "null")
          CupertinoButton(
              child: Text(
                  "Punkte für ${context.watch<Game>().players[0].getName()} in Datenbank übertragen & speichern"),
              onPressed: () {
                context
                    .read<Game>()
                    .sendListToDB(context.read<Game>().players[0].uid, context);
              }),
        if (context.watch<Game>().currentRound - 1 >=
                context.watch<Game>().maxRounds &&
            context.watch<Game>().players[1].uid != "null")
          CupertinoButton(
              child: Text(
                  "Punkte für ${context.watch<Game>().players[1].getName()} in Datenbank übertragen & speichern"),
              onPressed: () {
                context
                    .read<Game>()
                    .sendListToDB(context.read<Game>().players[1].uid, context);
              }),
        if (context.watch<Game>().currentRound - 1 >=
                context.watch<Game>().maxRounds &&
            context.watch<Game>().players[2].uid != "null")
          CupertinoButton(
              child: Text(
                  "Punkte für ${context.watch<Game>().players[2].getName()} in Datenbank übertragen & speichern"),
              onPressed: () {
                context
                    .read<Game>()
                    .sendListToDB(context.read<Game>().players[2].uid, context);
              }),
        if (context.watch<Game>().currentRound - 1 >=
                context.watch<Game>().maxRounds &&
            context.watch<Game>().players[3].uid != "null")
          CupertinoButton(
              child: Text(
                  "Punkte für ${context.watch<Game>().players[3].getName()} in Datenbank übertragen & speichern"),
              onPressed: () {
                context
                    .read<Game>()
                    .sendListToDB(context.read<Game>().players[3].uid, context);
              }),
        if (context.watch<Game>().currentRound - 1 >=
            context.watch<Game>().maxRounds)
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
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          CupertinoDialogAction(
                            child: const Text("Ja"),
                            onPressed: () async {
                              await context.read<Game>().deleteList(context);
                              Navigator.of(context).pop();
                              // setState(() {}); //TDSEST
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

  List<Widget> getListMinusHead() {
    List<Widget> temp = getList();
    for (var element in temp) {
      (element as Column).children[0] =
          Opacity(opacity: 0.0, child: element.children[0]);
    }
    return temp;
  }

  List<Widget> getList() {
    List<Widget> temp = [getRoundColumn(context.read<Game>())];
    int indicator = 0;
    for (var player in context.read<Game>().players) {
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
          ? context.watch<PersistentData>().getActive()
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
    for (int i = 0; i < context.read<Game>().currentRound; i++) {
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
    List<Widget> temp = [
      Text(
        p.getName(),
        style: getListHeadline(
            context,
            ((((context.read<Game>().currentRound - 1) % 4) == indicator) &&
                    !(context.read<Game>().currentRound - 1 >=
                        context.read<Game>().maxRounds))
                ? true
                : false),
      ),
      SizedBox(
        height: spacing,
      ),
    ];
    for (int i = 0; i < context.read<Game>().currentRound; i++) {
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
}
