import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class myStore {
  String product;
  String category;
  String location;
  int quantity;
  Timestamp datetime;
  String Dimention;
  String RFID_UID;

  myStore(
      {required this.product,
      required this.category,
      required this.location,
      required this.datetime,
      required this.quantity,
      required this.Dimention,
      required this.RFID_UID});

  myStore.fromJson(
    Map<String, dynamic> json,
  )   : product = json['Product']! as String,
        category = json['Category']! as String,
        location = json['location']! as String,
        datetime = json['timeAdded']! as Timestamp,
        Dimention = json['Dimention']! as String,
        RFID_UID = json['RFID_UID']! as String,
        quantity = json['quantity']! as int;

  copyWith(
      {String? product,
      String? category,
      String? location,
      Timestamp? datetime,
      int?
          quantity, //int is 64 bit and int is 32 bit variable. both are different!
      String? Dimention,
      String? RFID_UID}) {
    return myStore(
        product: product ?? this.product,
        category: category ?? this.category,
        location: location ?? this.location,
        datetime: datetime ?? this.datetime,
        quantity: quantity ?? this.quantity,
        Dimention: Dimention ?? this.Dimention,
        RFID_UID: RFID_UID ?? this.RFID_UID);
  }

  Map<String, Object?> toJson() {
    return {
      'Product': product,
      'Category': category,
      'location': location,
      'timeAdded': datetime,
      'quantity': quantity,
      'Dimention': Dimention,
      'RFID_UID': RFID_UID,
    };
  }
}
