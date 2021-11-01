class Player {
  final String _name;
  String uid = "";
  List <int> _points = [0];
  List<int> _won = [0];
  List<int> _lost = [0];
  List<int> _solo = [0];

  Player(this._name);


  Player newPoints(int p) {

    _points.add(getLastScore() + p);
    return this;
  }
  int getLastScore() {
    return _points.last;
  }

  Player removeLastRound() {
    _points.removeLast();
    _won.removeLast();
    _lost.removeLast();
    _solo.removeLast();
    return this;
  }

  List<int> getAllPoints() => _points;
  List<int> getAllWon() => _won;
  List<int> getAllLost() => _lost;
  List<int> getAllSolo() => _solo;

  String getName() => _name;

  Player won() {
    _won.add(_won.last + 1);
    _lost.add(_lost.last);
    return this;
  }

  Player setScoreList(List<int> newList) {
    _points = newList;
    return this;
  }

  Player setWonList(List<int> newList) {
    _won = newList;
    return this;
  }

  Player setLostList(List<int> newList) {
    _lost = newList;
    return this;
  }

  Player setSoloList(List<int> newList) {
    _solo = newList;
    return this;
  }

  int getWon() => _won.last;

  Player lost() {
    _lost.add(_lost.last + 1);
    _won.add(_won.last);
    return this;
  }

  int getLost() => _lost.last;

  Player solo() {
    _solo.add(_solo.last + 1);
    return this;
  }

  int getSolo() => _solo.last;

  Player newScore(bool won, bool solo, int points) {
    if (won) {
      this.won();
      newPoints(points);
    } else {
      lost();
      newPoints(points);
    }
    if(solo) {
      this.solo();
    } else {
      _solo.add(_solo.last);
    }
    return this;
  }

}