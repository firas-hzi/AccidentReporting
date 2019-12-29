import 'package:accident_archive/External/Authentication/AuthInterface.dart';
import 'package:flutter/material.dart';
import '../External/Authentication/AuthFactory.dart';
import '../External/Authentication/AuthInterface.dart';
import 'home.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  InterfaceForeAuthFirebase iauth = AuthFactory.getAuthFirebaseImplementation();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
   
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ButtonTheme(
              minWidth: 250.0,
              height: 60.0,
              child: RaisedButton(
                  color: Colors.blue[400],
                  child: Text(
                    'Login with facebook',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    await iauth.signInWithFacebook().then((user) {
                      Navigator.of(context)
                          .pushReplacement(
                              MaterialPageRoute(builder: (context) => Home()))
                          .catchError((onError) {
                        print(onError.toString());
                      });
                    });
                  }),
            ),
            // SizedBox(
            //   height: 30.0,
            // ),
            // ButtonTheme(
            //   minWidth: 250.0,
            //   height: 60.0,
            //   child: RaisedButton(
            //       color: Colors.pink[400],
            //       child: Text(
            //         'Login Anonymously',
            //         style: TextStyle(color: Colors.white),
            //       ),
            //       onPressed: () async {
            //         await iauth.signInAnonimously().then((user) {
            //           Navigator.of(context).pushReplacement(
            //               MaterialPageRoute(builder: (context) => Home()));
            //         }).catchError((onError) {
            //           print(onError.toString());
            //         });
            //       }),
            // ),
          ],
        ),
      ),
    );
  }
}
