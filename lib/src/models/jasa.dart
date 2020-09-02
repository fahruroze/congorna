import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Jasa {
  final String jasaName;
  final double jasaHarga;
  final String jasaServices;
  final String jasaTimes;
  // final String jasaUnit;
  final String jasaAvailable;
  final String jasaImage;
  final String jasaNote;
  final String jasaId;
  final Timestamp createdAt;
  final String createdBy;
  final String ownerImage;
  final String vendorId;
  final bool approved;

  Jasa({
    this.jasaName,
    this.jasaHarga,
    this.jasaServices,
    this.jasaTimes,
    this.jasaAvailable,
    this.jasaImage,
    this.jasaNote,
    this.createdAt,
    this.createdBy,
    this.ownerImage,
    @required this.jasaId,
    @required this.vendorId,
    @required this.approved,
  });

  Map<String, dynamic> toMap() {
    return {
      'jasaName': jasaName,
      'jasaHarga': jasaHarga,
      // 'jasaUnit': jasaUnit,
      'jasaServices': jasaServices,
      'jasaTimes': jasaTimes,
      'jasaImage': jasaImage,
      'jasaAvailable': jasaAvailable,
      'jasaId': jasaId,
      'jasaNote': jasaNote,
      'vendorId': vendorId,
      'approved': approved,
      'createdAt': createdAt,
      'createdBy': createdBy,
      'ownerImage': ownerImage,
    };
  }

  Jasa.fromFirestore(Map<String, dynamic> firestore)
      : jasaName = firestore['jasaName'],
        jasaHarga = firestore['jasaHarga'],
        // jasaUnit = firestore['jasaUnit'],
        jasaServices = firestore['jasaServices'],
        jasaAvailable = firestore['jasaAvailable'],
        jasaTimes = firestore['jasaTimes'],
        jasaImage = firestore['jasaImage'],
        jasaNote = firestore['jasaNote'],
        jasaId = firestore['jasaId'],
        vendorId = firestore['vendorId'],
        createdAt = firestore['createdAt'],
        createdBy = firestore['createdBy'],
        ownerImage = firestore['ownerImage'],
        approved = firestore['approved'];
}
