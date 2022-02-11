import 'package:doppelkopf_punkte/helper/persistent_data.dart';
import 'package:doppelkopf_punkte/main.dart';
import 'package:doppelkopf_punkte/model/game.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

class GameSettings extends StatefulWidget {
  const GameSettings({Key? key}) : super(key: key);

  @override
  State<GameSettings> createState() => _GameSettingsState();
}

class _GameSettingsState extends State<GameSettings> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
        child: SingleChildScrollView(
          child: Column(
            children: [

              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Center(
                  child: Text(
                    "App-Thema auswählen",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ),
              ),


              getColorTheme(context, background: const Color(0xFFFFFFFF), onBackground: const Color(0xFF000000), primary: const Color(0xFF10305A), active: const Color(0xFF10FCAE)),

              getColorTheme(context, background: const Color(0xFFDAE5D6), onBackground: const Color(0xFFF58972), primary: const Color(0xFFCB96F3), active: const Color(0xFFFFFB00)),

              getColorTheme(context, background: const Color(0xFFFBEAFF), onBackground: const Color(0xFFD65DB1), primary: const Color(0xFFFF6F91), active: const Color(0xFF008E9B)),

            ],
          ),
        ),
      ),
    );
  }



  Widget getColorTheme(BuildContext context, {@required Color? background,
    @required Color? onBackground,
    @required Color? primary,
    @required Color? active}) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: GestureDetector(
        onTap: () {
            context.read<PersistentData>().setBackground(background!.red, background.green,
                background.blue, background.opacity);
            context.read<PersistentData>().setOnBackground(onBackground!.red, onBackground.green,
                onBackground.blue, onBackground.opacity);
            context.read<PersistentData>().setPrimaryColor(
                primary!.red, primary.green, primary.blue, primary.opacity);
            context.read<PersistentData>().setActive(
                active!.red, active.green, active.blue, active.opacity);
            // DokoPunkte.setAppState(context); //TODO
        },
        child: Container(
          decoration: BoxDecoration(
              color: background,
              border: Border.all(
                width: 2,
                color: Colors.black,
              )),
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "Text auf Hintergrund",
                  style: TextStyle(
                    color: onBackground,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  color: primary,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Text(
                          "Text auf Primärfarbe",
                          style: TextStyle(
                            color: background,
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                          child: Text(
                            "Aktives Element",
                            style: TextStyle(
                              color: active,
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
