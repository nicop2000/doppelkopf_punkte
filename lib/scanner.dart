import 'package:doppelkopf_punkte/model/friend.dart';
import 'package:doppelkopf_punkte/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doppelkopf_punkte/helper/helper.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:provider/provider.dart';

class Scanner extends StatefulWidget {
  const Scanner({Key? key}) : super(key: key);

  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: _buildQrView(context)),
          Container(
            color: Theme.of(context).colorScheme.background,
            child: Row(
              children: [
                const Spacer(),
                IconButton(
                  tooltip: "Kamera drehen",
                  icon: const Icon(Icons.flip_camera_ios),
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () async {
                    await controller?.flipCamera();
                    setState(() {});
                  },
                ),
                const Spacer(),
                IconButton(
                  tooltip: "Schließen",
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    CupertinoIcons.clear_circled,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;

    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      bool toContinue = true;
      result = scanData;
      controller.pauseCamera();
      List<String> preData = result!.code.split("§");
      List<String> data = preData[1].split(":");
      for (Friend f in context.read<AppUser>().friends) {
        if (f.uid == data[0]) {
          toContinue = false;
          await createAlertDialog(context,
              "Du bist bereits mit ${f.name} befreundet", "", "", true, "Mich gibts nur einmal");
        }
      }
      if (toContinue) {
        if (preData[0] == "DOKO" &&
            (data[0] != FirebaseAuth.instance.currentUser!.uid)) {
          await createAlertDialog(
              context,
              "Möchtest du ${data[1]} als Freund:in hinzufügen?",
              data[0],
              data[1],
              false, "Freund hinzufügen?");
          controller.resumeCamera();
        } else if (data[0] == FirebaseAuth.instance.currentUser!.uid) {
          await createAlertDialog(
              context,
              "Du kannst dich nicht selber als Freund hinzufügen",
              "",
              "",
              true,
          "Du brauchst andere Freunde :c");
          controller.resumeCamera();
        } else {
          await createAlertDialog(context,
              "Dieser QR-Code gehört nicht zur Doppelkopf-App", "", "", true, "QR-Code passt nicht");
          controller.resumeCamera();
        }
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    print('${DateTime.now().toIso8601String()} _onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berechtigung für die Kamera verweigert')),
      );
    }
  }

  Future<void> createAlertDialog(BuildContext context, String msg, String uid,
      String name, bool confirmation, String headline) async {
    await showCupertinoDialog(
        context: context, builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text(headline),
        content: Text(msg),
        actions: <Widget>[

          CupertinoDialogAction(
            child: Text(confirmation ? "Okay" : "Ja",),
            onPressed: () {
              if (!confirmation) context.read<AppUser>().addFriend(uid, name);
              if (!confirmation) {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              }
              if (!confirmation) {
                createAlertDialog(
                    context,
                    "$name wurde erfolgreich zu deinen Freunden hinzugefügt",
                    uid,
                    name,
                    true,
                "Hat geklappt!");
              }
              if (confirmation) {
                Navigator.of(context).pop();
                controller!.resumeCamera();
              }
            },

          ),
          if (!confirmation)
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
                controller!.resumeCamera();
              },
              child: const Text("Nein"),
            ),
        ],
      );
    });

  }
}
