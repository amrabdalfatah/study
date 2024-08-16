import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_academy/model/course_model.dart';

class FireStoreCourse {
  final CollectionReference _courseCollectionRef =
      FirebaseFirestore.instance.collection('Courses');

  Future<void> addCourseToFirestore(CourseModel course) async {
    return await _courseCollectionRef.doc(course.courseId).set(
          course.toJson(),
        );
  }

  Future<DocumentSnapshot> getCurrentCourse(String cid) async {
    return await _courseCollectionRef.doc(cid).get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllCourses() {
    return _courseCollectionRef.firestore.collection('Courses').snapshots();
  }

  Future<void> updateCourseInfo({
    required String key,
    required dynamic value,
    required String courseId,
  }) async {
    return await _courseCollectionRef.doc(courseId).update({
      key: value,
    });
  }

  Future<void> deleteCourse(String mid) async {
    return await _courseCollectionRef.doc(mid).delete();
  }
}
