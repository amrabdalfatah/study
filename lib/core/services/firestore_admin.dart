import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_academy/model/admin_model.dart';

class FireStoreAdmin {
  final CollectionReference _userCollectionRef =
      FirebaseFirestore.instance.collection('Admin');

  Future<QuerySnapshot> getUsers() async {
    return await _userCollectionRef.get();
  }

  Future<void> addUserToFirestore(AdminModel adminModel) async {
    return await _userCollectionRef.doc(adminModel.adminId).set(
          adminModel.toJson(),
        );
  }

  checkUser(String uid) async {
    var data = await _userCollectionRef.doc(uid).get();
    return data.exists;
  }

  Future<DocumentSnapshot> getCurrentUser(String uid) async {
    return await _userCollectionRef.doc(uid).get();
  }

  Future<void> updateUserInfo({
    required String key,
    required dynamic value,
    required AdminModel adminModel,
  }) async {
    return await _userCollectionRef.doc(adminModel.adminId).update({
      key: value,
    });
  }
}
