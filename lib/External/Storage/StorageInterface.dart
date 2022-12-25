
import 'package:accident_archive/Model/AccidentData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class StorageInterface {
  Future<QuerySnapshot> getAll();
  Future<List<Tire>> selectById(String id);
  Future<void> insert(Accident accident, List<Tire> tires);
  Future<void> update(Accident accident, List<Tire> tires);
  Future<void> delete(DocumentSnapshot id);
  Future<void> addImages(String url,String accidentId);
  Future<List<DocumentSnapshot>> getImages(String accidentId) ;
  Future<void> deleteImage(DocumentSnapshot images, String accidentId);
}
