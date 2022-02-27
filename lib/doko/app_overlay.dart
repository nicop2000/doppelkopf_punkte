import 'package:doppelkopf_punkte/doko/game_list/game_list_screen.dart';
import 'package:doppelkopf_punkte/helper/enviroment_variables.dart';
import 'package:doppelkopf_punkte/helper/persistent_data.dart';
import 'package:doppelkopf_punkte/model/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:doppelkopf_punkte/doko/game_add_entry.dart';
import 'package:doppelkopf_punkte/doko/game_settings.dart';
import 'package:doppelkopf_punkte/doko/game_statistics.dart';
import 'package:doppelkopf_punkte/doko/saved_lists.dart';
import 'package:doppelkopf_punkte/usersPage/account_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'game_statistics.dart';

class AppOverlay extends StatefulWidget {
  const AppOverlay({Key? key}) : super(key: key);

  @override
  _AppOverlayState createState() => _AppOverlayState();
}

class _AppOverlayState extends State<AppOverlay> {
  int _index = 0;
  final Map<int, List<dynamic>> _content = {
    0: ["Spielliste", const GameListScreen()],
    1: ["Spielstatistiken", const GameStatistics()],
    2: ["Listeneintrag hinzufügen", const GameAddEntry()],
    3: ["Gespeicherte Statistiken", const SavedLists()],
    4: ["Einstellungen", const GameSettings()],
  };

  @override
  void initState() {
    context.read<AppUser>().user = FirebaseAuth.instance.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          if(context.watch<AppUser>().user != null)
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



}