class SavedList {

  final String date;
  final List players;
  final List won;
  final List lost;
  final List solo;
  final List points;

  SavedList(this.date, this.players, this.won, this.lost, this.solo, this.points);

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