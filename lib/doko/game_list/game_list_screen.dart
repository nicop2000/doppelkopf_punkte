import 'dart:async';
import 'dart:developer';

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

class GameListScreen extends StatefulWidget {
  const GameListScreen({Key? key}) : super(key: key);

  @override
  State<GameListScreen> createState() => _GameListScreenState();
}

class _GameListScreenState extends State<GameListScreen> {
  Map<Friend, bool> activated = {};


  @override
  void initState() {
    log("INIT LIST SCREEN");
    super.initState();
  }

  @override
  void dispose() {
    log("DISPOSE LIST SCREEN");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: context.watch<AppUser>().user != null
          ? context.watch<Game>().players.isEmpty
              ? const NoCurrentList()
              : const CurrentList()
          : Center(
              child: CupertinoButton(
                child: const Text("Klicke hier um dich anzumelden oder zu registrieren"),
                onPressed: () {
                  showCupertinoDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return CupertinoAlertDialog(
                        title: const Text("Hast du bereits ein Konto?"),
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
