import 'dart:async';
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
import 'CreatePdf.dart';
import 'PdfViewer.dart';
import 'SelectMultiImages.dart';
import 'UpdateAccident.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Accident accident;
  List<DocumentSnapshot> urls = new List();
  List<Tire> tires = new List();
  CreatePdf createPdf = new CreatePdf();
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
        actions: <Widget>[],
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
                              leading: InkWell(
                                  child: CircleAvatar(
                                    backgroundImage:
                                        AssetImage('assets/images/crash.png'),
                                  ),
                                  onTap: () async {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SelectMultiImages(
                                                    accidentId: snapshot
                                                        .data
                                                        .documents[index]
                                                        .documentID)));
                                  }),
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
                                  tires =
                                      await iStorage.selectById(accident.id);

                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          UpdateAccident(accident, tires)));
                                  setState(() {
                                    isLoading = false;
                                  });
                                },
                              ),
                              onTap: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                accident = Accident.fromDocument(
                                    snapshot.data.documents[index]);
                                tires = await iStorage.selectById(accident.id);

                                urls = await iStorage.getImages(accident.id);
                                createPdf
                                    .createPdfFile(accident, tires, urls)
                                    .then((file) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => PdfViewer(
                                        file: file,
                                      ),
                                    ),
                                  );
                                  setState(() {
                                    isLoading = false;
                                  });
                                }).catchError((onError) {
                                  setState(() {
                                    isLoading = false;
                                    
                                  });
                                 Scaffold.of(context).showSnackBar(SnackBar(content: Text('Try Again')));
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
