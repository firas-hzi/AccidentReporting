import 'package:cloud_firestore/cloud_firestore.dart';



class Accident {
  String id = '';
  String versOfTheOpponent = '';
  String insuranceNumber = '';
  String harmNumber = '';
  String policyHolder = '';
  String opponentOfTheAccident = '';
  DateTime claimDay = new DateTime.now();
  String location = '';

  String injuredName = '';
  String injuredAddress = '';
  String injuredTelephone = '';

  String accident = '';
  String how = '';
  String where = '';
  DateTime when = new DateTime.now();

  String vorschadenTimes = '0';
  String vorschadenDesc = '';

  String altschadenTimes = '0';
  String altschadenDesc = '';

  Accident.fromAccicent();
  Accident(
      {this.id = '',
      this.versOfTheOpponent = '',
      this.insuranceNumber = '',
      this.harmNumber = '',
      this.policyHolder = '',
      this.opponentOfTheAccident = '',
      this.claimDay,
      this.location = '',
      this.injuredName = '',
      this.injuredAddress = '',
      this.injuredTelephone = '',
      this.accident = '',
      this.how = '',
      this.where = '',
      this.when,
      this.vorschadenTimes = '0',
      this.vorschadenDesc = '',
      this.altschadenTimes = '0',
      this.altschadenDesc = ''});

  factory Accident.fromDocument(DocumentSnapshot doc) {
    Timestamp timestampClaimDay = doc['claimDay'] as Timestamp;
    Timestamp timestampWann = doc['when'] as Timestamp;
    return Accident(
      id: doc.documentID,
      versOfTheOpponent: doc['versOfTheOpponent'],
      insuranceNumber: doc['insuranceNumber'],
      harmNumber: doc['harmNumber'],
      policyHolder: doc['policyHolder'],
      opponentOfTheAccident: doc['opponentOfTheAccident'],
      claimDay: timestampClaimDay == null
          ? DateTime.now()
          : timestampClaimDay.toDate(),
      location: doc['location'],
      injuredName: doc['injuredName'],
      injuredAddress: doc['injuredAddress'],
      injuredTelephone: doc['injuredTelephone'],
      accident: doc['accident'],
      how: doc['how'],
      where: doc['where'],
      when: timestampWann == null ? DateTime.now() : timestampWann.toDate(),
      vorschadenTimes: doc['vorschadenTimes'],
      vorschadenDesc: doc['vorschadenDesc'],
      altschadenTimes: doc['altschadenTimes'],
      altschadenDesc: doc['altschadenDesc'],
    );
  }

  Map<String, dynamic> toJson(accident) => {
        'id': accident.id,
        'versOfTheOpponent': accident.versOfTheOpponent,
        'insuranceNumber': accident.insuranceNumber,
        'harmNumber': accident.harmNumber,
        'policyHolder': accident.policyHolder,
        'opponentOfTheAccident': accident.opponentOfTheAccident,
        'claimDay':
            accident.claimDay == null ? DateTime.now() : accident.claimDay,
        'location': accident.location,
        'injuredName': accident.injuredName,
        'injuredAddress': accident.injuredAddress,
        'injuredTelephone': accident.injuredTelephone,
        'accident': accident.accident,
        'how': accident.how,
        'where': accident.where,
        'when': accident.when == null ? DateTime.now() : accident.when,
        'vorschadenTimes': accident.vorschadenTimes,
        'vorschadenDesc': accident.vorschadenDesc,
        'altschadenTimes': accident.altschadenTimes,
        'altschadenDesc': accident.altschadenDesc,
      };
}

class Tire {
  String id;
  String accidentId;
  String tire;
  String brand;
  String size;
  String profile;

  Tire(
      {this.id = '',
      this.accidentId = '',
      this.tire = '',
      this.size = '',
      this.brand = '',
      this.profile = '1'});

  Map<String, dynamic> toTireJson() => {
        'id': id,
        'accidentId': accidentId,
        'tire': tire,
        'size': size,
        'brand': brand,
        'profile': profile,
      };

  factory Tire.fromJson(Map<String, dynamic> json) {
    return Tire(
        id: json['id'],
        accidentId: json['accidentId'],
        tire: json['tire'],
        size: json['size'],
        brand: json['brand'],
        profile: json['profile']);
  }
  factory Tire.fromDocument(DocumentSnapshot doc) {
    return Tire(
        id: doc.documentID,
        accidentId: doc['accidentId'],
        tire: doc['tire'],
        size: doc['size'],
        brand: doc['brand'],
        profile: doc['profile']);
  }
}
