import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Order {
  final String orderId;
  final String latlongPelanggan;
  final String latlongPejasa;
  final String jasaName;
  final double jasaHarga;
  final String jasaTimes;
  final String jasaImages;
  final String longPelanggan;
  final String latPejasa;
  final String longPejasa;

  final String vendorId;
  final String jasaId;

  final String orderBy;
  final String pickUpBy;
  final Timestamp orderAt;

  Order({
    this.latlongPelanggan,
    this.latlongPejasa,
    this.longPelanggan,
    this.latPejasa,
    this.longPejasa,
    this.jasaName,
    this.jasaHarga,
    this.jasaTimes,
    this.jasaImages,
    this.pickUpBy,
    this.orderBy,
    this.orderAt,
    this.orderId,
    this.vendorId,
    this.jasaId,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'vendorId': vendorId,
      'jasaId': jasaId,
      'latlongPelanggan': latlongPelanggan,
      'jasaName': jasaName,
      'jasaHarga': jasaHarga,
      'jasaTimes': jasaTimes,
      'jasaImages': jasaImages,
      'latlongPejasa': latlongPejasa,
      'longPelanggan': longPelanggan,
      'latPejasa': latPejasa,
      'longPejasa': longPejasa,
      'orderAt': orderAt,
      'orderBy': orderBy
    };
  }

  Order.fromFirestore(Map<String, dynamic> firestore)
      : pickUpBy = firestore['pickUpBy'],
        latlongPelanggan = firestore['latlongPelanggan'],
        latlongPejasa = firestore['latlongPejasa'],
        jasaName = firestore['jasaName'],
        jasaHarga = firestore['jasaHarga'],
        jasaTimes = firestore['jasaTimes'],
        jasaImages = firestore['jasaImages'],
        longPelanggan = firestore['longPelanggan'],
        latPejasa = firestore['latPejasa'],
        longPejasa = firestore['longPejasa'],
        orderAt = firestore['orderAt'],
        orderId = firestore['orderId'],
        vendorId = firestore['vendorId'],
        jasaId = firestore['jasaId'],
        orderBy = firestore['orderBy'];
}
