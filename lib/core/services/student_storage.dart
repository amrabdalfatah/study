import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StudentStorage {
  final studentStorage = FirebaseStorage.instance.ref();
  Future<String> uploadStudentImage(String path, String studentEmail) async {
    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': path},
    );
    await studentStorage
        .child('students/$studentEmail')
        .putFile(File(path), metadata);
    return studentStorage.child('students/$studentEmail').getDownloadURL();
  }

  Future<void> deleteStorage() async {
    return await FirebaseStorage.instance.ref('students/').delete();
  }

  Future<void> deleteItemByName(String path) async {
    final file = FirebaseStorage.instance.ref('students/').child(path);
    return await file.delete();
  }

  Future<void> deleteItemByUrl(String url) async {
    final file = FirebaseStorage.instance.refFromURL(url);
    return await file.delete();
  }
}
