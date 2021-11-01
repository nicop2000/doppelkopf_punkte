import 'package:doppelkopf_punkte/helper/enviroment_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class GameStatistics extends StatefulWidget {
  const GameStatistics({Key? key}) : super(key: key);

  @override
  State<GameStatistics> createState() => _GameStatisticsState();
}

class _GameStatisticsState extends State<GameStatistics> {
  @override
  Widget build(BuildContext context) {
    if (Env.game.players.isNotEmpty) {
      Map<String, double> dataMapWon = {
        Env.game.players[0].getName(): Env.game.players[0].getWon().toDouble(),
        Env.game.players[1].getName(): Env.game.players[1].getWon().toDouble(),
        Env.game.players[2].getName(): Env.game.players[2].getWon().toDouble(),
        Env.game.players[3].getName(): Env.game.players[3].getWon().toDouble(),
      };

      Map<String, double> dataMapLost = {
        Env.game.players[0].getName(): Env.game.players[0].getLost().toDouble(),
        Env.game.players[1].getName(): Env.game.players[1].getLost().toDouble(),
        Env.game.players[2].getName(): Env.game.players[2].getLost().toDouble(),
        Env.game.players[3].getName(): Env.game.players[3].getLost().toDouble(),
      };

      Map<String, double> dataMapSolo = {
        Env.game.players[0].getName(): Env.game.players[0].getSolo().toDouble(),
        Env.game.players[1].getName(): Env.game.players[1].getSolo().toDouble(),
        Env.game.players[2].getName(): Env.game.players[2].getSolo().toDouble(),
        Env.game.players[3].getName(): Env.game.players[3].getSolo().toDouble(),
      };
      return Container(
        color: Theme.of(context).colorScheme.background,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                newPie(dataMapWon, "Gewonnen", context),
                newPie(dataMapLost, "Verloren", context),
                newPie(dataMapSolo, "Solos", context),
              ],
            ),
          ),
        ),
      );
    } else {
      return Container(
        color: Theme.of(context).colorScheme.background,
        child: Center(
          child: CupertinoButton(
              child: Text(
                "Es gibt zur Zeit keine aktive Liste",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
              onPressed: () {
                final BottomNavigationBar navigationBar =
                    Env.keyBottomNavBar.currentWidget as BottomNavigationBar;
                navigationBar.onTap!(0);
              }),
        ),
      );
    }
  }

  Padding newPie(dataMap, text, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: PieChart(
        dataMap: dataMap,
        animationDuration: const Duration(milliseconds: 800),
        centerText: text,
        chartRadius: MediaQuery.of(context).size.width * 0.55,
        chartLegendSpacing: 25,
        chartType: ChartType.disc,
        chartValuesOptions: const ChartValuesOptions(
          decimalPlaces: 0,
        ),
        legendOptions: LegendOptions(
            legendShape: BoxShape.circle,
            showLegendsInRow: true,
            legendPosition: LegendPosition.bottom,
            legendTextStyle: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onBackground,
            )),
      ),
    );
  }
}
