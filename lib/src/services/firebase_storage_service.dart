import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final storage =
      FirebaseStorage.instance; // instance fitur FIREBASE STORAGE TO FLUTTER

  //function to upload image to FIREBASE STORAGE
  Future<String> uploadJasaImage(File file, String fileName) async {
    var snapshot = await storage
        .ref()
        .child('jasaImages/$fileName')
        .putFile(file)
        .onComplete;

    return await snapshot.ref.getDownloadURL();
  }
}
