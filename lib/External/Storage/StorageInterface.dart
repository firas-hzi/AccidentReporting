import 'package:accident_archive/Model/AccidentData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class StorageInterface {
  Future<QuerySnapshot> getAll();
  Future<Stream<QuerySnapshot>> selectById(String id);
  Future<void> insert(Accident accident, List<Tire> tires);
  Future<void> update(Accident accident, List<Tire> tires);
  Future<void> delete(DocumentSnapshot id);
}
