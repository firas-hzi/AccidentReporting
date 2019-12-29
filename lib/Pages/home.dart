import 'dart:async';
import 'dart:convert';

import 'package:accident_archive/External/Storage/StorageFactory.dart';
import 'package:accident_archive/External/Storage/StorageInterface.dart';
import 'package:accident_archive/Model/AccidentData.dart';
import 'package:accident_archive/Pages/AddAccident.dart';
import 'package:accident_archive/widgets/Loading.dart';
import 'package:accident_archive/widgets/TextStyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../External/Authentication/AuthFactory.dart';
import '../External/Authentication/AuthInterface.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CreatePdf.dart';
import 'PdfViewer.dart';
import 'UpdateAccident.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Accident accident;
  InterfaceForeAuthFirebase iAuth = AuthFactory.getAuthFirebaseImplementation();
  StorageInterface iStorage = StorageFactory.getStorageImplementation();
  Stream<QuerySnapshot> querySnapshot;
  bool isLoading = false;
  TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    accident = new Accident();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CCbyExpert',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w200),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: <Widget>[
          // FlatButton(
          //   onPressed: () async {
          //     await iAuth.facebookSignOut();
          //     Navigator.of(context).pushReplacement(
          //         MaterialPageRoute(builder: (context) => SignIn()));
          //   },
          //   child: Icon(
          //     Icons.cloud_off,
          //     color: Colors.white,
          //   ),
          // ),
        ],
      ),
      backgroundColor: Colors.blue[100],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddAccident()));
        },
        child: Icon(Icons.add),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            child: FutureBuilder<QuerySnapshot>(
                future: iStorage.getAll(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        accident = new Accident.fromDocument(
                            snapshot.data.documents[index]);
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Card(
                            margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
                            child: ListTile(
                              title: Text(
                                accident.injuredName,
                                style: textStyle,
                              ),
                              subtitle: Text(
                                accident.insuranceNumber +
                                    '\n' +
                                    DateFormat('dd-MMM-yy HH:mm a')
                                        .format(accident.when)
                                        .toString(),
                                style: TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              dense: true,
                              leading: CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/images/crash.png'),
                              ),
                              trailing: new IconButton(
                                icon: Icon(
                                  Icons.update,
                                  color: Colors.blue,
                                ),
                                onPressed: () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  accident = Accident.fromDocument(
                                      snapshot.data.documents[index]);
                                  await initTire(accident.id).whenComplete((() {
                                    setTire().then((tires) {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  UpdateAccident(
                                                      accident, tires)));
                                      setState(() {
                                        isLoading = false;
                                      });
                                    });
                                  }));
                                },
                              ),
                              onTap: () async {
                                setState(() {
                                  isLoading = true;
                                });

                                accident = Accident.fromDocument(
                                    snapshot.data.documents[index]);
                                await initTire(accident.id).whenComplete(() {
                                  CreatePdf createPdf = new CreatePdf();
                                  setTire().then((tires) {
                                    createPdf
                                        .createPdfFile(accident, tires)
                                        .then((path) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => PdfViewer(
                                            path: path,
                                          ),
                                        ),
                                      );
                                      setState(() {
                                        isLoading = false;
                                      });
                                    });
                                  });
                                });
                              },
                              onLongPress: () {
                                _deleteDialog(snapshot.data.documents[index]);
                              },
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Loading();
                  }
                }),
          ),
          isLoading ? Loading() : Stack(),
        ],
      ),
    );
  }

  Future<void> initTire(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String tire;
    iStorage.selectById(id).then((querySnapshot) {
      querySnapshot.listen((data) => data.documents.forEach((doc) {
            Tire tireFromDocument = Tire.fromDocument(doc);
            var json = jsonEncode(tireFromDocument.toTireJson());
            tire = jsonEncode(json);
            switch (doc['size']) {
              case 'VL':
                prefs.setString('VL', tire);
                break;
              case 'VR':
                prefs.setString('VR', tire);
                break;
              case 'HR':
                prefs.setString('HR', tire);
                break;
              case 'HL':
                prefs.setString('HL', tire);
                break;
            }
          }));
    });
  }

  Future<List<Tire>> setTire() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Tire> tires = new List();
    Tire tireVL = Tire.fromJson(
        json.decode(json.decode(prefs.getString('VL')).toString()));
    Tire tireVR = Tire.fromJson(
        json.decode(json.decode(prefs.getString('VR')).toString()));
    Tire tireHL = Tire.fromJson(
        json.decode(json.decode(prefs.getString('HL')).toString()));
    Tire tireHR = Tire.fromJson(
        json.decode(json.decode(prefs.getString('HR')).toString()));
    tires.add(tireVL);
    tires.add(tireVR);
    tires.add(tireHL);
    tires.add(tireHR);
    return tires;
  }

  Future<void> _deleteDialog(DocumentSnapshot documentSnapshot) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Löschen'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(documentSnapshot.data['injuredName']),
                Text('Möchten Sie diesen Datensatz wirklich löschen?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Löschen'),
              onPressed: () {
                setState(() {
                  iStorage.delete(documentSnapshot).whenComplete(() {
                    Navigator.of(context).pop();
                  });
                });
              },
            ),
            FlatButton(
              child: Text('Stornieren'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
