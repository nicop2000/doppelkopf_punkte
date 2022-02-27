import 'package:doppelkopf_punkte/doko/game_list/sort_players.dart';
import 'package:doppelkopf_punkte/helper/constants.dart';
import 'package:doppelkopf_punkte/model/friend.dart';
import 'package:doppelkopf_punkte/model/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayerManagement extends StatefulWidget {
  const PlayerManagement({Key? key}) : super(key: key);

  @override
  _PlayerManagementState createState() => _PlayerManagementState();
}

class _PlayerManagementState extends State<PlayerManagement> {
  int playerCount = 0;
  List<Friend> friendsToPlay = [];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Spieler auswählen",
          style: TextStyle(color: Theme.of(context).colorScheme.background),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: getPlayerList(context),
        ),
      ),
    );
  }

  List<Widget> getPlayerList(BuildContext context) {
    List<Widget> friends = [];
    friends.add(
      Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Center(
          child: Text(
            "3 Mitspieler auswählen",
            style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontWeight: FontWeight.w500,
                fontSize: 20),
          ),
        ),
      ),
    );
    for (Friend friend in context.read<AppUser>().friends) {
      friends.add(buildFriend(friend));
    }
    friends.add(CupertinoButton(
        child: const Text("Weiter zur Spielerreihenfolge"),
        onPressed: playerCount != 3
            ? null
            : () {
                friendsToPlay.add(Friend(
                    uid: context.read<AppUser>().user!.uid,
                    name: context.read<AppUser>().user!.displayName!));
                for (Friend friend in friendsToPlay) {
                  friend.activated = false;
                }
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            SortPlayers(playersToBe: friendsToPlay)));
              }));
    return friends;
  }

  Widget buildFriend(Friend friend) {
    TextEditingController tec = TextEditingController();
    return Column(
      children: [
        GestureDetector(
          child: Container(
            child: Text(friend.name),
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: friend.activated ? Colors.green : Colors.red,
                borderRadius: const BorderRadius.all(Radius.circular(10))),
          ),
          onTap: () {
            if (!friend.activated) {
              if (playerCount < 3) {
                setState(() {
                  playerCount++;
                  friend.activated = true;
                  friendsToPlay.add(friend);
                });
              }
            } else {
              setState(() {
                playerCount--;
                friend.activated = false;
                friendsToPlay.removeWhere((element) =>
                    (element.name == friend.name && element.uid == friend.uid));
              });
            }
          },
        ),
        if (friend.uid == "null" && friend.activated)
          TextField(
              controller: tec,
              decoration: InputDecoration(
                hintText: "Namen für Spieler ${friend.name} eingeben",
                hintStyle: const TextStyle(
                  color: Constants.mainGreyHint,
                ),
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
                labelText: "${friend.name} heißt eigentlich:",
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Constants.mainGrey),
                ),
              ),
              onChanged: (newName) {
                if (newName.trim().isNotEmpty) {
                  friend.name = newName;
                }
              })
      ],
    );
  }
}

extension on List<Friend> {
  bool containsName(String string) {
    for (Friend friend in this) {
      if (friend.name.contains(string)) return true;
    }
    return false;
  }

  bool nameIsEmpty() {
    for (Friend friend in this) {
      if (friend.name.isEmpty) return true;
    }
    return false;
  }
}
