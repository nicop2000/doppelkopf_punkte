import 'package:doppelkopf_punkte/helper/constants.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

TextFormField EmailTextField(BuildContext context, TextEditingController emailController) {
  return TextFormField(
    autocorrect: false,
    validator: (value) {
      return EmailValidator.validate(value!)
          ? null
          : "Die E-Mailadresse ist nicht gültig";
    },
    controller: emailController,
    decoration: InputDecoration(
      errorMaxLines: 2,
      hintText: "something@example.de",
      hintStyle: const TextStyle(
        color: Constants.mainGreyHint,
      ),
      labelStyle: TextStyle(
        color: Theme.of(context).colorScheme.primary,
      ),
      labelText: "E-Mail",
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Constants.mainGrey),
      ),
    ),
  );
}

