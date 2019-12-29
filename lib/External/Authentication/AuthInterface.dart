
import 'package:firebase_auth/firebase_auth.dart';

 abstract class InterfaceForeAuthFirebase
{

   Future<FirebaseUser> signInAnonimously();
   Future<FirebaseUser> signInWithFacebook();  
   Future<void> facebookSignOut();
   Future<void> anonimouslySignOut();
   Future<FirebaseUser> currentFirebseUser();
   Future<void> storeFirebseUser();
}