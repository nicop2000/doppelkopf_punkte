import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doppelkopf_punkte/helper/helper.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class Scanner extends StatefulWidget {
  const Scanner({Key? key}) : super(key: key);

  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.

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
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
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
      result = scanData;
      print(result!.code);
      controller.pauseCamera();
      List<String> preData = result!.code.split("§");
      List<String> data = preData[1].split(":");
      if (preData[0] == "DOKO") {
        await createAlertDialog(
            context,
            "Möchtest du ${data[1]} als Freund:in hinzufügen?",
            data[0],
            data[1],
            false);
      } else if (data[0] == FirebaseAuth.instance.currentUser!.uid){
        await createAlertDialog(
            context,
            "Du kannst dich nicht selber als Freund hinzufügen",
            "",
            "",
            true);
      } else {
        await createAlertDialog(
            context,
            "Dieser QR-Code gehört nicht zur Doppelkopf-App",
            "",
            "",
            true);
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
      String name, bool confirmation) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              color: Theme.of(context).colorScheme.background,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (!confirmation) Helpers.addFriend(uid, name);
                          if (!confirmation) {
                            Navigator.of(context).popAndPushNamed('/');
                          }
                          if (!confirmation) {
                            createAlertDialog(
                                context,
                                "$name wurde erfolgreich zu deinen Freunden hinzugefügt",
                                uid,
                                name,
                                true);
                          }
                          if (confirmation) Navigator.of(context).pop();
                        },
                        child: Text(
                          confirmation ? "Okay" : "Ja",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.background,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                      if (!confirmation)
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            controller!.resumeCamera();
                          },
                          child: Text(
                            "Nein",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).colorScheme.background,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
