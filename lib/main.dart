import 'dart:async';
import 'package:accident_archive/Pages/signin.dart';
import 'package:flutter/material.dart';
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
    
  }

  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 2), onDoneLoading);
  }

  onDoneLoading() async {
    iauth.currentFirebseUser().then((user) {
      if (user != null) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
      } else {
     Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => SignIn()));
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
     /* child: Center(
        child: Center(
          child: SpinKitWanderingCubes(
            color: Colors.blue,
            size: 50.0,
          ),
        ),
      ),*/
    );
  }
}
