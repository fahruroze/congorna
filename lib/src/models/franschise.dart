import 'package:flutter/foundation.dart';
import 'package:congorna/src/models/lokasi.dart';

class Franchise {
  final String title;
  final String waktuBuka;
  final String waktuTutup;
  final Lokasi lokasi; //sub Object
  final bool terimaPesanan;
  final String franchiseId;

  Franchise({
    @required this.title,
    @required this.waktuBuka,
    @required this.waktuTutup,
    @required this.lokasi,
    @required this.franchiseId,
    this.terimaPesanan = false,
  });

  Franchise.fromFirestore(Map<String, dynamic> firestore)
      : title = firestore['title'],
        waktuBuka = firestore['waktuBuka'],
        waktuTutup = firestore['waktuTutup'],
        lokasi = Lokasi.fromFirestore(firestore['lokasi']),
        franchiseId = firestore['franchiseId'],
        terimaPesanan = firestore['terimaPesanan'];
}
