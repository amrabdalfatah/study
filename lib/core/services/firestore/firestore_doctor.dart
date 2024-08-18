import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_academy/model/doctor_model.dart';

class FireStoreDoctor {
  final CollectionReference _doctorCollectionRef =
      FirebaseFirestore.instance.collection('Doctors');

  Future<void> addDoctorToFirestore(DoctorModel doctor) async {
    return await _doctorCollectionRef.doc(doctor.doctorId).set(
          doctor.toJson(),
        );
  }

  checkDoctor(String uid) async {
    var data = await _doctorCollectionRef.doc(uid).get();
    return data.exists;
  }

  Future<DocumentSnapshot> getCurrentDoctor(String mid) async {
    return await _doctorCollectionRef.doc(mid).get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllDoctors() {
    return _doctorCollectionRef.firestore.collection('Doctors').snapshots();
  }

  Future<void> updateDoctorInfo({
    required String key,
    required dynamic value,
    required String doctorId,
  }) async {
    return await _doctorCollectionRef.doc(doctorId).update({
      key: value,
    });
  }

  Future<void> deleteDoctor(String mid) async {
    return await _doctorCollectionRef.doc(mid).delete();
  }
}
