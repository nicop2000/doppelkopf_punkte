class Game {
  int maxRounds = 18;
  int currentRound = 1;

  Game setMaxRounds(int newMax) {
    maxRounds = newMax;
    return this;
  }

  Game newRound() {
    currentRound++;
    return this;
  }

  bool gameEnd() {
    return maxRounds == currentRound;
  }
}