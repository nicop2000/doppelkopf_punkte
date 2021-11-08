import 'package:doppelkopf_punkte/helper/enviroment_variables.dart';
import 'package:doppelkopf_punkte/model/friend.dart';
import 'package:doppelkopf_punkte/model/game.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart';

class AppUser {

  late User user;
  List<Friend> friends = [Friend("null", "Extra 1"), Friend("null", "Extra 2"), Friend("null", "Extra 3")];


  bool isAdmin = false;
  LocalAuthentication localAuth = LocalAuthentication();
  bool canCheckBio = false;
  bool deviceSupported = false;
  List<BiometricType> availableBiometrics = [];
  List<Game> archivedLists = [];
  List<Game> pendingLists = [];




  static final AppUser instance = AppUser._internal();
  factory AppUser(UserCredential uC) => instance;
  AppUser._internal();







}