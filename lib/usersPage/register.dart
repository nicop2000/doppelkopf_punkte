import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:doppelkopf_punkte/helper/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:doppelkopf_punkte/helper/helper.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  String errorMsg = "";

  final _formKey = GlobalKey<FormState>();
    TextEditingController emailRegister = TextEditingController();
    TextEditingController passwordRegister = TextEditingController();
    TextEditingController passwordRepeatRegister = TextEditingController();
    TextEditingController nameRegister = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Helpers.getHeadline(context, "Registrieren"),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  autocorrect: false,
                  controller: nameRegister,
                  decoration: InputDecoration(
                    hintText: "Max",
                    hintStyle: const TextStyle(
                      color: Constants.mainGreyHint,
                    ),
                    labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary,),
                    labelText: "Vorname",
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Constants.mainGrey),),
                  ),
                ),
                TextFormField(
                  autocorrect: false,
                  validator: (value) {
                    return EmailValidator.validate(value!) ? null : "Die E-Mailadresse ist nicht gültig";
                  },
                  controller: emailRegister,
                  decoration: InputDecoration(
                    errorMaxLines: 2,
                    hintText: "something@example.de",
                    hintStyle: const TextStyle(
                      color: Constants.mainGreyHint,
                    ),
                    labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary,),
                    labelText: "E-Mail",
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Constants.mainGrey),),
                  ),
                ),
                TextFormField(
                  autocorrect: false,
                  validator: (value) {
                    return Helpers.validatePasswordStrength(value!) ? null : "Das Passwort entspricht nicht den Richlinien. Es muss Groß- und Kleinschreibung, sowie Zahlen und Sonderzeichen enthalten, sowie mind. 8 Zeichen lang sein.";
                  },
                  controller: passwordRegister,
                  obscureText: true,
                  decoration: InputDecoration(
                    errorMaxLines: 3,
                    hintText: "Passwort eingeben",
                    hintStyle: const TextStyle(
                      color: Constants.mainGreyHint,
                    ),
                    labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary,),
                    labelText: "Passwort",
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Constants.mainGrey),),
                  ),
                ),
                TextFormField(
                  autocorrect: false,
                  validator: (value) {
                    return passwordRegister.text == value ? null : "Die Passwörter stimmen nicht überein";
                  },
                  controller: passwordRepeatRegister,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Passwort erneut eingeben",
                    hintStyle: const TextStyle(
                      color: Constants.mainGreyHint,
                    ),
                    labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary,),
                    labelText: "Passwortwiederholung",
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Constants.mainGrey),),
                  ),
                ),
              ],
            ),
          ),
          Helpers.getErrorDisplay(errorMsg),
          ElevatedButton(
            onPressed:  () async {
              if (_formKey.currentState!.validate()) {
                try {
                  UserCredential userCredentials = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: emailRegister.text,
                      password: passwordRegister.text
                  );
                  User user = userCredentials.user!;
                  user.updateDisplayName(nameRegister.text);
                  Helpers.userLoggedIn(userCredentials.user!);
                  Navigator.of(context).pop();
                } on FirebaseAuthException catch (e) {
                  print("FIREBASEAUTHEXCEPTION");

                  if (e.code == 'weak-password') {
                    print('The password provided is too weak.');
                    setState(() {

                    errorMsg = "Das eingegebene Passwort ist zu schwach. "
                        "Ein starkes Passwort besteht aus Groß- und "
                        "Kleinbuchstaben, Zahlen und Sonderzeichen";
                    });
                  } else if (e.code == 'email-already-in-use') {
                    print('The account already exists for that email.');
                    setState(() {

                    errorMsg = "Es existiert bereits ein Account mit dieser "
                        "E-Mailadresse";
                    });
                  }

                } catch (e) {
                  setState(() {
                    errorMsg = e.toString();
                    print("ERROR:  $e");
                  });
                }
                return;
              }

            },
            child: const Text("Registrieren"),
          ),
        ],
    );
  }
}
