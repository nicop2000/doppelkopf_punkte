class Friend {
  String uid;
  String name;
  bool activated = false;


  Friend({required this.uid, required this.name});

  Friend.fromJson(Map<dynamic, dynamic> json)
      : name = json['name'],
        uid = json['uid'];
}