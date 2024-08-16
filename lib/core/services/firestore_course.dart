import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_academy/model/course_model.dart';
import 'package:study_academy/model/lesson_model.dart';

class FireStoreCourse {
  final CollectionReference _courseCollectionRef =
      FirebaseFirestore.instance.collection('Courses');

  Future<void> addCourseToFirestore(CourseModel course) async {
    return await _courseCollectionRef.doc(course.courseId).set(
          course.toJson(),
        );
  }

  Future<void> addLessonToCourse(String courseId, LessonModel lesson) async {
    return await _courseCollectionRef
        .doc(courseId)
        .collection('Lessons')
        .doc(lesson.lessonId)
        .set(
          lesson.toJson(),
        );
  }

  Future<DocumentSnapshot> getCurrentCourse(String cid) async {
    return await _courseCollectionRef.doc(cid).get();
  }

  Future<DocumentSnapshot> getCurrentLesson(String cid, String lessonId) async {
    return await _courseCollectionRef
        .doc(cid)
        .collection('Lessons')
        .doc(lessonId)
        .get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllCourses() {
    return _courseCollectionRef.firestore.collection('Courses').snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllLessons(String courseId) {
    return _courseCollectionRef.firestore
        .collection('Courses')
        .doc(courseId)
        .collection('Lessons')
        .snapshots();
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

  Future<void> updateLessonInfo({
    required String key,
    required dynamic value,
    required String lessonId,
    required String courseId,
  }) async {
    return await _courseCollectionRef
        .doc(courseId)
        .collection('Lessons')
        .doc(lessonId)
        .update({
      key: value,
    });
  }

  Future<void> deleteCourse(String mid) async {
    return await _courseCollectionRef.doc(mid).delete();
  }

  Future<void> deleteLesson(String mid, String lessonId) async {
    return await _courseCollectionRef
        .doc(mid)
        .collection('Lessons')
        .doc(lessonId)
        .delete();
  }
}
