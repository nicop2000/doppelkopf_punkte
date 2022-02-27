import 'package:doppelkopf_punkte/helper/constants.dart';
import 'package:flutter/material.dart';

TextFormField NameTextField(
    BuildContext context, TextEditingController nameController) {
  return TextFormField(
    autocorrect: false,
    controller: nameController,
    decoration: InputDecoration(
      hintText: "Max",
      hintStyle: const TextStyle(
        color: Constants.mainGreyHint,
      ),
      labelStyle: TextStyle(
        color: Theme.of(context).colorScheme.primary,
      ),
      labelText: "Vorname",
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Constants.mainGrey),
      ),
    ),
  );
}
