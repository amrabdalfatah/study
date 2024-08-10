import 'package:firebase_storage/firebase_storage.dart';

class IntrudersStorage {
  final Reference intruderStorage = FirebaseStorage.instance.ref();

  Future<void> deleteStorage() async {
    return await intruderStorage.child('/intruders').delete();
  }

  Future<void> deleteItemByName(String path) async {
    final file = intruderStorage.child("intruders/$path");
    return await file.delete();
  }

  Future<void> deleteItemByUrl(String url) async {
    final file = FirebaseStorage.instance.refFromURL(url);
    return await file.delete();
  }
}