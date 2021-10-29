// ignore_for_file: prefer_const_constructors

import 'package:doppelkopf_punkte/helper/constants.dart';
import 'package:doppelkopf_punkte/helper/helper.dart';
import 'package:doppelkopf_punkte/usersPage/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
    String errorMsg = "";
    TextEditingController emailLogin = TextEditingController();
    TextEditingController passwordLogin = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Helpers.getHeadline("Login"),
        Column(
          children: [
            TextField(
              autocorrect: false,
              controller: emailLogin,
              decoration: InputDecoration(
                hintText: "vorname.nachname@student.fh-kiel.de",
                hintStyle: TextStyle(
                  color: Constants.mainGreyHint,
                ),
                labelText: "E-Mail",
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Constants.mainGrey),
                ),
              ),
            ),
            TextField(
              autocorrect: false,
              controller: passwordLogin,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Passwort eingeben",
                hintStyle: TextStyle(
                  color: Constants.mainGreyHint,
                ),
                labelText: "Passwort",
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Constants.mainGrey),
                ),
              ),
            ),
          ],
        ),
        Helpers.getErrorDisplay(errorMsg),
        ElevatedButton(
          onPressed: () async {
            errorMsg = "";
            try {
              UserCredential userCredentials = await FirebaseAuth.instance
                  .signInWithEmailAndPassword(
                      email: emailLogin.text, password: passwordLogin.text);

              Helpers.userLoggedIn(userCredentials.user!);
              Navigator.of(context).pop();
            } on FirebaseAuthException catch (e) {
              if (e.code == 'user-not-found' || e.code == 'wrong-password') {
                setState(() {
                  errorMsg = "Es konnte kein Account mit diesen Zugangsdaten"
                      " gefunden werden";
                });
              } else if (e.code == 'invalid-email') {
                setState(() {
                  errorMsg = "Die E-Mailadresse ist nicht gültig";
                });
              }
            } catch (e) {
              setState(() {
                errorMsg = "Ein Fehler ist aufgetreten: ${e.toString()}";
              });
            }
          },
          child: Text("Login"),
        ),
        RichText(
          text: TextSpan(
            style: TextStyle(),
            children: <TextSpan>[
              TextSpan(
                text: 'Haben Sie Ihr ',
                style: Constants.regularInfoTextStyle,
              ),
              TextSpan(
                text: 'Passwort vergessen?',
                style: Constants.linkStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    createAlertDialog(context);
                  },
              ),
              TextSpan(
                text: '\nHaben Sie noch kein Konto? ',
                style: Constants.regularInfoTextStyle,
              ),
              TextSpan(
                  text: 'Jetzt registrieren!',
                  style: Constants.linkStyle,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      pushNewScreen(context, screen: Register());
                    }),
            ],
          ),
        ),
      ],
    );
  }

  void createAlertDialog(BuildContext context) {
    TextEditingController _controllerDialog = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              width: MediaQuery.of(context).size.width / 1.2,
              height: MediaQuery.of(context).size.height / 3.0,
              child: Column(
                children: <Widget>[
                  Padding(
                    child: Text("Passwort zurücksetzen"),
                    padding: EdgeInsets.fromLTRB(15.0,
                        MediaQuery.of(context).size.height / 64, 15.0, 15.0),
                  ),
                  TextField(
                    controller: _controllerDialog,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Constants.mainGrey)),
                      hintText: "something@example.de",
                      labelText: "E-Mail",
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0,
                        MediaQuery.of(context).size.height / 36, 15.0, 15.0),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(20.0),
                      color: Constants.mainBlue,
                      child: MaterialButton(
                        minWidth: MediaQuery.of(context).size.width / 2,
                        // padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                        child: Text(
                          "Abschicken",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Constants.mainWhite),
                        ),
                        onPressed: () async {
                          FirebaseAuth.instance
                              .sendPasswordResetEmail(
                                  email: _controllerDialog.text)
                              .then((_) {
                            final snackBar = SnackBar(
                              content: Text(
                                  "E-Mail wurde erfolgreich versendet. Prüfe auch dein Spam-Postfach!"),
                              backgroundColor: Constants.mainBlue,
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            Navigator.of(context).pop();
                          }).catchError((e) {
                            if (e.toString().contains("user-not-found")) {
                              final snackBar = SnackBar(
                                content: Text(
                                    "Wenn es einen Nutzer mit dieser E-Mailadresse gibt, wird eine E-Mail mit einem Link zum Zurücksetzten dorthin versendet werden."),
                                backgroundColor: Constants.mainBlue,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              final snackBar = SnackBar(
                                content: Text(
                                    "Es ist ein Fehler aufgetreten: ${e.toString()}"),
                                backgroundColor: Constants.mainBlue,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                            Navigator.of(context).pop();
                          });
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 15.0),
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width / 2,
                      child: Text(
                        "Abbrechen",
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
