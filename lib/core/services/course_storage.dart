import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class CourseStorage {
  final courseStorage = FirebaseStorage.instance.ref();
  Future<String> uploadCourseImage(String path, String courseTitle) async {
    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': path},
    );
    await courseStorage
        .child('courses/$courseTitle/$courseTitle')
        .putFile(File(path), metadata);
    return courseStorage
        .child('courses/$courseTitle/$courseTitle')
        .getDownloadURL();
  }

  Future<String> uploadLessonFile(
      String path, String courseTitle, String lessonTitle) async {
    await courseStorage
        .child('courses/$courseTitle/lessons/$lessonTitle')
        .putFile(File(path));
    return courseStorage
        .child('courses/$courseTitle/$courseTitle')
        .getDownloadURL();
  }

  Future<void> deleteStorage() async {
    return await FirebaseStorage.instance.ref('courses/').delete();
  }

  Future<void> deleteItemByName(String path) async {
    final file = FirebaseStorage.instance.ref('courses/').child(path);
    return await file.delete();
  }

  Future<void> deleteItemByUrl(String url) async {
    final file = FirebaseStorage.instance.refFromURL(url);
    return await file.delete();
  }
}
