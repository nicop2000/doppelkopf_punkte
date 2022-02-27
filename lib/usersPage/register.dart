import 'package:doppelkopf_punkte/model/user.dart';
import 'package:doppelkopf_punkte/ui/components/EmailTextField.dart';
import 'package:doppelkopf_punkte/ui/components/NameTextField.dart';
import 'package:doppelkopf_punkte/ui/components/PasswordTextField.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doppelkopf_punkte/helper/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:doppelkopf_punkte/helper/helper.dart';
import 'package:provider/provider.dart';

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
  void dispose() {
    emailRegister.dispose();
    passwordRegister.dispose();
    passwordRepeatRegister.dispose();
    nameRegister.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Registrieren",
          style: TextStyle(color: Theme.of(context).colorScheme.background),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Helpers.getHeadline(context, "Registrieren"),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  NameTextField(context, nameRegister),
                  EmailTextField(context, emailRegister),
                  PasswordTextFieldRegister(context, passwordRegister),
                  PasswordTextFieldRegisterRepeat(context, passwordRepeatRegister, passwordRegister)
                ],
              ),
            ),
            Helpers.getErrorDisplay(errorMsg),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    showCupertinoDialog(context: context, builder: (BuildContext context) {
                      return const CupertinoAlertDialog(title: Text("Benutzer wird registriert. Bitte warten..."),content: CupertinoActivityIndicator(),);
                    });
                    UserCredential uC = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: emailRegister.text,
                            password: passwordRegister.text);
                    await context.read<AppUser>().loginRoutine();
                    await context.read<AppUser>().user!.updateDisplayName(nameRegister.text);
                    await context.read<AppUser>().user!.sendEmailVerification();
                    await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                        email: emailRegister.text, password: passwordRegister.text);
                    await context.read<AppUser>().loginRoutine();

                    //TDSEST
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();

                  } on FirebaseAuthException catch (e) {
                    Navigator.of(context).pop();
                    if (e.code == 'weak-password') {
                      setState(() {
                        errorMsg = "Das eingegebene Passwort ist zu schwach. "
                            "Ein starkes Passwort besteht aus Groß- und "
                            "Kleinbuchstaben, Zahlen und Sonderzeichen";
                      });
                    } else if (e.code == 'email-already-in-use') {
                      setState(() {
                        errorMsg = "Es existiert bereits ein Account mit dieser "
                            "E-Mailadresse";
                      });
                    }
                  } catch (e) {
                    setState(() {
                      errorMsg = e.toString();
                    });
                  }
                  return;
                }
              },
              child: const Text("Registrieren"),
            ),
          ],
        ),
      ),
    );
  }
}
