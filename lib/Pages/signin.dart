import 'package:accident_archive/External/Authentication/AuthInterface.dart';
import 'package:accident_archive/widgets/Loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import '../External/Authentication/AuthFactory.dart';
import '../External/Authentication/AuthInterface.dart';
import 'home.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  InterfaceForeAuthFirebase iauth = AuthFactory.getAuthFirebaseImplementation();

bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
   
      body:Stack(children: <Widget>[

         Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ButtonTheme(
              minWidth: 250.0,
              height: 60.0,
              child: GoogleSignInButton(
                darkMode: true,
                  onPressed: () async {
                    iauth.signInWithGoogle().then((user) {
                      setState(() {
                          isLoading=true;
                      });
                    
          iauth.storeFirebseUser().whenComplete(() {
            setState(() {
                          isLoading=false;
                      });
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Home()));
          }).catchError((onError) {
            print(onError.toString());
          });
        }).catchError((onError) {
          print(onError.toString());
        });
                  }),
            ),
          ],
        ),
      ),
        
       isLoading ? Loading() : Stack(),
        ],)
    );
  }
}
