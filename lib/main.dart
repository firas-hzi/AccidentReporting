import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'External/Authentication/AuthFactory.dart';
import 'External/Authentication/AuthInterface.dart';
import 'Pages/home.dart';

void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: new MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  InterfaceForeAuthFirebase iauth = AuthFactory.getAuthFirebaseImplementation();
  @override
  void initState() {
    super.initState();
    loadData();
     loadData();
  }

  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 3), onDoneLoading);
  }

  onDoneLoading() async {
    iauth.currentFirebseUser().then((user) {
      if (user != null) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
      } else {
        iauth.signInWithFacebook().then((user) {
          iauth.storeFirebseUser().whenComplete(() {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Home()));
          }).catchError((onError) {
            print(onError.toString());
          });
        }).catchError((onError) {
          print(onError.toString());
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.blue,
        image: DecorationImage(
          image: AssetImage('assets/images/crash.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Center(
          child: SpinKitWanderingCubes(
            color: Colors.blue,
            size: 50.0,
          ),
        ),
      ),
    );
  }
}
