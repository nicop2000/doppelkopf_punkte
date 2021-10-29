import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';


import 'package:flutter/material.dart';
import 'package:doppelkopf_punkte/helper/constants.dart';
import 'package:doppelkopf_punkte/helper/helper.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';


class Admin extends StatelessWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

          ElevatedButton(
            onPressed: () async {
              final directory = await getTemporaryDirectory();
              final path = directory.path;
              print(directory);
              final filename = "registration-${DateTime.now().toIso8601String()}.txt";
              final file = File("$path/$filename");
              final out = file.openWrite(mode: FileMode.append);

              print("opened");
              String b = await getData(out);
              await out.close();

              print("closed");

              uploadToFirebase(context, filename, file);




              try{
                // print(await file.readAsString());
              }
                  catch (e) {
                print(e.toString());

                  }





            },
            child: Text("Test write file"),
          ),
        ],
      ),
    );
  }
  Future<String> getData(IOSink out) async {

    String result = "";
    int j = 0;
    out.write("{\n");
    int roomCount = 0;
    for(var room in Constants.rooms) {

      roomCount++;
      QuerySnapshot querySnapshot = await Constants.dbFSDB.collection(room).get();
      // QuerySnapshot querySnapshot = Constants.dbFSDB.doc(room).;
      final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

      out.writeln("\n\"$room\":[\n{");
      int i = 1;
      allData.forEach((value) {
        out.write("\"${Constants.times[i]!}\":");
        i++;
        int subString = 18;
        if(value.toString().length > 19) subString = 20;
        out.write("\"{${value.toString().substring(subString)}\"");

        if(i<=6) out.write(",\n"); else out.write("\n");
      });
      if (roomCount < Constants.rooms.length) out.write("}\n],\n"); else out.write("}\n]\n");
      await out.flush();

    }
    out.write("}");
    await out.flush();





    return result;

  }

  Future uploadToFirebase(BuildContext context, String filename, File file) async {
    // String fileName = basename(_imageFile.path);

    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('protocol/$filename');
    UploadTask uploadTask = firebaseStorageRef.putFile(file);

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() =>
    {
      print("DONE")
    });

  }

}
