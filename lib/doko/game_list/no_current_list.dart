

import 'package:doppelkopf_punkte/helper/constants.dart';
import 'package:doppelkopf_punkte/helper/enviroment_variables.dart';
import 'package:doppelkopf_punkte/helper/helper.dart';
import 'package:doppelkopf_punkte/helper/persistent_data.dart';
import 'package:doppelkopf_punkte/model/game.dart';
import 'package:doppelkopf_punkte/model/user.dart';
import 'package:doppelkopf_punkte/doko/game_list/player_management.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/src/provider.dart';

class NoCurrentList extends StatefulWidget {
  const NoCurrentList({Key? key}) : super(key: key);

  @override
  State<NoCurrentList> createState() => _NoCurrentListState();
}

class _NoCurrentListState extends State<NoCurrentList> {
  final _workTogetherKey = GlobalKey<FormState>();
  TextEditingController workTogether = TextEditingController();
  TextEditingController listNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                      Theme
                          .of(context)
                          .colorScheme
                          .onBackground,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ),
                NumberPicker(
                  minValue: 3,
                  maxValue: 90,
                  value: context.watch<Game>().maxRounds,
                  onChanged: (newMax) => context.read<Game>().setMaxRounds(newMax),
                  textStyle: TextStyle(
                      color:
                      Theme
                          .of(context)
                          .colorScheme
                          .onBackground,
                      fontSize: 17),
                  selectedTextStyle: TextStyle(
                      color: context.watch<PersistentData>().getActive(),
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
                        color: Theme
                            .of(context)
                            .colorScheme
                            .primary,
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
                            mainAxisAlignment: MainAxisAlignment
                                .center,
                            children: [
                              const Text("1 Punkt"),
                              Switch(
                                  value: context.watch<Game>().rePoints == 2,
                                  activeColor: context.watch<PersistentData>().getActive(),
                                  onChanged: (newValue) {
                                    newValue
                                        ? context.read<Game>().setRePoints(2)
                                        : context.read<Game>().setRePoints(1);
                                  }),
                              const Text("2 Punkte")
                            ],
                          ),
                        ])),
                CupertinoButton(
                  onPressed: () {
                    context.read<Game>().listname = listNameController.text;
                    context.read<Game>().listname +=
                    " - ${DateTime.now().toIso8601String().substring(
                        0, 16).replaceAll("T", " ")}";
                    context.read<Game>().listname.replaceAll(".", "_");

                    Navigator.push(context, MaterialPageRoute(builder: (_) => const PlayerManagement()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Neue Liste beginnen",
                      style: TextStyle(
                          color:
                          Theme
                              .of(context)
                              .colorScheme
                              .primary),
                    ),
                  ),
                ),
                if (context.watch<AppUser>().pendingLists.isNotEmpty)
                  CupertinoButton(
                      child:
                      const Text("Alte Liste wiederherstellen"),
                      onPressed: () async {
                        List<String> items = context.read<AppUser>().pendingLists
                            .map((e) => e.listname)
                            .toList();
                        String selectedList = items[0];

                        showMaterialScrollPicker(
                            context: context,
                            items: items,
                            backgroundColor: Theme
                                .of(context)
                                .colorScheme
                                .background,
                            confirmText: "OK",
                            cancelText: "Abbrechen",
                            buttonTextColor:
                            Theme
                                .of(context)
                                .colorScheme
                                .primary,
                            title: "Wähle eine Liste aus",
                            headerColor:
                            Theme
                                .of(context)
                                .colorScheme
                                .primary,
                            headerTextColor: Theme
                                .of(context)
                                .colorScheme
                                .background,
                            showDivider: false,
                            selectedItem: selectedList,
                            onChanged: (value) =>
                                setState(
                                        () =>
                                    selectedList = value as String),
                            onConfirmed: () async {
                              for (Game game
                              in context.read<AppUser>().pendingLists) {
                                if (game.listname == selectedList) {
                                  await context.read<Game>()
                                      .restoreList(game, context);
                                }
                              }
                              // setState(() {}); //TDSEST
                            });
                      }),

                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  child: Text(
                    "oder",
                    style: TextStyle(
                      color: Theme
                          .of(context)
                          .colorScheme
                          .onBackground,
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                ),

                Text(
                  "Bei anderer Liste mitwriken",
                  style: TextStyle(
                    color: Theme
                        .of(context)
                        .colorScheme
                        .onBackground,
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
                          Theme
                              .of(context)
                              .colorScheme
                              .primary,
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
                          if (!await context.read<Game>().getTogetherList(workTogether.text, context)) {
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
                          }
                        }
                      }),
              ],

            ),
          ),
        ],
      ),
    );
  }
}
