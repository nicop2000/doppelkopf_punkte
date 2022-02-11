import 'package:doppelkopf_punkte/helper/constants.dart';
import 'package:doppelkopf_punkte/helper/enviroment_variables.dart';
import 'package:doppelkopf_punkte/helper/helper.dart';
import 'package:doppelkopf_punkte/helper/persistent_data.dart';
import 'package:doppelkopf_punkte/model/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:doppelkopf_punkte/doko/game_add_entry.dart';
import 'package:doppelkopf_punkte/doko/game_list.dart';
import 'package:doppelkopf_punkte/doko/game_settings.dart';
import 'package:doppelkopf_punkte/doko/game_statistics.dart';
import 'package:doppelkopf_punkte/doko/saved_lists.dart';
import 'package:doppelkopf_punkte/model/friend.dart';
import 'package:doppelkopf_punkte/usersPage/account_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'game_list.dart';
import 'game_statistics.dart';

class AppOverlay extends StatefulWidget {
  const AppOverlay({Key? key}) : super(key: key);

  @override
  _AppOverlayState createState() => _AppOverlayState();
}

class _AppOverlayState extends State<AppOverlay> {
  int _index = 0;
  final Map<int, List<dynamic>> _content = {
    0: ["Spielliste", const GameList()],
    1: ["Spielstatistiken", const GameStatistics()],
    2: ["Listeneintrag hinzufügen", const GameAddEntry()],
    3: ["Gespeicherte Statistiken", const SavedLists()],
    4: ["Einstellungen", const GameSettings()],
  };

  @override
  void initState() {
    if (FirebaseAuth.instance.currentUser != null) context.read<AppUser>().loginRoutine();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
              tooltip: "Accountinformationen",
              icon: Icon(
                Icons.account_circle_outlined,
                color: Theme.of(context).colorScheme.background,
              ),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AccountInfo()))
          ),
        ],
        title: Text(
          _content[_index]![0],
          style: TextStyle(color: Theme.of(context).colorScheme.background),
        ),
      ),
      body: _content[_index]![1],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Theme.of(context).colorScheme.primary,
        ),
        child: BottomNavigationBar(
            key: EnviromentVariables.keyBottomNavBar,
            type: BottomNavigationBarType.shifting,
            selectedItemColor: context.watch<PersistentData>().getActive(),
            iconSize: 25,
            selectedIconTheme: const IconThemeData(
              size: 35,
            ),
            unselectedItemColor: Theme.of(context).colorScheme.background,
            onTap: (index) {
              _index = index;
              setState(() {});
            },
            currentIndex: _index,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            backgroundColor: Theme.of(context).colorScheme.primary,
            items: [
              _bottomNavigationElement(
                  title: _content[0]![0], icon: CupertinoIcons.list_bullet),
              _bottomNavigationElement(
                  title: _content[1]![0], icon: CupertinoIcons.chart_pie),
              _bottomNavigationElement(title: "Add", icon: CupertinoIcons.add),
              _bottomNavigationElement(
                  title: "Archiv", icon: CupertinoIcons.floppy_disk),
              _bottomNavigationElement(
                  title: _content[4]![0], icon: CupertinoIcons.settings),
            ]),
      ),
    );
  }

  /// Das _bottomNavigationElement stellt die Naviagtionselemente in der unteren
  /// Navigationsleiste dar.

  BottomNavigationBarItem _bottomNavigationElement(
      {required String title, required IconData icon}) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: title,
      tooltip: title,
    );
  }

  Widget buildSheet() {
    return DraggableScrollableSheet(
      minChildSize: 0.9,
      initialChildSize: 1,
      builder: (_, controller) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView(
            controller: controller,
            children: [
              Row(
                children: [
                  const Spacer(),
                  IconButton(
                    tooltip: "Schließen",
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      CupertinoIcons.clear_circled,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: StatefulBuilder(
                    builder: (BuildContext bc, StateSetter managementState) {
                      Widget getFriend(Friend friend) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              friend.name,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onBackground,
                                fontSize: 18,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.remove_circle_rounded,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              onPressed: () async {
                                await Constants.realtimeDatabase
                                    .child(
                                    'friends/${FirebaseAuth.instance.currentUser!.uid}')
                                    .update({friend.uid: null});
                                await context.read<AppUser>().getFriends();
                                managementState(() {});
                              },
                            ),
                          ],
                        );
                      }

                      return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (context.read<AppUser>().friends.length <= 3)
                              Center(
                                  child: Text("Du hast noch keine Freunde :c",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground)))
                            else
                              for (Friend friend in context.read<AppUser>().friends)
                                if (friend.uid != "null") getFriend(friend)
                          ]);
                    }),
              ),
            ],
          ),
        );
      },
    );
  }

}