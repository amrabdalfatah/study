import 'package:firebase_storage/firebase_storage.dart';

class ChatStorage {
  final Reference chatStorage = FirebaseStorage.instance.ref();

  Future<void> deleteStorage(String nameChat) async {
    return await chatStorage.child('/chats/$nameChat}').delete();
  }

  // Future<void> deleteItemByName(String path) async {
  //   final file = chatStorage.child("chats/$path");
  //   return await file.delete();
  // }

  Future<void> deleteItemByUrl(String url) async {
    final file = FirebaseStorage.instance.refFromURL(url);
    return await file.delete();
  }
}
