import 'package:doppelkopf_punkte/helper/constants.dart';
import 'package:doppelkopf_punkte/helper/helper.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  int segmentedControlGroupValue = 0;
  final Map<int, Widget> myTabs = const <int, Widget>{
    0: Text("E-Mail"),
    1: Text("Passwort"),
    2: Text("Allgemeines"),
  };
  String errMsg = "";

  final _formKey = GlobalKey<FormState>();
  bool checkCurrentPasswordValid = true;
  TextEditingController oldV = TextEditingController();
  TextEditingController newV = TextEditingController();
  TextEditingController newVRep = TextEditingController();
  TextEditingController extra = TextEditingController();

  @override
  void dispose() {
    oldV.dispose();
    newV.dispose();
    newVRep.dispose();
    extra.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<int, Widget> content = {
      0: Expanded(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              TextFormField(
                autocorrect: false,
                controller: oldV,
                validator: (value) {
                  String error = "";
                  if (!EmailValidator.validate(value!)) {
                    error = "Dies ist keine gültige E-Mailadresse";
                  } else if (value !=
                      FirebaseAuth.instance.currentUser!.email) {
                    error = "Die E-Mailadresse gehört nicht zu diesem Konto";
                  }
                  return error.isEmpty ? null : error;
                },
                decoration: const InputDecoration(
                  errorMaxLines: 2,
                  hintText: "something@example.de",
                  hintStyle: TextStyle(
                    color: Constants.mainGreyHint,
                  ),
                  labelText: "Alte E-Mailadresse eingeben",
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Constants.mainGrey),
                  ),
                ),
              ),
              TextFormField(
                autocorrect: false,
                controller: newV,
                validator: (value) {
                  return EmailValidator.validate(value!)
                      ? null
                      : "Dies ist keine gültige E-Mailadresse";
                },
                decoration: const InputDecoration(
                  errorMaxLines: 2,
                  hintText: "something@example.de",
                  hintStyle: TextStyle(
                    color: Constants.mainGreyHint,
                  ),
                  labelText: "Neue E-Mailadresse eingeben",
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Constants.mainGrey),
                  ),
                ),
              ),
              TextFormField(
                autocorrect: false,
                controller: newVRep,
                validator: (value) {
                  return value! == newV.text
                      ? null
                      : "Die neuen E-Mailadressen stimmen nicht überein";
                },
                decoration: const InputDecoration(
                  errorMaxLines: 2,
                  hintText: "something@example.de",
                  hintStyle: TextStyle(
                    color: Constants.mainGreyHint,
                  ),
                  labelText: "Neue E-Mailadresse wiederholen",
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Constants.mainGrey),
                  ),
                ),
              ),
              TextFormField(
                autocorrect: false,
                obscureText: true,
                controller: extra,
                decoration: InputDecoration(
                  errorText: checkCurrentPasswordValid
                      ? null
                      : "Das eingegebene Passwort gehört nicht zu diesem Konto",
                  hintText: "Aktuelles Passwort eingeben",
                  hintStyle: const TextStyle(
                    color: Constants.mainGreyHint,
                  ),
                  labelText: "Aktuelles Passwort",
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Constants.mainGrey),
                  ),
                ),
              ),
              Helpers.getErrorDisplay(errMsg),
              const Spacer(),
              ElevatedButton(
                onPressed: () async {
                  checkCurrentPasswordValid =
                      await Helpers.validatePassword(extra.text);

                  if (!_formKey.currentState!.validate()) return;
                  if (!checkCurrentPasswordValid) {
                    setState(() {});
                    return;
                  }

                  try {
                    await FirebaseAuth.instance.currentUser!
                        .updateEmail(newV.text);
                    await createAlertDialog(context,
                        "Ihre E-Mailadresse wurde erfolgreich geändert");
                    Navigator.popAndPushNamed(context, '/');
                  } catch (e) {
                    setState(() {
                      errMsg = e.toString();
                    });
                    return;
                  }
                },
                child: const Text("E-Mailadresse ändern"),
              ),
            ],
          ),
        ),
      ),
      1: Expanded(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              TextFormField(
                autocorrect: false,
                obscureText: true,
                controller: oldV,
                decoration: InputDecoration(
                  errorText: checkCurrentPasswordValid
                      ? null
                      : "Das eingegebene Passwort gehört nicht zu diesem Konto",
                  hintText: "Aktuelles Passwort eingeben",
                  hintStyle: const TextStyle(
                    color: Constants.mainGreyHint,
                  ),
                  labelText: "Aktuelles Passwort",
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Constants.mainGrey),
                  ),
                ),
              ),
              TextFormField(
                autocorrect: false,
                obscureText: true,
                controller: newV,
                decoration: const InputDecoration(
                  hintText: "Neues Passwort eingeben",
                  hintStyle: TextStyle(
                    color: Constants.mainGreyHint,
                  ),
                  labelText: "Neues Passwort",
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Constants.mainGrey),
                  ),
                ),
              ),
              TextFormField(
                autocorrect: false,
                obscureText: true,
                controller: newVRep,
                validator: (value) {
                  return newV.text == value
                      ? null
                      : "Die neuen Passwörter stimmen nicht überein";
                },
                decoration: const InputDecoration(
                  hintText: "Neues Passwort wiederholen",
                  hintStyle: TextStyle(
                    color: Constants.mainGreyHint,
                  ),
                  labelText: "Passwortwiederholung",
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Constants.mainGrey),
                  ),
                ),
              ),
              Helpers.getErrorDisplay(errMsg),
              const Spacer(),
              ElevatedButton(
                onPressed: () async {
                  checkCurrentPasswordValid =
                      await Helpers.validatePassword(oldV.text);

                  if (_formKey.currentState!.validate() &&
                      checkCurrentPasswordValid) {
                    try {
                      await FirebaseAuth.instance.currentUser!
                          .updatePassword(newV.text);
                      await createAlertDialog(
                          context, "Dein Passwort wurde erfolgreich geändert");
                      Navigator.popAndPushNamed(context, '/');
                    } catch (e) {
                      setState(() {
                        errMsg = e.toString();
                      });
                      return;
                    }
                  } else {
                    setState(() {});
                    return;
                  }
                },
                child: const Text("Passwort ändern"),
              ),
            ],
          ),
        ),
      ),
      2: Expanded(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text(FirebaseAuth.instance.currentUser!.displayName != null
                  ? "Der aktuelle Name lautet: ${FirebaseAuth.instance.currentUser!.displayName}"
                  : "Es ist noch kein Name festgelegt"),
              TextFormField(
                autocorrect: false,
                controller: newV,
                validator: (value) {
                  return value!.isNotEmpty
                      ? null
                      : "Der Name darf nicht leer sein";
                },
                decoration: const InputDecoration(
                  hintText: "Max Mustermann",
                  hintStyle: TextStyle(
                    color: Constants.mainGreyHint,
                  ),
                  labelText: "Neuer Name",
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Constants.mainGrey),
                  ),
                ),
              ),
              Helpers.getErrorDisplay(errMsg),
              const Spacer(),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await FirebaseAuth.instance.currentUser!
                        .updateDisplayName(newV.text);
                    await createAlertDialog(
                        context, "Dein Name wurde erfolgreich geändert");
                    // Navigator.of(context).pop();
                  }
                },
                child: const Text("Namen ändern"),
              ),
            ],
          ),
        ),
      ),
    };

    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Accounteinstellungen",
          style: TextStyle(color: Theme.of(context).colorScheme.background),
        ),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        padding: const EdgeInsets.all(15.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CupertinoSegmentedControl(
                  groupValue: segmentedControlGroupValue,
                  children: myTabs,
                  unselectedColor: Theme.of(context).colorScheme.background,
                  onValueChanged: (i) {
                    setState(() {
                      errMsg = "";
                      segmentedControlGroupValue = i as int;
                    });
                  }),
              content[segmentedControlGroupValue]!
            ]),
      ),
    );
  }

  Future<void> createAlertDialog(BuildContext context, String msg) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SizedBox(
              width: MediaQuery.of(context).size.width / 1.2,
              height: MediaQuery.of(context).size.height / 3.25,
              child: Column(
                children: <Widget>[
                  Text(
                    msg,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.green,
                      fontSize: 22.0,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Okay",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.background,
                        fontSize: 18.0,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
