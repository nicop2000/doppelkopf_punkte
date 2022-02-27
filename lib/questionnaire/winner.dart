import 'package:doppelkopf_punkte/model/game.dart';
import 'package:doppelkopf_punkte/model/player.dart';
import 'package:doppelkopf_punkte/model/runde.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Winner extends StatefulWidget {
  const Winner({Key? key}) : super(key: key);

  @override
  _WinnerState createState() => _WinnerState();
}

class _WinnerState extends State<Winner> {
  int _playerCount = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  Map<Player, bool> activated = context.watch<Runde>().wonPoints;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Wer hat gewonnen?",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
        const Spacer(),
        StatefulBuilder(
          builder: (BuildContext bc, StateSetter friendState) {
            Widget getPlayer(Player p) {
              return GestureDetector(
                child: Container(
                  child: Text(p.getName()),
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: activated[p]! ? Colors.green : Colors.red,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                ),
                onTap: () {
                  activated.update(p, (value) {
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

                  friendState(() {});
                },
              );
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (Player p in context.read<Game>().players) getPlayer(p),
              ],
            );
          },
        ),
        const Spacer(),
      ],
    );
  }
}
