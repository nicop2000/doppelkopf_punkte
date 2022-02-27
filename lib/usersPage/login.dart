import 'package:doppelkopf_punkte/helper/constants.dart';
import 'package:doppelkopf_punkte/helper/helper.dart';
import 'package:doppelkopf_punkte/model/user.dart';
import 'package:doppelkopf_punkte/ui/components/EmailTextField.dart';
import 'package:doppelkopf_punkte/ui/components/PasswordTextField.dart';
import 'package:doppelkopf_punkte/usersPage/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  void dispose() {
    emailLogin.dispose();
    passwordLogin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Login",
          style: TextStyle(color: Theme.of(context).colorScheme.background),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Helpers.getHeadline(context, "Login"),
            Column(
              children: [
                EmailTextField(context, emailLogin),
                PasswordTextField(context, passwordLogin),
              ],
            ),
            Helpers.getErrorDisplay(errorMsg),
            ElevatedButton(
              onPressed: () async {
                errorMsg = "";
                try {
                  showCupertinoDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const CupertinoAlertDialog(
                          title:
                              Text("Benutzer wird eingeloggt. Bitte warten..."),
                          content: CupertinoActivityIndicator(),
                        );
                      });
                  UserCredential uC = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: emailLogin.text, password: passwordLogin.text);
                  await context.read<AppUser>().loginRoutine();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                } on FirebaseAuthException catch (e) {
                  Navigator.of(context).pop();
                  if (e.code == 'user-not-found' ||
                      e.code == 'wrong-password') {
                    setState(() {
                      errorMsg =
                          "Es konnte kein Account mit diesen Zugangsdaten"
                          " gefunden werden";
                    });
                  } else if (e.code == 'invalid-email') {
                    setState(() {
                      errorMsg = "Die E-Mailadresse ist nicht gültig";
                    });
                  }
                } catch (e) {
                  Navigator.of(context).pop(); //TODO in finally{} ?
                  setState(() {
                    errorMsg = "Ein Fehler ist aufgetreten: ${e.toString()}";
                  });
                }
              },
              child: const Text("Login"),
            ),
            RichText(
              text: TextSpan(
                style: const TextStyle(),
                children: <TextSpan>[
                  const TextSpan(
                    text: 'Haben Sie Ihr ',
                    style: Constants.regularInfoTextStyle,
                  ),
                  TextSpan(
                    text: 'Passwort vergessen?',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Theme.of(context).colorScheme.primary,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        createAlertDialog(context);
                      },
                  ),
                  const TextSpan(
                    text: '\nHaben Sie noch kein Konto? ',
                    style: Constants.regularInfoTextStyle,
                  ),
                  TextSpan(
                      text: 'Jetzt registrieren!',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Theme.of(context).colorScheme.primary,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Navigator.of(context).pop();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const Register()));
                        }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRegister(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      isScrollControlled: true,
      context: context,
      builder: (BuildContext bc) {
        return StatefulBuilder(
          builder: (BuildContext bc, StateSetter bottomModalStateSetter) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const Spacer(),
                        IconButton(
                          tooltip: "Schließen",
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(
                            CupertinoIcons.clear_circled,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const Register(),
                    const Spacer(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void createAlertDialog(BuildContext context) {
    TextEditingController _controllerDialog = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              color: Theme.of(context).colorScheme.background,
              width: MediaQuery.of(context).size.width / 1.2,
              height: MediaQuery.of(context).size.height / 3.0,
              child: Column(
                children: <Widget>[
                  Padding(
                    child: Text(
                      "Passwort zurücksetzen",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                    padding: EdgeInsets.fromLTRB(15.0,
                        MediaQuery.of(context).size.height / 64, 15.0, 15.0),
                  ),
                  TextField(
                    controller: _controllerDialog,
                    decoration: InputDecoration(
                      focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Constants.mainGrey)),
                      hintText: "something@example.de",
                      labelText: "E-Mail",
                      hintStyle: const TextStyle(
                        color: Constants.mainGreyHint,
                      ),
                      labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0,
                        MediaQuery.of(context).size.height / 36, 15.0, 15.0),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(20.0),
                      color: Theme.of(context).colorScheme.primary,
                      child: MaterialButton(
                        minWidth: MediaQuery.of(context).size.width / 2,
                        // padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                        child: Text(
                          "Abschicken",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary),
                        ),
                        onPressed: () async {
                          FirebaseAuth.instance
                              .sendPasswordResetEmail(
                                  email: _controllerDialog.text)
                              .then((_) {
                            final snackBar = SnackBar(
                              content: const Text(
                                  "E-Mail wurde erfolgreich versendet. Prüfe auch dein Spam-Postfach!"),
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            Navigator.of(context).pop();
                          }).catchError((e) {
                            if (e.toString().contains("user-not-found")) {
                              final snackBar = SnackBar(
                                content: const Text(
                                    "Wenn es einen Nutzer mit dieser E-Mailadresse gibt, wird eine E-Mail mit einem Link zum Zurücksetzten dorthin versendet werden."),
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              final snackBar = SnackBar(
                                content: Text(
                                    "Es ist ein Fehler aufgetreten: ${e.toString()}"),
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
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
                    padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 15.0),
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width / 2,
                      child: Text("Abbrechen",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary)),
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
