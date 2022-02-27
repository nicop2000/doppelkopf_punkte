import 'package:doppelkopf_punkte/doko/friends_management.dart';
import 'package:doppelkopf_punkte/helper/constants.dart';
import 'package:doppelkopf_punkte/helper/enviroment_variables.dart';
import 'package:doppelkopf_punkte/helper/helper.dart';
import 'package:doppelkopf_punkte/model/user.dart';
import 'package:doppelkopf_punkte/usersPage/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:provider/provider.dart';

import '../scanner.dart';

class AccountInfo extends StatelessWidget {
  const AccountInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Accountinformationen",
          style: TextStyle(color: Theme.of(context).colorScheme.background),
        ),
      ),
      body: context.watch<AppUser>().user != null
          ? SizedBox(
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
                                if (await Helpers.authenticate(context)) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => const Settings()));
                                }
                              },
                              icon: Icon(
                                CupertinoIcons.settings_solid,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            Text(
                              "Einstellungen",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  fontSize: 8),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            IconButton(
                              tooltip: "Alle lokalen Daten löschen",
                              color: Theme.of(context).colorScheme.primary,
                              onPressed: () async {
                                if (await Helpers.authenticate(context)) {
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
                                                  context
                                                      .read<AppUser>()
                                                      .logoutRoutine();
                                                  Navigator.of(context).pop();
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
                            Text(
                              "Lokales löschen",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  fontSize: 8),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            IconButton(
                              tooltip: "Alle Daten löschen",
                              color: Theme.of(context).colorScheme.primary,
                              onPressed: () async {
                                if (await Helpers.authenticate(context)) {
                                  showCupertinoDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        TextEditingController pw = TextEditingController();
                                        return CupertinoAlertDialog(
                                          title: const Text("Achtung"),
                                          content: Column(
                                            children: [
                                              const Text(
                                                  "Du bist im Begriff, alle deine Daten zu löschen. "
                                                      "Das beinhaltet sämtliche lokalen Speicher als auch die Online-Daten und dein Konto. "
                                                      "Willst du wirklich fortfahren? (Kann nicht rückgängig gemacht werden)"
                                                      "Bitte gib hierzu zur Sicherheit dein Passwort ein:"),
                                              CupertinoTextField(
                                                autocorrect: false,
                                                controller: pw,
                                                obscureText: true,
                                              )
                                            ],
                                          ),

                                          actions: <Widget>[
                                            CupertinoDialogAction(
                                                child: const Text("Ja"),
                                                onPressed: () async {
                                                  bool result = false;
                                                  result = await Helpers.validatePassword(pw.text);
                                                  if (result) {
                                                    EnviromentVariables.prefs
                                                        .clear();
                                                    await Constants
                                                        .realtimeDatabase
                                                        .child(
                                                        'friends/${FirebaseAuth.instance.currentUser!.uid}')
                                                        .remove();
                                                    FirebaseAuth
                                                        .instance.currentUser!
                                                        .delete();
                                                    context
                                                        .read<AppUser>()
                                                        .logoutRoutine();
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).pop();
                                                  } else {
                                                    pw.text = "";
                                                    await showCupertinoDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return CupertinoAlertDialog(
                                                            title: const Text(":c"),
                                                            content: Column(
                                                              children: const [
                                                                Text("Das war wohl nix!"),
                                                              ],
                                                            ),
                                                            actions: <Widget>[
                                                              CupertinoDialogAction(
                                                                child: const Text("OK"),
                                                                onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        });
                                                  }

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
                            Text(
                              "Alles löschen",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  fontSize: 8),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            IconButton(
                              tooltip: "Freunde verwalten",
                              color: Theme.of(context).colorScheme.primary,
                              onPressed: () async {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => const FriendsManagement()));
                              },
                              icon: Icon(
                                CupertinoIcons.rectangle_stack_person_crop,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            Text(
                              "Freunde verwalten",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  fontSize: 8),
                            ),
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
                                  context.read<AppUser>().logoutRoutine();
                                  Navigator.of(context).pop();
                                }),
                            Text(
                              "Ausloggen",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  fontSize: 8),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      "Name: ${context.read<AppUser>().user?.displayName}",
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                    Text(
                      "E-Mail: ${context.read<AppUser>().user?.email}",
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "UID: ${context.read<AppUser>().user?.uid}",
                          style: TextStyle(
                              fontSize: 16,
                              color:
                                  Theme.of(context).colorScheme.onBackground),
                        ),
                        Text(
                          "(Kann zur Authentifizierung gegenüber dem Admin verwendet werden)",
                          style: TextStyle(
                              fontSize: 8,
                              color:
                                  Theme.of(context).colorScheme.onBackground),
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
                                "DOKO§${context.read<AppUser>().user?.uid}:${context.read<AppUser>().user?.displayName}",
                            size: 200,
                            foregroundColor:
                                Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                        Text(
                          "QR-Code für Freundefunktion",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
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
                                color: Theme.of(context).colorScheme.primary,
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
            )
          : const Center(
              child: Text(
                  "Dieser Text sollte eigentlich niemals sichtbar sein :c"),
            ),
    );
  }
}
