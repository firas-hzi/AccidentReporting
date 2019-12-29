import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

import 'AuthInterface.dart';

class AuthFirebaseImplementation implements InterfaceForeAuthFirebase {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<FirebaseUser> signInAnonimously() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  Future<FirebaseUser> signInWithFacebook() async {
    print("invoking signin facebook");
    final FacebookLogin facebookLogin = FacebookLogin();
    final FacebookLoginResult result = await facebookLogin.logIn(['email']);

    if (result.accessToken != null) {
      print("access token  not null");
      final AuthResult authResult = await _auth.signInWithCredential(
        FacebookAuthProvider.getCredential(
            accessToken: result.accessToken.token),
      );
      print("authresult " + authResult.user.toString());
      return authResult.user;
    } else {
      print("access token is null");
      throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
    }
  }

  @override
  Future<void> facebookSignOut() async {
    final FacebookLogin facebookLogin = FacebookLogin();
    await facebookLogin.logOut();
    return _auth.signOut();
  }

  @override
  Future<void> anonimouslySignOut() {
    return _auth.signOut();
  }

  @override
  Future<FirebaseUser> currentFirebseUser() async {
    final FirebaseUser user = await _auth.currentUser();
    return user;
  }

  @override
  Future<void> storeFirebseUser() async {
    final CollectionReference userCollection =
        Firestore.instance.collection('user');
    await currentFirebseUser().then((user) {
      userCollection.document(user.uid).setData({
        'id': user.uid,
        'email': user.email,
        'name': user.displayName,
      }).then((documentSnapshot) {
        print('done');
      }).catchError((onError) {
        print(onError.toString());
      });
    });
  }
}
