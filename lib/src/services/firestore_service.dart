import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:congorna/src/models/franschise.dart';
import 'package:congorna/src/models/jasa.dart';
import 'package:congorna/src/models/mahasiswa.dart';
import 'package:congorna/src/models/order.dart';
// import 'package:congorna/src/models/pejasa.dart';

class FirestoreService {
//DB INSTANCE
  Firestore _db = Firestore.instance;

  // Firestore increment = Firestore().FieldValue.increment(1);
//Pejasa PART
  Future<void> addUser(Mahasiswa mahasiswa) {
    var increment = FieldValue.increment(1);

    var mhsColl = _db.collection('mahasiswa').document(mahasiswa.mahasiswaId);
    var mhsCount = _db.collection('mahasiswa').document('mahasiswa_counter');

    var batch = _db.batch();
    batch.setData(mhsColl, mahasiswa.toMap());
    batch.setData(mhsCount, {'counter': increment}, merge: true);

    return batch.commit();

    // return _db.collection('users').document(user.userId).setData(user.toMap());
  }

  Future<Mahasiswa> fetchUser(String mahasiswaId) {
    return _db
        .collection('mahasiswa')
        .document(mahasiswaId)
        .get()
        .then((snapshot) => Mahasiswa.fromFirestore(snapshot.data));
  }

  Stream<List<String>> fetchTimes() {
    return _db.collection('times').document('hari').snapshots().map(
        (snapshot) => snapshot.data['production']
            .map<String>((type) => type.toString())
            .toList());
  }

//JASA PART

//Add Jasa from user frontend
  Future<void> setJasa(Jasa jasa) {
    var increment = FieldValue.increment(1);
    var decrement = FieldValue.increment(-1);
    var mahasiswa = Mahasiswa();

    var statsRef = _db.collection('jasa').document('counter');
    var jasaRef = _db.collection('jasa').document(jasa.jasaId);

    var stats2Ref = _db.collection('mahasiswa').document('counter');
    var vendorRef = _db.collection('jasa').document(jasa.vendorId);

    var batch = _db.batch();

    //JASA COUNTER
    batch.setData(
      jasaRef,
      jasa.toMap(),
    );
    batch.setData(statsRef, {'jasaCount': increment}, merge: true);

    //USERS COUNTER
    batch.setData(
      vendorRef,
      mahasiswa.toMap(),
    );
    batch.setData(stats2Ref, {'userCount': increment}, merge: true);
    // batch.setData(statsRef, {'jasaCount': decrement}, merge: true);
    // batch.setData(jasa.toMap());
    return batch.commit();
    // return _db.collection('jasa').document(jasa.jasaId).setData(jasa.toMap());
  }

  Future<void> setOrder(Order order) {
    var increment = FieldValue.increment(1);
    var decrement = FieldValue.increment(-1);

    var statsRef = _db.collection('order').document('counter');
    var jasaRef = _db.collection('order').document(order.orderId);

    var batch = _db.batch();

    //JASA COUNTER
    batch.setData(
      jasaRef,
      order.toMap(),
    );
    batch.setData(statsRef, {'orderCount': increment}, merge: true);

    return batch.commit();
  }

//Fetch Jasa from JASAID

// db.collection('objects').where('ID', '==', ID).limit(1).get().then((query) => {
//         const thing = query.docs[0];
//         var currVal = thing.data().value;
//         const newVal = currVal - minus;
//         thing.ref.update({value:newVal});
//     });

  Future<Jasa> fetchJasa(String jasaId) {
    return _db
        .collection('jasa')
        .document(jasaId)
        .get()
        .then((snapshot) => Jasa.fromFirestore(snapshot.data));
  }

  //Fetch Data from firebase with convert toList() for view DATALIST JASA
  Stream<List<Jasa>> fetchJasaByVendorId(String vendorId) {
    return _db
        .collection('jasa')
        .where('vendorId', isEqualTo: vendorId)
        .where('approved', isEqualTo: true)
        .snapshots()
        .map((query) => query.documents)
        .map((snapshot) => snapshot
            .map((document) => Jasa.fromFirestore(document.data))
            .toList());
  }

  // Stream<List<String>> fetchTimes() {
  //   return _db.collection('times').document('hari').snapshots().map(
  //       (snapshot) => snapshot.data['production']
  //           .map<String>((type) => type.toString())
  //           .toList());

  Stream<List<Jasa>> fetchJasaByJasaId() {
    return _db
        .collection('jasa')
        .where('approved', isEqualTo: true)
        .snapshots()
        .map((query) => query.documents)
        .map((snapshot) => snapshot
            .map((document) => Jasa.fromFirestore(document.data))
            .toList());
  }

  //FRANCHISE PART

  Stream<List<Franchise>> fetchFranchiseBaru() {
    return _db
        .collection('franchises')
        .where('waktuTutup',
            isGreaterThan:
                DateTime.now().toIso8601String()) //for easy compare date
        .snapshots()
        .map((query) => query.documents)
        .map((snapshot) => snapshot
            .map((document) => Franchise.fromFirestore(document.data))
            .toList());
  }
}
