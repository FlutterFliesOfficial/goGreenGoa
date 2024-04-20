// This file contains the code for the database service for the events collection
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:green/models/mypred.dart';
import 'package:green/models/mystore.dart';

const String COLLECTION_REF_STORE = 'env2';
const String COLLECTION_REF_PRED = 'pred1';

class DBservStore {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _storesRef;

  DBservStore() {
    _storesRef = _firestore
        .collection(COLLECTION_REF_STORE)
        .withConverter<myStore>(
            fromFirestore: (snapshot, _) => myStore.fromJson(snapshot.data()!),
            toFirestore: (myStore, _) => myStore.toJson());
  }

  Stream<QuerySnapshot> getEvents() {
    return _storesRef.snapshots();
  }

  void addEvent(myStore event) async {
    _storesRef.add(event);
  }
}

class DBPred {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _predRef;

  DBPred() {
    _predRef = _firestore.collection(COLLECTION_REF_PRED).withConverter<Pred>(
        fromFirestore: (snapshot, _) => Pred.fromJson(snapshot.data()!),
        toFirestore: (Pred, _) => Pred.toJson());
  }

  Stream<QuerySnapshot> getCompany() {
    return _predRef.snapshots();
  }

  void addCompany(Pred company) async {
    _predRef.add(company);
  }
}
