import 'package:doppelkopf_punkte/helper/constants.dart';
import 'package:doppelkopf_punkte/helper/enviroment_variables.dart';
import 'package:doppelkopf_punkte/helper/helper.dart';
import 'package:doppelkopf_punkte/model/saved_list.dart';
import 'package:doppelkopf_punkte/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class SavedLists extends StatefulWidget {
  const SavedLists({Key? key}) : super(key: key);

  @override
  _SavedListsState createState() => _SavedListsState();
}

class _SavedListsState extends State<SavedLists> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Stream<User?> firebaseStream = FirebaseAuth.instance.authStateChanges();
    return StreamBuilder(
        stream: firebaseStream,
        builder: (BuildContext bc, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasData) {
            return Stack(
                children: [
                Container(color: Theme.of(context).colorScheme.background,),
          SingleChildScrollView(
          child: Column(
          children: formLists(),
          ),

          ),]
          );
          } else if (snapshot.hasError){
            return Center(child: Text("Es ist ein Fehler aufgetreten", style: TextStyle(color: Theme.of(context).colorScheme.onBackground),));
          } else {
            return Center(child: Text("Bitte melde dich erst an, damit deine archivierten Listen geladen werden können.", style: TextStyle(color: Theme.of(context).colorScheme.onBackground),));
          }
        });

  }

  SizedBox getSpacing() {
    return const SizedBox(
      height: 15.0,
    );
  }

  TextStyle getListStyle() {
    return TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w300,
      color: Theme.of(context).colorScheme.onBackground,
    );
  }

  TextStyle getHeadStyle() {
    return TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: Theme.of(context).colorScheme.onBackground,
    );
  }


  List<Widget> formLists() {
    List<Widget> tempWidget = [];

    AppUser.instance.archivedLists.forEach((key) {
      tempWidget.add(
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                key.date.replaceAll("T", " "),
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
            Row(
              children: [
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("", style: getHeadStyle()),
                    getSpacing(),
                    Text("Gewonnen", style: getHeadStyle()),
                    getSpacing(),
                    Text("Verloren", style: getHeadStyle()),
                    getSpacing(),
                    Text("Solos", style: getHeadStyle()),
                    getSpacing(),
                    Text("Gesamtpunkte", style: getHeadStyle()),
                    getSpacing(),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    Text(
                      "${key.players[0].getName()}",
                      style: getHeadStyle(),
                    ),
                    getSpacing(),
                    Text("${key.players[0].getWon()}", style: getListStyle()),
                    getSpacing(),
                    Text("${key.players[0].getLost()}", style: getListStyle()),
                    getSpacing(),
                    Text("${key.players[0].getSolo()}", style: getListStyle()),
                    getSpacing(),
                    Text("${key.players[0].getLastScore()}", style: getListStyle()),
                    getSpacing(),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    Text(
                      "${key.players[1].getName()}",
                      style: getHeadStyle(),
                    ),
                    getSpacing(),
                    Text("${key.players[1].getWon()}", style: getListStyle()),
                    getSpacing(),
                    Text("${key.players[1].getLost()}", style: getListStyle()),
                    getSpacing(),
                    Text("${key.players[1].getSolo()}", style: getListStyle()),
                    getSpacing(),
                    Text("${key.players[1].getLastScore()}", style: getListStyle()),
                    getSpacing(),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    Text(
                      "${key.players[2].getName()}",
                      style: getHeadStyle(),
                    ),
                    getSpacing(),
                    Text("${key.players[2].getWon()}", style: getListStyle()),
                    getSpacing(),
                    Text("${key.players[2].getLost()}", style: getListStyle()),
                    getSpacing(),
                    Text("${key.players[2].getSolo()}", style: getListStyle()),
                    getSpacing(),
                    Text("${key.players[2].getLastScore()}", style: getListStyle()),
                    getSpacing(),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    Text(
                      "${key.players[3].getName()}",
                      style: getHeadStyle(),
                    ),
                    getSpacing(),
                    Text("${key.players[3].getWon()}", style: getListStyle()),
                    getSpacing(),
                    Text("${key.players[3].getLost()}", style: getListStyle()),
                    getSpacing(),
                    Text("${key.players[3].getSolo()}", style: getListStyle()),
                    getSpacing(),
                    Text("${key.players[3].getLastScore()}", style: getListStyle()),
                    getSpacing(),
                  ],
                ),
                const Spacer(),
              ],
            ),
            CupertinoButton(
                child: const Text("Als Kreisdiagramm anzeigen"),
                onPressed: () async {
                  Map<String, double> dataMapWon = {
                    key.players[0].getName(): key.players[0].getWon().toDouble(),
                    key.players[1].getName(): key.players[1].getWon().toDouble(),
                    key.players[2].getName(): key.players[2].getWon().toDouble(),
                    key.players[3].getName(): key.players[3].getWon().toDouble(),
                  };
                  Map<String, double> dataMapLost = {
                    key.players[0].getName(): key.players[0].getLost().toDouble(),
                    key.players[1].getName(): key.players[1].getLost().toDouble(),
                    key.players[2].getName(): key.players[2].getLost().toDouble(),
                    key.players[3].getName(): key.players[3].getLost().toDouble(),
                  };
                  Map<String, double> dataMapSolo = {
                    key.players[0].getName(): key.players[0].getSolo().toDouble(),
                    key.players[1].getName(): key.players[1].getSolo().toDouble(),
                    key.players[2].getName(): key.players[2].getSolo().toDouble(),
                    key.players[3].getName(): key.players[3].getSolo().toDouble(),
                  };
                  showPie(
                      context,
                      "Gewonnene Spiele",
                      dataMapWon,
                      "Verlorene Spiele",
                      dataMapLost,
                      "Solospiele",
                      dataMapSolo);
                  setState(() {});
                }),
            CupertinoButton(
                child: const Text("Diese Liste löschen"),
                onPressed: () async {
                  await Constants.realtimeDatabase
                      .child(
                      'lists/${FirebaseAuth.instance.currentUser!.uid}/${key.date}')
                      .remove();
                  AppUser.instance.archivedLists = await Helpers.getMyList();
                  setState(() {});
                }),
          ],
        ),
      );
    });
    return tempWidget;
  }



  void showPie(BuildContext context, String textWon, dataMapWon,
      String textLost, dataMapLost, String textSolo, dataMapSolo) {
    showModalBottomSheet(
        backgroundColor: Theme.of(context).colorScheme.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        isScrollControlled: true,
        constraints: BoxConstraints.tight(
            Size.fromHeight(MediaQuery.of(context).size.height * 0.85)),
        context: context,
        builder: (BuildContext bc) {
          return DraggableScrollableSheet(
              minChildSize: 0.9,
              initialChildSize: 1,
              builder: (_, controller) {
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ListView(controller: controller, children: [
                    Row(
                      children: [
                        const Spacer(),
                        IconButton(
                          tooltip: "Schließen",
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(
                            CupertinoIcons.clear_circled,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                    PieChart(
                      dataMap: dataMapWon,
                      animationDuration: const Duration(milliseconds: 800),
                      centerText: textWon,
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
                    PieChart(
                      dataMap: dataMapLost,
                      animationDuration: const Duration(milliseconds: 800),
                      centerText: textLost,
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
                    PieChart(
                      dataMap: dataMapSolo,
                      animationDuration: const Duration(milliseconds: 800),
                      centerText: textSolo,
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
                  ]),
                );
              });
        });
  }
}
