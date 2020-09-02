import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Lokasi {
  final String nama;
  final String alamat;
  final String kota;
  final String negara;
  final GeoPoint geo;
  final String lokasiId;

  Lokasi({
    @required this.nama,
    @required this.alamat,
    @required this.kota,
    @required this.negara,
    this.geo,
    this.lokasiId,
  });

  Lokasi.fromFirestore(Map<String, dynamic> firestore)
      : nama = firestore['nama'],
        alamat = firestore['alamat'],
        kota = firestore['kota'],
        negara = firestore['negara'],
        geo = firestore['geo'] ?? null,
        lokasiId = firestore['lokasiId'] ?? null;
}
