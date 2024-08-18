import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class AdminStorage {
  final adminStorage = FirebaseStorage.instance.ref();
  Future<String> uploadAdminImage(String path) async {
    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': path},
    );
    await adminStorage.child('admin/logo').putFile(File(path), metadata);
    return adminStorage.child('doctors/logo').getDownloadURL();
  }

  Future<void> deleteLogo() async {
    return await adminStorage.child('admin/logo').delete();
  }
}
