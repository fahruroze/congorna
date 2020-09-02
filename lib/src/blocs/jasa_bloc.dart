import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:congorna/src/models/order.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:congorna/src/models/jasa.dart';
// import 'package:kumbahapp/src/models/user.dart';
import 'package:congorna/src/services/firebase_storage_service.dart';
import 'package:congorna/src/services/firestore_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';
import 'package:uuid/uuid.dart';

class JasaBloc {
  final _jasaName = BehaviorSubject<String>();
  final _jasaHarga = BehaviorSubject<String>();
  final _jasaServices = BehaviorSubject<String>();
  final _jasaTimes = BehaviorSubject<String>();
  final _jasaImage = BehaviorSubject<String>();
  final _vendorId = BehaviorSubject<String>();

  final _jasaId = BehaviorSubject<String>();

  // final _createdAt = BehaviorSubject<DateTime>();
  // final _createdBy = BehaviorSubject<String>();

  final _jasaSaved = PublishSubject<bool>();
  final _jasa = BehaviorSubject<Jasa>();
  final _isUploading = BehaviorSubject<bool>();
  final db = FirestoreService();
  var uuid = Uuid();
  final _picker = ImagePicker(); //ambil gambar
  final storageService = FirebaseStorageService();

  //GET data

  Stream<String> get jasaName => _jasaName.stream.transform(validateJasaName);
  Stream<double> get jasaHarga =>
      _jasaHarga.stream.transform(validateJasaHarga);
  Stream<String> get jasaServices =>
      _jasaServices.stream.transform(validateJasaServices);
  Stream<String> get jasaTimes =>
      _jasaTimes.stream.transform(validateJasaTimes);
  Stream<String> get jasaImage => _jasaImage.stream;
  // Stream<DateTime> get createdAt => _createdAt.stream; //new
  // Stream<String> get createdBy => _createdBy.stream; //new
  Stream<bool> get isValid => CombineLatestStream.combine4(
      jasaName, jasaHarga, jasaServices, jasaTimes, (a, b, c, d) => true);

  Stream<List<Jasa>> jasaByVendorId(String vendorId) =>
      db.fetchJasaByVendorId(vendorId); //add userId as vendorId

  Stream<List<Jasa>> jasaByJasaId() => db.fetchJasaByJasaId();

  Stream<bool> get jasaSaved => _jasaSaved.stream;
  Future<Jasa> fetchJasa(String jasaId) => db.fetchJasa(jasaId);
  Stream<bool> get isUploading => _isUploading.stream;
  String get jasaId => _jasa.value.jasaId;

  //SetBlocProvider.of<NavigatorBloc>(context).dispatch(NavigateToHomeEvent());
  Function(String) get changeJasaName => _jasaName.sink.add;
  Function(String) get changeJasaHarga => _jasaHarga.sink.add;
  Function(String) get changeJasaServices => _jasaServices.sink.add;
  Function(String) get changeJasaTimes => _jasaTimes.sink.add;
  Function(String) get changeJasaImage => _jasaImage.sink.add;
  Function(String) get changeVendorId => _vendorId.sink.add;

  Function(String) get changeJasaId => _jasaId.sink.add;

  // Function(DateTime) get changeCreatedAt => _createdAt.sink.add;
  // Function(String) get changeCreatedBy => _createdBy.sink.add;

  Function(Jasa) get changeJasa => _jasa.sink.add;

//dispose

  dispose() {
    _jasaName.close();
    _jasaHarga.close();
    _jasaServices.close();
    _jasaTimes.close();
    _vendorId.close();
    _jasaId.close();
    // _createdAt.close();
    // _createdBy.close();
    _jasaSaved.close();
    _jasa.close();
    _jasaImage.close();
    _isUploading.close();
  }

  //FUNCTION SECTION

  Future<void> saveJasa() async {
    DateTime date = DateTime.now();

    var waktu = new Timestamp.fromDate(date);

    FirebaseUser profile = await FirebaseAuth.instance.currentUser();

    print('SAVE BY: ${profile.displayName}');

    var jasa = Jasa(
      approved: (_jasa.value == null) ? false : _jasa.value.approved,
      jasaId: (_jasa.value == null) ? uuid.v4() : _jasa.value.jasaId,
      jasaName: _jasaName.value.trim(),
      jasaHarga: double.parse(_jasaHarga.value),
      jasaServices: _jasaServices.value.trim(),
      jasaTimes: _jasaTimes.value,
      vendorId: _vendorId.value,
      jasaImage: _jasaImage.value,
      createdBy: profile.displayName,
      ownerImage: profile.photoUrl,
      createdAt: waktu,
    );

    return db
        .setJasa(jasa)
        .then((value) => _jasaSaved.sink.add(true))
        .catchError((error) => print(error));
  }

  // Future<void> setOrder() async {
  //   DateTime date = DateTime.now();

  //   var waktu = new Timestamp.fromDate(date);

  //   FirebaseUser profile = await FirebaseAuth.instance.currentUser();

  //   print('SAVE BY: ${profile.displayName}');

  //   var order = Order(
  //     approved: (_jasa.value == null) ? false : _jasa.value.approved,
  //     orderId: (_jasa.value == null) ? uuid.v4() : _jasa.value.jasaId,
  //     jasaName: _jasaName.value.trim(),
  //     jasaHarga: double.parse(_jasaHarga.value),
  //     jasaServices: _jasaServices.value.trim(),
  //     jasaTimes: _jasaTimes.value,
  //     vendorId: _vendorId.value,
  //     jasaImage: _jasaImage.value,
  //     orderBy: profile.displayName,
  //     orderAt: waktu,
  //     ownerImage: profile.photoUrl,
  //     // createdAt: waktu,
  //   );

  //   return db
  //       .setOrder(order)
  //       .then((value) => _orderSaved.sink.add(true))
  //       .catchError((error) => print(error));
  // }

  pickImage() async {
    PickedFile image;
    File croppedFile;

//permission for take photo
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
//Get Image From Device
      image = await _picker.getImage(source: ImageSource.gallery);
//Upload to firebase
      print(image.path);
      if (image != null) {
        //SPINEER LOADING
        _isUploading.sink.add(true);

        //get IMAGE PROPERTIES
        ImageProperties properties =
            await FlutterNativeImage.getImageProperties(image.path);

        //CROPPING IMAGE
        // image potrait
        if (properties.height > properties.width) {
          var yoffset = (properties.height - properties.width) / 2;
          croppedFile = await FlutterNativeImage.cropImage(image.path, 0,
              yoffset.toInt(), properties.width, properties.width);
          // image landscape
        } else if (properties.width > properties.height) {
          var xoffset = (properties.width - properties.height) / 2;
          croppedFile = await FlutterNativeImage.cropImage(image.path,
              xoffset.toInt(), 0, properties.height, properties.height);
        } else {
          //doing nothing
          croppedFile = File(image.path);
        }

        //COMPRESS FILE IMAGE
        File compressedFile = await FlutterNativeImage.compressImage(
            croppedFile.path,
            quality: 100,
            targetHeight: 600,
            targetWidth: 600);

        //get URL image
        var jasaImage =
            await storageService.uploadJasaImage(compressedFile, uuid.v4());

        changeJasaImage(jasaImage);
        _isUploading.sink.add(false);

        // print(jasaImage);
      } else {
        print('Tidak ada path yang diterima');
      }
    } else {
      print('Allow Permission dan coba lagi');
    }
  }

  //VALIDATOR
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

  final validateJasaTimes = StreamTransformer<String, String>.fromHandlers(
      handleData: (jasaTimes, sink) {
    if (jasaTimes != null) {
      try {
        sink.add(jasaTimes.trim());
      } catch (e) {
        sink.addError('Isi waktu pengerjaan jasa');
      }
    }
  });

  final validateJasaServices = StreamTransformer<String, String>.fromHandlers(
      handleData: (jasaServices, sink) {
    if (jasaServices != null) {
      if (jasaServices.length >= 4 && jasaServices.length <= 30) {
        sink.add(jasaServices.trim());
      } else {
        if (jasaServices.length < 4) {
          sink.addError('Minimal 4 Karakter');
        } else {
          sink.addError('Maksimal 30 Karakter');
        }
      }
    }
  });

  final validateJasaName = StreamTransformer<String, String>.fromHandlers(
      handleData: (jasaName, sink) {
    if (jasaName != null) {
      if (jasaName.length >= 4 && jasaName.length <= 20) {
        sink.add(jasaName.trim());
      } else {
        if (jasaName.length < 4) {
          sink.addError('Minimal 4 Karakter');
        } else {
          sink.addError('Maksimal 20 Karakter');
        }
      }
    }
  });

  // void changeJasaHarga(double jasaHarga) {}
}
