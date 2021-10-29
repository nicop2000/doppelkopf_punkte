import 'package:doppelkopf_punkte/model/friend.dart';
import 'package:doppelkopf_punkte/model/game.dart';
import 'package:doppelkopf_punkte/model/player.dart';
import 'package:local_auth/local_auth.dart';

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
  static bool isAdmin = false;
  static var localAuth = LocalAuthentication();
  static bool canCheckBio = false;
  static bool deviceSupported = false;
  static List<BiometricType> availableBiometrics = [];
  static Map<Player, bool> activatedPlayed = {};
  static Map<Player, bool> wonPoints = {};
  static List<Friend> friends = [Friend("null", "Extra 1"), Friend("null", "Extra 2"), Friend("null", "Extra 3"), Friend("h", "Hannes"), Friend("f", "Fynn"), Friend("e", "Ella"), Friend("c", "Carlotta")];
  static List<Player> players = [];
  static int pointsWinner = 0;
  static Map<punkte, bool> winnerPoints = {};
  static int dokoWinner = 0;
  static int dokoLoser = 0;
  static var pointSelection;
  static bool solo = false;
  static Game game = Game();
}
