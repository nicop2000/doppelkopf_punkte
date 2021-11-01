import 'package:doppelkopf_punkte/model/friend.dart';
import 'package:doppelkopf_punkte/model/game.dart';
import 'package:doppelkopf_punkte/model/player.dart';
import 'package:flutter/cupertino.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';


enum punkte {
  re,
  kontra,
  fuchs1Winner,
  fuchs2Winner,
  fuchs1Loser,
  fuchs2Loser,
  herzdurchlaufWinner,
  herzdurchlaufLoser,
  karlchenWinner,
  karlchenLoser,
  gegenDieAlten
}

class Env {



  static var controller = StreamController.broadcast();
  static Stream playersAdd = controller.stream;



















  static GlobalKey keyBottomNavBar = GlobalKey(debugLabel: 'btm_app_bar');
  static GlobalKey keyArchive = GlobalKey(debugLabel: 'archive');


  static Map<String, dynamic> archivedLists = {};


  static bool isAdmin = false;
  static var localAuth = LocalAuthentication();
  static bool canCheckBio = false;
  static bool deviceSupported = false;
  static List<BiometricType> availableBiometrics = [];
  static Map<Player, bool> activatedPlayed = {};
  static Map<Player, bool> wonPoints = {};
  static List<Friend> friends = [Friend("null", "Extra 1"), Friend("null", "Extra 2"), Friend("null", "Extra 3")];
  static List<Widget> lists = [];
  static int pointsWinner = 0;
  static Map<punkte, bool> winnerPoints = {};
  static int dokoWinner = 0;
  static int dokoLoser = 0;
  static var pointSelection;
  static bool solo = false;

  static Game game = Game();

  static late SharedPreferences prefs;
}


/*
    my StreamBuilder

    return StreamBuilder(
        stream: Env.playersAdd,
        builder: (BuildContext bc, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.hasData) {
            return Center(
              child: Container(
                child: Text("Content"),
              ),
            );
          } else if(snapshot.hasError) {
            return const Center(child: Text("Es ist ein Fehler aufgetreten"),);
          } else {
            return const Center(child: Text("Es wurden noch keine Spieler ausgewählt"),);
          }
        });
 */