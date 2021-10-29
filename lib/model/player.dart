class Player {
  final String _name;
  String uid = "";
  List <int> _points = [0];
  int _won = 0;
  int _lost = 0;
  int _solo = 0;

  Player(this._name);


  Player newPoints(int p) {

    _points.add(getLastScore() + p);
    return this;
  }
  int getLastScore() {
    return _points.last;
  }

  List<int> getAllPoints() => _points;

  String getName() => _name;

  Player won() {
    _won++;
    return this;
  }

  int getWon() => _won;

  Player lost() {
    _lost++;
    return this;
  }

  int getLost() => _lost;

  Player solo() {
    _solo++;
    return this;
  }

  int getSolo() => _solo;
}