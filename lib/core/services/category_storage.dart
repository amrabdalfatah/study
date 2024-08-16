import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class CategoryStorage {
  final categoryStorage = FirebaseStorage.instance.ref();
  Future<String> uploadCategoryImage(String path, String categoryTitle) async {
    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': path},
    );
    await categoryStorage
        .child('categories/$categoryTitle')
        .putFile(File(path), metadata);
    return categoryStorage.child('categories/$categoryTitle').getDownloadURL();
  }

  Future<void> deleteStorage() async {
    return await FirebaseStorage.instance.ref('categories/').delete();
  }

  Future<void> deleteItemByName(String path) async {
    final file = FirebaseStorage.instance.ref('categories/').child(path);
    return await file.delete();
  }

  Future<void> deleteItemByUrl(String url) async {
    final file = FirebaseStorage.instance.refFromURL(url);
    return await file.delete();
  }
}
