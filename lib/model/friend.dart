class Friend {
  String uid;
  String name;

  Friend(this.uid, this.name);

  // factory Friend.fromJson(dynamic json) {
  //   print(json);
  //   return Friend(json['Modul'] as String, json['Dozent'] as String, json['Raum'] as String, DateTime.parse(json['Beginn']), DateTime.parse(json['Ende']));
  // }
}