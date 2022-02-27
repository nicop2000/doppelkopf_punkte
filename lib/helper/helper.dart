import 'dart:async';
import 'package:doppelkopf_punkte/helper/constants.dart';
import 'package:doppelkopf_punkte/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

enum routers { login, register, lectureHalls, registerSeat, admin }

class Helpers {
  static Widget getHeadline(BuildContext context, String text) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
          fontWeight: FontWeight.w700,
          decoration: TextDecoration.underline,
          fontSize: 24.0,
        ),
      ),
    );
  }

  static TextStyle getButtonStyle(BuildContext context) {
    return TextStyle(color: Theme.of(context).colorScheme.primary);
  }

  static TextStyle getStyleForSwitch(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.onBackground,
      fontWeight: FontWeight.w500,
      fontSize: 15,
    );
  }

  static Widget getQuestionnaireHeadline(BuildContext context, String msg) {
    return Text(
      msg,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onBackground,
        fontWeight: FontWeight.w800,
        fontSize: 20,
      ),
    );
  }

  static Widget getQuestionnaireInfo(BuildContext context, String msg) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10.0,
      ),
      child: Text(
        msg,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
          fontWeight: FontWeight.w600,
          fontSize: 17,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  static Widget getQuestionnaireSubtext(BuildContext context, String msg) {
    return Text(
      msg,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onBackground,
        fontWeight: FontWeight.w400,
        fontSize: 14,
      ),
      textAlign: TextAlign.center,
    );
  }

  static Widget getErrorDisplay(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        text,
        style: Constants.errorTextStyle,
      ),
    );
  }

  static Future<bool> authenticate(BuildContext context) async {
    final LocalAuthentication auth = LocalAuthentication();
    if (context.read<AppUser>().canCheckBio &&
        context.read<AppUser>().deviceSupported) {
      try {
        return await auth.authenticate(
            localizedReason:
                'Um in die Einstellungen zu gelangen, ist eine erweiterte Authentifizierung notwendig',
            biometricOnly: false,
            useErrorDialogs: true,
            stickyAuth: true);
      } on PlatformException catch (e) {
        // await FirebaseCrashlytics.instance.recordError(e, null,
        //     reason: 'erweiterte Authentifizierung fehlgeschlagen durch PlatformException in Helper authenticate()');
        return false;
      }
    } else {
      TextEditingController pw = TextEditingController();
      var result = false;
      await showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: const Text("Authentifizierung erforderlich"),
              content: Column(
                children: [
                  const Text(
                      "Dies ist ein sensibler Bereich. Authentifizierung erfordlerlich"),
                  const Text(
                      "Da das Gerät keine Berechtigung für biometrische Authentifizierung hat bzw. keine biometrischen Sensoren hat, geben Sie ihr Passwort erneut ein:"),
                  CupertinoTextField(
                    autocorrect: false,
                    controller: pw,
                    obscureText: true,
                  )
                ],
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text("Abbrechen"),
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                ),
                CupertinoDialogAction(
                  child: const Text("Abschicken"),
                  onPressed: () async {
                    result = await validatePassword(pw.text);
                    if (result) {
                      Navigator.of(context).pop();
                    } else {
                      pw.text = "";
                      await showCupertinoDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CupertinoAlertDialog(
                              title: const Text(":c"),
                              content: Column(
                                children: const [
                                  Text("Das war wohl nix!"),
                                ],
                              ),
                              actions: <Widget>[
                                CupertinoDialogAction(
                                  child: const Text("OK"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          });
                    }
                  },
                ),
              ],
            );
          });
      return result;
    }
  }

  static Future<bool> validatePassword(String password) async {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    var authCredentials = EmailAuthProvider.credential(
        email: FirebaseAuth.instance.currentUser!.email!, password: password);
    try {
      var authResult =
          await firebaseUser!.reauthenticateWithCredential(authCredentials);
      return authResult.user != null;
    } catch (e) {
      return false;
    }
  }

  static bool validatePasswordStrength(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }
}
