import 'dart:async';

import 'package:doppelkopf_punkte/doko/game_list/current_list.dart';
import 'package:doppelkopf_punkte/doko/game_list/no_current_list.dart';
import 'package:doppelkopf_punkte/helper/constants.dart';
import 'package:doppelkopf_punkte/helper/helper.dart';
import 'package:doppelkopf_punkte/model/friend.dart';
import 'package:doppelkopf_punkte/model/game.dart';
import 'package:doppelkopf_punkte/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameList extends StatefulWidget {
  const GameList({Key? key}) : super(key: key);

  @override
  State<GameList> createState() => _GameListState();
}

class _GameListState extends State<GameList> {
  Map<Friend, bool> activated = {};

  var timer = Timer(Duration(days: 2), () {});

  @override
  void initState() {
    // if (context.watch<Game>().shared) {
    // timer = Timer.periodic(Constants.refreshList, (timer) { //TODO: LOGIK NEU MACHEN
    //   print("SET");
    //   setState(() {});
    // });
    // }
    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    // if (timer.isActive) timer.cancel(); //TODO
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: context.watch<AppUser>().loggedIn
          ? context.watch<Game>().players.isEmpty
              ? const NoCurrentList()
              : const CurrentList()
          : Center(
              child: CupertinoButton(
                child: const Text("Bitte melde dich erst an"),
                onPressed: () {
                  showCupertinoDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return CupertinoAlertDialog(
                        title: const Text("Bitte wähle eine Option aus"),
                        actions: [
                          CupertinoDialogAction(
                            child: const Text("Login"),
                            onPressed: () => Navigator.of(context)
                                .popAndPushNamed("${routers.login}"),
                          ),
                          CupertinoDialogAction(
                            child: const Text("Registrieren"),
                            onPressed: () => Navigator.of(context)
                                .popAndPushNamed("${routers.register}"),
                          )
                        ],
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}
