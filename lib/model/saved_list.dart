import 'package:doppelkopf_punkte/model/game.dart';
import 'package:doppelkopf_punkte/model/player.dart';

class SavedList {

  String date = "";
  List players = [];
  List won = [];
  List lost = [];
  List solo = [];
  List points = [];


  SavedList(Game game) {
    date = game.date;
    players = game.players;
    won = players.map((e) => e.getWon()).toList();
    lost = players.map((e) => e.getLost()).toList();
    solo = players.map((e) => e.getSolo()).toList();
    points = players.map((e) => e.getLastScore()).toList();
  }

  SavedList.fromJson(Map<dynamic, dynamic> json):
        date = json['Datum'],
        players = json['Spieler'],
        won = json['won'],
        lost = json['lost'],
        solo = json['solo'],
        points = json['points'];

  Map<String, dynamic> toJson() => <String, dynamic>{
    'Datum' : date.toString(),
    'Spieler': players,
    'won': won,
    'lost': lost,
    'solo': solo,
    'points': points,
  };





}