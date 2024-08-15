import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class DoctorStorage {
  final doctorStorage = FirebaseStorage.instance.ref();
  Future<String> uploadDoctorImage(String path, String doctorEmail) async {
    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': path},
    );
    await doctorStorage
        .child('doctors/$doctorEmail')
        .putFile(File(path), metadata);
    return doctorStorage.child('doctors/$doctorEmail').getDownloadURL();
  }

  Future<void> deleteStorage() async {
    return await FirebaseStorage.instance.ref('doctors/').delete();
  }

  Future<void> deleteItemByName(String path) async {
    final file = FirebaseStorage.instance.ref('doctors/').child(path);
    return await file.delete();
  }

  Future<void> deleteItemByUrl(String url) async {
    final file = FirebaseStorage.instance.refFromURL(url);
    return await file.delete();
  }
}
