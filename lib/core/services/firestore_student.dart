import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_academy/model/student_model.dart';

class FireStoreStudent {
  final CollectionReference _studentCollectionRef =
      FirebaseFirestore.instance.collection('Students');

  Future<void> addStudentToFirestore(StudentModel student) async {
    return await _studentCollectionRef.doc(student.studentId).set(
          student.toJson(),
        );
  }

  checkStudent(String uid) async {
    var data = await _studentCollectionRef.doc(uid).get();
    return data.exists;
  }

  Future<DocumentSnapshot> getCurrentStudent(String mid) async {
    return await _studentCollectionRef.doc(mid).get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllStudents() {
    return _studentCollectionRef.firestore.collection('Students').snapshots();
  }

  Future<void> updateStudentInfo({
    required String key,
    required dynamic value,
    required String studentId,
  }) async {
    return await _studentCollectionRef.doc(studentId).update({
      key: value,
    });
  }

  Future<void> deleteStudent(String mid) async {
    return await _studentCollectionRef.doc(mid).delete();
  }
}
