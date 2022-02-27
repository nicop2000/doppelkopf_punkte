import 'package:doppelkopf_punkte/helper/constants.dart';
import 'package:doppelkopf_punkte/helper/helper.dart';
import 'package:flutter/material.dart';

TextFormField PasswordTextField(
    BuildContext context, TextEditingController passwordController) {
  return TextFormField(
    autocorrect: false,
    controller: passwordController,
    obscureText: true,
    decoration: InputDecoration(
      hintText: "Passwort eingeben",
      hintStyle: const TextStyle(
        color: Constants.mainGreyHint,
      ),
      labelStyle: TextStyle(
        color: Theme.of(context).colorScheme.primary,
      ),
      labelText: "Passwort",
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Constants.mainGrey),
      ),
    ),
  );
}

TextFormField PasswordTextFieldRegister(BuildContext context, TextEditingController passwordController) {
  return TextFormField(
    autocorrect: false,
    validator: (value) {
      return Helpers.validatePasswordStrength(value!)
          ? null
          : "Das Passwort entspricht nicht den Richlinien. Es muss Groß- und Kleinschreibung, sowie Zahlen und Sonderzeichen enthalten, sowie mind. 8 Zeichen lang sein.";
    },
    controller: passwordController,
    obscureText: true,
    decoration: InputDecoration(
      errorMaxLines: 3,
      hintText: "Passwort eingeben",
      hintStyle: const TextStyle(
        color: Constants.mainGreyHint,
      ),
      labelStyle: TextStyle(
        color: Theme.of(context).colorScheme.primary,
      ),
      labelText: "Passwort",
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Constants.mainGrey),
      ),
    ),
  );
}

TextFormField PasswordTextFieldRegisterRepeat (BuildContext context, TextEditingController passwordRepeatController, TextEditingController passwordController) {
  return TextFormField(
    autocorrect: false,
    validator: (value) {
      return passwordController.text == value
          ? null
          : "Die Passwörter stimmen nicht überein";
    },
    controller: passwordRepeatController,
    obscureText: true,
    decoration: InputDecoration(
      hintText: "Passwort erneut eingeben",
      hintStyle: const TextStyle(
        color: Constants.mainGreyHint,
      ),
      labelStyle: TextStyle(
        color: Theme.of(context).colorScheme.primary,
      ),
      labelText: "Passwortwiederholung",
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Constants.mainGrey),
      ),
    ),
  );
}