import 'package:doppelkopf_punkte/model/friend.dart';
import 'package:doppelkopf_punkte/model/game.dart';
import 'package:doppelkopf_punkte/model/player.dart';
import 'package:doppelkopf_punkte/model/runde.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class SortPlayers extends StatefulWidget {
  const SortPlayers({Key? key, required this.playersToBe})
      : super(key: key);
  final List<Friend> playersToBe;

  @override
  _SortPlayersState createState() => _SortPlayersState();
}

class _SortPlayersState extends State<SortPlayers> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Spielereihenfolge",
          style: TextStyle(color: Theme.of(context).colorScheme.background),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child:
            Column(
              children: [
                Expanded(
                  child: ReorderableListView(
                      physics: const NeverScrollableScrollPhysics(),
                    children: widget.playersToBe.map((friend) => ListTile(key: Key(friend.name), title: Text(friend.name), trailing: const Icon(Icons.menu),)).toList(),
                    onReorder: (int start, int current) {
                      // dragging from top to bottom
                      if (start < current) {
                        int end = current - 1;
                        Friend startItem = widget.playersToBe[start];
                        int i = 0;
                        int local = start;
                        do {
                          widget.playersToBe[local] = widget.playersToBe[++local];
                          i++;
                        } while (i < end - start);
                        widget.playersToBe[end] = startItem;
                      }
                      // dragging from bottom to top
                      else if (start > current) {
                        Friend startItem = widget.playersToBe[start];
                        for (int i = start; i > current; i--) {
                          widget.playersToBe[i] = widget.playersToBe[i - 1];
                        }
                        widget.playersToBe[current] = startItem;
                      }
                      setState(() {});
                    },
                  ),
                ),
                CupertinoButton(child: const Text("Spiel starten"), onPressed: () {
                  context.read<Game>().setPlayers(widget.playersToBe.convertToPlayers());
                  context.read<Runde>().init(context);
                  Navigator.of(context).pop();
                })
              ],
            ),
      ),
    );
  }
}

extension on List<Friend> {
  List<Player> convertToPlayers() => map((e) => Player(name: e.name, uid: e.uid)).toList();
}

