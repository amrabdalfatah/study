import 'package:firebase_storage/firebase_storage.dart';

class StudentStorage {
  final Reference studentStorage = FirebaseStorage.instance.ref();

  Future<void> deleteStorage() async {
    return await studentStorage.child('/students').delete();
  }

  Future<void> deleteItemByName(String path) async {
    final file = studentStorage.child("students/$path");
    return await file.delete();
  }

  Future<void> deleteItemByUrl(String url) async {
    final file = FirebaseStorage.instance.refFromURL(url);
    return await file.delete();
  }
}
