import 'package:doppelkopf_punkte/helper/enviroment_variables.dart';
import 'package:doppelkopf_punkte/model/player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Page2 extends StatefulWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  Map<Player, bool> activated = Env.wonPoints;
  int _playerCount = 0;

  @override
  void initState() {
    activated = Env.wonPoints;


    super.initState();


    setState(() {


    });
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        const Text("Wer hat gewonnen?"),
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
                    print(_playerCount);

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
                  print(activated);

                  friendState(() {});
                },
              );
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (Player p in Env.players) getPlayer(p),
              ],
            );
          },
        ),
        CupertinoButton(child: Text("jd"), onPressed: () => print(Env.pointsWinner))

      ],
    );
  }
}
