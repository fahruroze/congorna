import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:congorna/src/models/order.dart';
import 'package:congorna/src/services/firestore_service.dart';
import 'package:congorna/src/widgets/appstate.dart';
import 'package:congorna/src/widgets/orders.dart';
import 'package:congorna/src/widgets/orders2.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:uuid/uuid.dart';
import 'package:location/location.dart' as locData;

class OrderBloc {
  final _orderId = BehaviorSubject<String>();
  final _jasaId = BehaviorSubject<String>();
  final _vendorId = BehaviorSubject<String>();
  final _order = BehaviorSubject<Order>();

  final _latlongPelanggan = BehaviorSubject<String>();
  final _latlongPejasa = BehaviorSubject<String>();
  final _jasaName = BehaviorSubject<String>();
  final _jasaHarga = BehaviorSubject<String>();
  final _jasaServices = BehaviorSubject<String>();
  final _jasaTimes = BehaviorSubject<String>();
  final _jasaImage = BehaviorSubject<String>();

  final _longPelanggan = BehaviorSubject<String>();
  final _latPejasa = BehaviorSubject<String>();
  final _longPejasa = BehaviorSubject<String>();

  final _pickupBy = BehaviorSubject<String>();

  final _orderAt = BehaviorSubject<String>();
  final _orderBy = BehaviorSubject<String>();

  final _pelangganName = BehaviorSubject<String>();
  final _pejasaName = BehaviorSubject<String>();

  final _orderSaved = PublishSubject<bool>();

  var uuid = Uuid(); //RANDOM string
  final db = FirestoreService();

  //MAP variable
  AppState appState;
  static LatLng _initialPosition;
  locData.Location _locationTracker = locData.Location();
  LatLng get initialPosition => _initialPosition;
  var lokasiLatitude;
  var lokasiLongitude;
  var initPostition;

  //GET data
  Stream<String> get orderId => _orderId.stream;
  Stream<String> get jasaId => _jasaId.stream;
  Stream<String> get pejasaName => _pejasaName.stream;
  Stream<String> get pelangganName => _pelangganName.stream;
  Stream<String> get latlongPelanggan => _latlongPelanggan.stream;
  Stream<String> get latlongPejasa => _latlongPejasa.stream;
  Stream<String> get longPelanggan => _longPelanggan.stream;
  Stream<String> get latPejasa => _latPejasa.stream;
  Stream<String> get longPejasa => _longPejasa.stream;
  Stream<String> get pickupBy => _pickupBy.stream;
  Stream<String> get orderAt => _orderAt.stream;
  Stream<String> get orderBy => _orderBy.stream;

  Stream<String> get jasaName => _jasaName.stream;
  Stream<double> get jasaHarga =>
      _jasaHarga.stream.transform(validateJasaHarga);
  Stream<String> get jasaServices => _jasaServices.stream;
  Stream<String> get jasaTimes => _jasaTimes.stream;
  Stream<String> get jasaImage => _jasaImage.stream;

  Stream<bool> get orderSaved => _orderSaved.stream;

  //SET data
  Function(String) get changePelangganName => _pejasaName.sink.add;
  Function(String) get changePejasaName => _pelangganName.sink.add;

  Function(String) get changeLatLongPelanggan => _latlongPelanggan.sink.add;
  Function(String) get changeLatLongPejasa => _latlongPejasa.sink.add;
  Function(String) get changeJasaName => _jasaName.sink.add;
  Function(String) get changeJasaHarga => _jasaHarga.sink.add;
  Function(String) get changeJasaServices => _jasaServices.sink.add;
  Function(String) get changeJasaTimes => _jasaTimes.sink.add;
  Function(String) get changeJasaImage => _jasaImage.sink.add;
  Function(String) get changeVendorId => _vendorId.sink.add;

  Function(String) get changeLongPelanggan => _longPelanggan.sink.add;
  Function(String) get changeLatPejasa => _latPejasa.sink.add;
  Function(String) get changeLongPejasa => _longPejasa.sink.add;
  Function(String) get changeOrderAt => _orderAt.sink.add;
  Function(String) get changeOrderBy => _orderBy.sink.add;
  Function(String) get changeJasaId => _jasaId.sink.add;
  Function(Order) get changeOrder => _order.sink.add;

  dispose() {
    _orderId.close();
    _vendorId.close();
    _jasaId.close();

    // _pejasaName.close();
    _latPejasa.close();
    _longPejasa.close();

    // _pelangganName.close();
    _latlongPelanggan.close();
    _latlongPejasa.close();
    _longPelanggan.close();

    _jasaName.close();
    _jasaHarga.close();
    _jasaServices.close();
    _jasaTimes.close();
    _jasaImage.close();
    _orderAt.close();
    _orderBy.close();
    _pickupBy.close();
    _order.close();

    _orderSaved.close();
  }

  // appState.getUserLocation();
//FUNCTION section

  Future<String> getPelangganLocation() async {
    print("GET USER METHOD RUNNING =========");
    print("GET USER METHOD RUNNING order bloc");

    //Position position = await Geolocator()
    //    .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    //List<Placemark> placemark = await Geolocator()
    //    .placemarkFromCoordinates(position.latitude, position.longitude);
    var location = await _locationTracker.getLocation();
    _initialPosition = LatLng(location.latitude, location.longitude);
    print(
        "the latitude is: ${location.latitude} and th longitude is: ${location.longitude} ");
    print("initial position is : ${_initialPosition.toString()}");
    //locationController.text = placemark[0].name;
    // notifyListeners();
    return _initialPosition.toString();
  }

  //FUNCTION section
  Future<void> saveOrder({BuildContext context}) async {
    print('SAVE DUDE');
    DateTime date = DateTime.now();
    var waktu = new Timestamp.fromDate(date);

    FirebaseUser profile = await FirebaseAuth.instance.currentUser();
    print('SAVE BY: ${profile.displayName}');

    print('FUNCTION ');
    // var lokasi = await appState.getUserLocation().then((coba) => coba);
    var lok = await getPelangganLocation();
    const start = "(";
    const end = ")";
    final startIndex = lok.indexOf(start);
    final endIndex = lok.indexOf(end, startIndex + start.length);
    print('LOKASI PELANGGAN');
    var getLatLong = lok.substring(startIndex + start.length, endIndex);

    var order = Order(
      orderId: (_order.value == null) ? uuid.v4() : _order.value.orderId,
      vendorId: _vendorId.value,
      jasaId: _jasaId.value,
      latlongPelanggan: getLatLong,
      jasaName: _jasaName.value.trim(),
      jasaHarga: double.parse(_jasaHarga.value),
      jasaTimes: _jasaTimes.value,

      jasaImages: _jasaImage.value,
      // latlongPejasa: getLatLong,
      // latPelanggan: _latPejasa.value,
      // longPelanggan: _longPelanggan.value,
      // latPejasa: _latPejasa.value,
      // longPejasa: _longPejasa.value,
      pickUpBy: _pickupBy.value,
      orderBy: profile.displayName,
      orderAt: waktu,
    );

//    db
//        .setOrder(order)
//        .then((value) => _orderSaved.sink.add(true))
//        .catchError((error) => print(error))
//        .then((value) {});
    ProgressDialog pg=new ProgressDialog(context,title: Text("Loading"));
    pg.show();
    Dio dio=new Dio();


    Response response=await dio.post("http://101.50.0.106:9090/store_order",data: {
      "vendorId" : "null",
      "jasaId" : "${_jasaId.value}",
      "latlongPelanggan" : "${getLatLong.toString()}",
      "jasaName" : "${_jasaName.value.trim()}",
      "jasaHarga"  : "${_jasaHarga.value}",
      "jasaTimes" : "${DateTime.now()}",
      "pickUpBy" : "${_pickupBy.value}",
      "orderBy" : "${profile.displayName}",
      "orderAt" : "$waktu",
      "status"  : "Pending",
      "latlongPejasa" : "323323,2323",
      "latlongPejasa" : "323323,2323",
      "jasaImages" : "${_jasaImage.value}"
     });
    print(response.data);
    if(response.statusCode==200){
      pg.dismiss();
    }
    print('PUSH KE ORDERS');
    // return Navigator.pushNamed(context, '/pickup');

    return Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Orders()));
  }

  final validateJasaHarga = StreamTransformer<String, double>.fromHandlers(
      handleData: (jasaHarga, sink) {
    if (jasaHarga != null) {
      try {
        sink.add(double.parse(jasaHarga));
      } catch (e) {
        sink.addError('Harus Berupa Angka');
      }
    }
  });
}
