import 'package:congorna/src/services/firestore_service.dart';
import 'package:congorna/src/models/franschise.dart';
import 'package:flutter/material.dart';

class CustomerBloc {
  final db = FirestoreService();

  Stream<List<Franchise>> get fetchFranchiseBaru => db.fetchFranchiseBaru();

  dispose() {}
}
