import 'package:firebase_auth/firebase_auth.dart';

import 'StorageInterface.dart';
import 'package:accident_archive/Model/AccidentData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StorageImplementation implements StorageInterface {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference accidentCollection =
      Firestore.instance.collection('accident');
  final CollectionReference userCollection =
      Firestore.instance.collection('user');

  final CollectionReference tiresCollection =
      Firestore.instance.collection('tires');

  @override
  Future<void> insert(Accident accident, List<Tire> tires) async {
    currentFirebseUser().then((user) {
      userCollection
          .document(user.uid)
          .collection('accident')
          .add(accident.toJson(accident))
          .then((document) {
        for (var tire in tires) {
          userCollection
              .document(user.uid)
              .collection('accident')
              .document(document.documentID)
              .collection('tires')
              .add(tire.toTireJson());
        }
      }).catchError((e) {
        print(e);
      });
    });
  }

  Future<FirebaseUser> currentFirebseUser() async {
    final FirebaseUser user = await _auth.currentUser();
    return user;
  }

  @override
  Future<QuerySnapshot> getAll() {
    return currentFirebseUser().then((user) {
      return userCollection
          .document(user.uid)
          .collection('accident')
          .orderBy('when', descending: false)
          .getDocuments();
    });
  }

  @override
  Future<Stream<QuerySnapshot>> selectById(String id) {
    return currentFirebseUser().then((user) {
      return userCollection
          .document(user.uid)
          .collection('accident')
          .document(id)
          .collection('tires')
          .snapshots();
    });
  }

  @override
  Future<void> update(Accident accident, List<Tire> tires) async {
    await currentFirebseUser().then((user) {
      userCollection
          .document(user.uid)
          .collection('accident')
          .document(accident.id)
          .updateData(accident.toJson(accident))
          .whenComplete(() {
        updateTires(tires, accident.id, user.uid);
      }).catchError((e) {
        print(e);
      });
    });
  }

  updateTires(List<Tire> tires, String accidentId, String userId) {
    for (var tire in tires) {
      userCollection
          .document(userId)
          .collection('accident')
          .document(accidentId)
          .collection('tires')
          .document(tire.id)
          .updateData(tire.toTireJson())
          .catchError((e) {
        print(e);
      });
    }
  }

  @override
  Future<void> delete(DocumentSnapshot document) async {
    await currentFirebseUser().then((user) {
      userCollection
          .document(user.uid)
          .collection('accident')
          .document(document.documentID)
          .delete()
          .whenComplete(() {
        deleteTires(document.documentID, user.uid);
      }).catchError((e) {
        print(e);
      });
    });
  }

  deleteTires(String accidentid, String userId) {
    userCollection
        .document(userId)
        .collection('accident')
        .document(accidentid)
        .collection('tires')
        .snapshots()
        .listen((data) => data.documents.forEach((doc) => {
              userCollection
                  .document(userId)
                  .collection('accident')
                  .document(accidentid)
                  .collection('tires')
                  .document(doc.documentID)
                  .delete()
                  .catchError((onError) {})
            }));
  }
}
