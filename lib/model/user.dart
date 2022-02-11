import 'package:doppelkopf_punkte/helper/constants.dart';
import 'package:doppelkopf_punkte/model/friend.dart';
import 'package:doppelkopf_punkte/model/game.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:local_auth/local_auth.dart';

class AppUser extends ChangeNotifier{

  User? user;
  List<Friend> friends = [];
  bool isAdmin = false;
  LocalAuthentication localAuth = LocalAuthentication();
  bool canCheckBio = false;
  bool deviceSupported = false;
  List<BiometricType> availableBiometrics = [];
  List<Game> archivedLists = [];
  List<Game> pendingLists = [];
  bool loggedIn = false;


  setUser(User? user) {
    this.user = user;
    notifyListeners();
  }

  logoutRoutine() async {
    await FirebaseAuth.instance.signOut();
    await initFriends();
    isAdmin = false;
    archivedLists = [];
    pendingLists = [];
    loggedIn = false;
    notifyListeners();
  }


  
  Future<void> initFriends() async {
    friends.clear();
    friends.add(Friend(uid: "null", name: "Extra 1"));
    friends.add(Friend(uid: "null", name: "Extra 2"));
    friends.add(Friend(uid: "null", name: "Extra 3"));
  }

  Future<void> addFriend(String uid, String name) async {
    // await Constants.fbDB.child('friends/${user!.uid}').set([{"Nico1" : "Andrea"}, {"Nico2" : "Klaas"},{"Nico3" : "Klaaas"}]);
    await Constants.realtimeDatabase
        .child('friends/${user!.uid}')
        .update({uid: name});
    await getFriends();
  }



  Future<void> getFriends() async {
    await initFriends();
    DataSnapshot dS = await Constants.realtimeDatabase
        .child('friends/${user!.uid}')
        .once();
    if (dS.value == null) return;
    Map<String, String> myFriendMap = Map.from(dS.value);

    for(MapEntry entry in myFriendMap.entries) {
      friends.add(Friend(uid: entry.key, name: entry.value));
    }
    notifyListeners();
  }
  
  loginRoutine() async{
    user = FirebaseAuth.instance.currentUser!;
    canCheckBio = await localAuth.canCheckBiometrics;
    deviceSupported = await localAuth.isDeviceSupported();
    await getMyArchivedLists();
    await getMyPendingLists();
    await getFriends();
  }

  Future<void> getMyArchivedLists() async {
    DataSnapshot dS = await Constants.realtimeDatabase
        .child('endedLists/${user!.uid}')
        .once();
    if (dS.value == null) return;
    var map = Map.from(dS.value);
    archivedLists =
        map.values.map((e) => Game.fromJson(e)).toList();
    notifyListeners();
    return;
  }

  Future<void> getMyPendingLists() async {
    DataSnapshot dS = await Constants.realtimeDatabase
        .child('gamelists/${user!.uid}')
        .once();
    if (dS.value == null) return;
    var map = Map.from(dS.value);
    pendingLists = map.values.map((e) => Game.fromJson(e)).toList();
    notifyListeners();
    return;
  }

  Future<void> deleteSavedList(String listname) async {
    await Constants.realtimeDatabase
        .child(
        'endedLists/${FirebaseAuth.instance.currentUser!.uid}/$listname')
        .remove();
    await getMyArchivedLists();
  }

  




}