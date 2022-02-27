import 'package:doppelkopf_punkte/helper/constants.dart';
import 'package:doppelkopf_punkte/model/friend.dart';
import 'package:doppelkopf_punkte/model/game.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  }

  logoutRoutine() async {
    await FirebaseAuth.instance.signOut();
    setUser(null);
    initFriends();
    isAdmin = false;
    archivedLists = [];
    pendingLists = [];
    loggedIn = false;
    notifyListeners();
  }

  loginRoutine() async{
    await setUser(FirebaseAuth.instance.currentUser);
    canCheckBio = await localAuth.canCheckBiometrics;
    deviceSupported = await localAuth.isDeviceSupported();
    notifyListeners();
    getMyArchivedLists();
    getMyPendingLists();
    getFriends();
  }


  
  initFriends(){
    friends.clear();
    friends.add(Friend(uid: "null", name: "Extra 1"));
    friends.add(Friend(uid: "null", name: "Extra 2"));
    friends.add(Friend(uid: "null", name: "Extra 3"));
  }

  Future<void> addFriend(String uid, String name) async {
    await Constants.realtimeDatabase
        .child('friends/${user!.uid}')
        .update({uid: name});
    getFriends();
  }

  Future<void> removeFriend(String uid) async {
    await Constants.realtimeDatabase
        .child(
        'friends/${user!.uid}')
        .update({uid: null});
    getFriends();
  }





  Future<void> getFriends() async {
    initFriends();
    Constants.realtimeDatabase
        .child('friends/${user!.uid}')
        .once().then((snapshot) {

      if (snapshot.value == null) {
        friends.clear();
        notifyListeners();
        return;
      }
    Map<String, String> myFriendMap = Map.from(snapshot.value);

    for(MapEntry entry in myFriendMap.entries) {
      friends.add(Friend(uid: entry.key, name: entry.value));
    }
    notifyListeners();
    });
  }
  


  Future<void> getMyArchivedLists() async {
    Constants.realtimeDatabase
        .child('endedLists/${user!.uid}')
        .once().then((snapshot) {
      if (snapshot.value == null) {
        archivedLists.clear();
        notifyListeners();
        return;
      }
    var map = Map.from(snapshot.value);
    archivedLists =
        map.values.map((e) => Game.fromJson(e)).toList();
    notifyListeners();
    }); //TODO No Error Handling
    return;
  }

  Future<void> getMyPendingLists() async {
    Constants.realtimeDatabase
        .child('gamelists/${user!.uid}')
        .once().then((snapshot) {
    if (snapshot.value == null) {
      pendingLists.clear();
      notifyListeners();
      return;
    }
    var map = Map.from(snapshot.value);
    pendingLists = map.values.map((e) => Game.fromJson(e)).toList();
    notifyListeners();
    return;
    }); //TODO No Error Handling
  }

  Future<void> deleteSavedList(String listname) async {
    await Constants.realtimeDatabase
        .child(
        'endedLists/${FirebaseAuth.instance.currentUser!.uid}/$listname')
        .remove();
    await getMyArchivedLists();
  }

  




}